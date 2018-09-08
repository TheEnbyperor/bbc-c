import collections

from . import ast
from . import il
from . import ctypes
from . import decl_tree
from . import tokens


class Symbol:
    def __init__(self, name, storage, stype=None):
        self.name = name
        self.type = stype
        self.storage = storage


class VarSymbol(Symbol):
    def __init__(self, name, var_type, storage):
        super(VarSymbol, self).__init__(name, storage, var_type)
        self.il_value = il.ILValue(var_type, storage=storage, name=name)

    def __str__(self):
        return '<VAR({name}:{type}:{il_value}:{storage})>'.format(name=self.name, type=self.type,
                                                                  il_value=self.il_value, storage=self.storage)

    __repr__ = __str__


class ScopedSymbolTable(object):
    def __init__(self, scope_name, scope_level, enclosing_scope=None):
        self.symbols = collections.OrderedDict()
        self.structs = collections.OrderedDict()
        self.decl_infos = collections.OrderedDict()
        self.typedefs = collections.OrderedDict()
        self.scope_name = scope_name
        self.scope_level = scope_level
        self.enclosing_scope = enclosing_scope

    def __str__(self):
        h1 = 'SCOPE (SCOPED SYMBOL TABLE)'
        lines = ['\n', h1, '=' * len(h1)]
        for header_name, header_value in (
                ('Scope name', self.scope_name),
                ('Scope level', self.scope_level),
                ('Enclosing scope',
                 self.enclosing_scope.scope_name if self.enclosing_scope else None
                 )
        ):
            lines.append('%-15s: %s' % (header_name, header_value))
        h2 = 'Scope (Scoped symbol table) contents'
        lines.extend([h2, '-' * len(h2)])
        lines.extend(
            ('%7s: %r' % (key, value))
            for key, value in self.symbols.items()
        )
        lines.append('\n')
        s = '\n'.join(lines)
        return s

    __repr__ = __str__

    def define(self, symbol):
        self.symbols[symbol.name] = symbol

    def lookup(self, name, current_scope_only=False):
        symbol = self.symbols.get(name)
        # 'symbol' is either an instance of the Symbol class or 'None'
        if symbol is not None:
            return symbol

        if current_scope_only:
            return None

        # recursively go up the chain and lookup the name
        if self.enclosing_scope is not None:
            return self.enclosing_scope.lookup(name)

    def lookup_struct_union(self, tag):
        struct = self.structs.get(tag)
        if struct is not None:
            return struct
        if self.enclosing_scope is not None:
            return self.enclosing_scope.lookup_struct_union(tag)

    def add_struct_union(self, tag, ctype):
        if tag not in self.structs:
            self.structs[tag] = ctype

        return self.structs[tag]

    def lookup_decl(self, tag):
        if tag in self.decl_infos:
            return self.decl_infos[tag]

    def add_decl(self, tag, decl):
        self.decl_infos[tag] = decl

    def lookup_typedef(self, name):
        typedef = self.typedefs.get(name)
        if typedef is not None:
            return typedef

        if self.enclosing_scope is not None:
            return self.enclosing_scope.lookup_typedef(name)

    def add_typedef(self, name, ctype):
        if name not in self.typedefs:
            self.typedefs[name] = ctype

        return self.typedefs[name]


class SymbolTable(object):
    def __init__(self, scope):
        self.scope_name = scope.scope_name
        self.symbols = scope.symbols
        self.structs = scope.structs
        self.decl_infos = scope.decl_infos
        self.sub_scopes = []

    def set_symbols(self, scope):
        self.symbols = scope.symbols
        self.structs = scope.structs
        self.decl_infos = scope.decl_infos

    def add_scope(self, scope):
        self.sub_scopes.append(scope)

    def __str__(self):
        h1 = 'SYMBOL TABLE: ' + self.scope_name
        lines = [h1, '=' * len(h1)]
        h2 = 'Symbol table contents'
        lines.extend([h2, '-' * len(h2)])
        lines.extend(
            ('%7s: %r' % (key, value))
            for key, value in self.symbols.items()
        )
        h3 = 'Sub symbol tables'
        lines.extend([h3, '-' * len(h3)])
        lines.extend([
            "\n".join([("\t" + l) for l in str(table).splitlines()])
            for table in self.sub_scopes
        ])
        lines.append('\n')
        s = '\n'.join(lines)
        return s

    __repr__ = __str__

    def lookup(self, name, scope_name=""):
        if scope_name != "":
            scope = None
            for s in self.sub_scopes:
                if s.scope_name == scope_name:
                    scope = s
                    break
            r = scope.lookup(name)
            if r is not None:
                return r
        else:
            return self.symbols.get(name)

    def lookup_decl(self, name):
        decl = self.decl_infos.get(name)
        if decl is None:
            for scope in self.sub_scopes:
                decl = scope.lookup_decl(name)
                if decl is not None:
                    return decl
        return decl


class SymbolTableBuilder(ast.NodeVisitor):
    def __init__(self):
        self.scope = None
        self.scope_out = None

    def get_decl_infos(self, node):
        any_dec = bool(node.decls)
        base_type, storage = self.make_specs_ctype(node.specs, any_dec)

        out = []
        for decl, init in zip(node.decls, node.inits):
            ctype, identifier = self.make_ctype(decl, base_type)

            if ctype.is_function():
                param_identifiers = self.extract_params(decl)
            else:
                param_identifiers = []

            if storage == ast.DeclInfo.TYPEDEF:
                if init:
                    raise SyntaxError("Typedef can't have initaliser")

                self.scope.add_typedef(identifier.value, ctype)
            else:
                out.append(ast.DeclInfo(
                    identifier, ctype, storage, init, param_identifiers))

        return out

    def make_ctype(self, decl, prev_ctype):
        if isinstance(decl, decl_tree.Pointer):
            new_ctype = ctypes.PointerCType(prev_ctype, decl.const)
        elif isinstance(decl, decl_tree.Array):
            new_ctype = self._generate_array_ctype(decl, prev_ctype)
        elif isinstance(decl, decl_tree.Function):
            new_ctype = self._generate_func_ctype(decl, prev_ctype)
        elif isinstance(decl, decl_tree.Identifier):
            return prev_ctype, decl.identifier

        return self.make_ctype(decl.child, new_ctype)

    def extract_params(self, decl):
        identifiers = []
        func_decl = None
        while decl and not isinstance(decl, decl_tree.Identifier):
            if isinstance(decl, decl_tree.Function):
                func_decl = decl
            decl = decl.child

        if not func_decl:
            err = "function definition missing parameter list"
            raise SyntaxError(err)

        for param in func_decl.args:
            if param.specs[0].type == tokens.ELLIPSIS:
                break
            decl_info = self.get_decl_infos(param)[0]
            identifiers.append(decl_info.identifier)

        return identifiers

    def _generate_array_ctype(self, decl, prev_ctype):
        if decl.n:
            return ctypes.ArrayCType(prev_ctype, decl.n)
        else:
            return ctypes.ArrayCType(prev_ctype, None)

    def _generate_func_ctype(self, decl, prev_ctype):
        # Prohibit storage class specifiers in parameters.
        is_varags = False
        args = []
        for param in decl.args:
            if param.specs[0].type == tokens.ELLIPSIS:
                is_varags = True
                break
            decl_info = self.get_decl_infos(param)[0]
            if decl_info.storage:
                err = "storage class specified for function parameter"
                raise SyntaxError(err)
            args.append(decl_info.ctype)

        # adjust array and function parameters
        has_void = False
        for i in range(len(args)):
            ctype = args[i]
            if ctype.is_array():
                args[i] = ctypes.PointerCType(ctype.el)
            elif ctype.is_function():
                args[i] = ctypes.PointerCType(ctype)
            elif ctype.is_void():
                has_void = True
        if has_void and len(args) > 1:
            err = "'void' must be the only parameter"
            raise SyntaxError(err)
        if prev_ctype.is_function():
            err = "function cannot return function type"
            raise SyntaxError(err)
        if prev_ctype.is_array():
            err = "function cannot return array type"
            raise SyntaxError(err)
        if not args and is_varags:
            err = "function cannot only have varargs"
            raise SyntaxError(err)

        if not args:
            new_ctype = ctypes.FunctionCType([], prev_ctype, is_varags)
        elif has_void:
            new_ctype = ctypes.FunctionCType([], prev_ctype, is_varags)
        else:
            new_ctype = ctypes.FunctionCType(args, prev_ctype, is_varags)

        return new_ctype

    def make_specs_ctype(self, specs, any_dec):
        if specs is None:
            return ctypes.integer, None
        storage = self.get_storage([spec.type for spec in specs])
        const = tokens.CONST in {spec.type for spec in specs}

        struct_union_specs = {tokens.STRUCT, tokens.UNION}
        if any(s.type in struct_union_specs for s in specs):
            node = [s for s in specs if s.type in struct_union_specs][0]

            redec = not any_dec and storage is None
            base_type = self.parse_struct_union_spec(node, redec)

        # is a typedef
        elif any(s.type == tokens.ID for s in specs):
            ident = [s for s in specs if s.type == tokens.ID][0]
            base_type = self.scope.lookup_typedef(ident.value)

        else:
            base_type = self.get_base_ctype(specs)

        if const:
            base_type = base_type.make_const()

        return base_type, storage

    def parse_struct_union_spec(self, node, redec):
        has_members = node.members is not None

        if node.type == tokens.STRUCT:
            ctype_req = ctypes.StructCType
        else:
            ctype_req = ctypes.UnionCType

        if node.tag:
            tag = str(node.tag)
            ctype = self.scope.lookup_struct_union(tag)

            if ctype and not isinstance(ctype, ctype_req):
                err = f"defined as wrong kind of tag '{node.kind} {tag}'"
                raise SyntaxError(err)

            if not ctype or has_members or redec:
                ctype = self.scope.add_struct_union(tag, ctype_req(tag))

            if has_members and ctype.is_complete():
                err = f"redefinition of '{node.kind} {tag}'"
                raise SyntaxError(err)

        else:  # anonymous struct/union
            ctype = ctype_req(None)

        if not has_members:
            return ctype

        # Struct or union does have members
        members = []
        members_set = set()
        for member in node.members:
            decl_infos = self.get_decl_infos(member)

            for decl_info in decl_infos:
                self._check_struct_member_decl_info(
                    decl_info, node.type, members_set)

                name = decl_info.identifier.value
                members_set.add(name)
                members.append((name, decl_info.ctype))

        ctype.set_members(members)
        return ctype

    def _check_struct_member_decl_info(self, decl_info, kind, members):
        if decl_info.identifier is None:
            err = f"missing name of {kind} member"
            raise SyntaxError(err)

        if decl_info.storage is not None:
            err = f"cannot have storage specifier on {kind} member"
            raise SyntaxError(err)

        if decl_info.ctype.is_function():
            err = f"cannot have function type as {kind} member"
            raise SyntaxError(err)

        if not decl_info.ctype.is_complete():
            err = f"cannot have incomplete type as {kind} member"
            raise SyntaxError(err)

        if decl_info.identifier.value in members:
            err = f"duplicate member '{decl_info.identifier.value}'"
            raise SyntaxError(err)

    def get_base_ctype(self, specs):
        base_specs = set(ctypes.simple_types)
        base_specs |= {tokens.SIGNED, tokens.UNSIGNED}

        our_base_specs = [str(spec.type) for spec in specs
                          if spec.type in base_specs]
        specs_str = " ".join(sorted(our_base_specs))
        specs_str = specs_str.replace("long long", "long")

        specs = {
            "void": ctypes.void,

            "_Bool": ctypes.bool_t,

            "char": ctypes.char,
            "char signed": ctypes.char,
            "char unsigned": ctypes.unsig_char,

            "short": ctypes.integer,
            "short signed": ctypes.integer,
            "int short": ctypes.integer,
            "int short signed": ctypes.integer,
            "short unsigned": ctypes.unsig_int,
            "int short unsigned": ctypes.unsig_int,

            "int": ctypes.integer,
            "signed": ctypes.integer,
            "int signed": ctypes.integer,
            "unsigned": ctypes.unsig_int,
            "int unsigned": ctypes.unsig_int,

            "long": ctypes.longint,
            "long signed": ctypes.longint,
            "int long": ctypes.longint,
            "int long signed": ctypes.longint,
            "long unsigned": ctypes.unsig_longint,
            "int long unsigned": ctypes.unsig_longint,
        }

        if specs_str in specs:
            return specs[specs_str]

        raise SyntaxError("Unrecognised type: {}".format(specs_str))

    def get_storage(self, spec_kinds):
        storage_classes = {tokens.AUTO: ast.DeclInfo.AUTO,
                           tokens.STATIC: ast.DeclInfo.STATIC,
                           tokens.EXTERN: ast.DeclInfo.EXTERN,
                           tokens.TYPEDEF: ast.DeclInfo.TYPEDEF}

        storage = None
        for kind in spec_kinds:
            if kind in storage_classes and not storage:
                storage = storage_classes[kind]
            elif kind in storage_classes:
                descrip = "too many storage classes in declaration specifiers"
                raise SyntaxError(descrip)

        return storage

    def visit_TranslationUnit(self, node):
        self.scope = ScopedSymbolTable(scope_name='global', scope_level=1)
        self.scope_out = SymbolTable(self.scope)
        for n in node.items:
            self.visit(n)
        self.scope_out.set_symbols(self.scope)

    def visit_Declaration(self, node):
        decl_infos = self.get_decl_infos(node.node)
        self.scope.add_decl(id(node), decl_infos)
        for d in decl_infos:
            var_name = d.identifier.value
            if self.scope.lookup(var_name, current_scope_only=True):
                raise SyntaxError("Duplicate identifier '%s' found" % var_name)
            self.scope.define(VarSymbol(var_name, d.ctype, d.storage))
            if d.init is not None:
                self.visit(d.init)

    def visit_Function(self, node):
        decl_info = self.get_decl_infos(node.decl)[0]
        if decl_info.identifier.value == "main":
            if decl_info.ctype.ret != ctypes.integer:
                raise TypeError("main must be of int type")
        func_symbol = VarSymbol(decl_info.identifier.value, decl_info.ctype, decl_info.storage)
        self.scope.define(func_symbol)
        self.scope.add_decl(id(node), decl_info)
        procedure_scope = ScopedSymbolTable(
            scope_name=str(id(node)),
            scope_level=self.scope.scope_level + 1,
            enclosing_scope=self.scope,
        )
        self.scope = procedure_scope
        offset = 0
        for param, name in zip(decl_info.ctype.args, decl_info.params):
            name = name.value
            if self.scope.lookup(name, current_scope_only=True):
                raise SyntaxError("Duplicate identifier '%s' found" % name)
            symbol = VarSymbol(name, param, None)
            symbol.il_value.stack_offset = offset
            offset += symbol.type.size + (symbol.type.size % 2)
            self.scope.define(symbol)
        for n in node.nodes.items:
            self.visit(n)
        self.scope_out.add_scope(procedure_scope)
        self.scope = self.scope.enclosing_scope

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name)
        if val is None:
            raise NameError(repr(var_name))

    def visit_Array(self, node):
        pass

    def visit_Compound(self, node):
        procedure_scope = ScopedSymbolTable(
            scope_name=str(id(node)),
            scope_level=self.scope.scope_level + 1,
            enclosing_scope=self.scope,
        )
        self.scope = procedure_scope
        for n in node.items:
            self.visit(n)
        self.scope_out.add_scope(procedure_scope)
        self.scope = self.scope.enclosing_scope

    def visit_TranlationUnit(self, node):
        for n in node.items:
            self.visit(n)

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_PlusEquals(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_MinusEquals(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_StarEquals(self, node):
        self.visit(node.left)
        self.visit(node.right)
        self.visit(node.left)

    def visit_DivEquals(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_ModEquals(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_MultiExpr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_InitializerList(self, node):
        for n in node.inits:
            self.visit(n)

    def visit_Number(self, node):
        pass

    def visit_String(self, node):
        pass

    def visit_ParenExpr(self, node):
        self.visit(node.expr)

    def visit_Plus(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Minus(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Mult(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Div(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Mod(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Equality(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Inequality(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_BoolAnd(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_BoolOr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_LessThan(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_MoreThan(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_LessEqual(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_MoreEqual(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_BoolNot(self, node):
        self.visit(node.expr)

    def visit_And(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_IncOr(self, node):
        self.visit(node.left)
        self.visit(node.right)

    def visit_Negate(self, node):
        self.visit(node.expr)

    def visit_PreIncr(self, node):
        self.visit(node.expr)

    def visit_PostIncr(self, node):
        self.visit(node.expr)

    def visit_PreDecr(self, node):
        self.visit(node.expr)

    def visit_PostDecr(self, node):
        self.visit(node.expr)

    def visit_AddrOf(self, node):
        self.visit(node.expr)

    def visit_Deref(self, node):
        self.visit(node.expr)

    def visit_ArraySubsc(self, node):
        self.visit(node.head)
        self.visit(node.arg)

    def visit_IfStatement(self, node):
        self.visit(node.condition)
        self.visit(node.statement)
        if node.else_statement is not None:
            self.visit(node.else_statement)

    def visit_Conditional(self, node):
        self.visit(node.condition)
        self.visit(node.statement)
        self.visit(node.else_statement)

    def visit_WhileStatement(self, node):
        self.visit(node.condition)
        self.visit(node.statement)

    def visit_DoWhileStatement(self, node):
        self.visit(node.statement)
        self.visit(node.condition)

    def visit_ForStatement(self, node):
        if node.first:
            self.visit(node.first)
        if node.second:
            self.visit(node.second)
        if node.third:
            self.visit(node.third)
        self.visit(node.statement)

    def visit_Break(self, node):
        pass

    def visit_Continue(self, node):
        pass

    def visit_FuncCall(self, node):
        self.visit(node.func)
        for a in node.args:
            self.visit(a)

    def visit_NoOp(self, node):
        pass

    def visit_SizeofType(self, node):
        decl = self.get_decl_infos(node.type)[0]
        self.scope.add_decl(id(node), decl)

    def visit_Sizeof(self, node):
        self.visit(node.expr)

    def visit_Cast(self, node):
        decl = self.get_decl_infos(node.type)[0]
        self.scope.add_decl(id(node), decl)
        self.visit(node.expr)

    def visit_ObjMember(self, node):
        self.visit(node.head)

    def visit_ObjPtrMember(self, node):
        self.visit(node.head)

    def visit_Return(self, node):
        if node.right is not None:
            self.visit(node.right)
