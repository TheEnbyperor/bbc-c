import collections

from . import ast
from . import decl_tree
from . import il
from . import ctypes


class Symbol:
    def __init__(self, name, stype=None):
        self.name = name
        self.type = stype


class VarSymbol(Symbol):
    def __init__(self, name, var_type):
        super(VarSymbol, self).__init__(name, var_type)
        self.il_value = il.ILValue(var_type)

    def __str__(self):
        return '<VAR({name}:{type}:{il_value})>'.format(name=self.name, type=self.type, il_value=self.il_value)

    __repr__ = __str__


class FunctionSymbol(Symbol):
    def __init__(self, name, ctype):
        super(FunctionSymbol, self).__init__(name, ctype)

    def __str__(self):
        return '<FUNCTION({name}:{type})>'.format(name=self.name, type=self.type)

    __repr__ = __str__


class ScopedSymbolTable(object):
    def __init__(self, scope_name, scope_level, enclosing_scope=None):
        self.symbols = collections.OrderedDict()
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


class SymbolTable(object):
    def __init__(self, scope):
        self.scope_name = scope.scope_name
        self.symbols = scope.symbols
        self.sub_scopes = []

    def set_symbols(self, scope):
        self.symbols = scope.symbols

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
        if scope_name == "":
            scope = self
        else:
            scope = None
            for s in self.sub_scopes:
                if s.scope_name == scope_name:
                    scope = s
                    break
        r = scope.lookup(name)
        if r is not None:
            return r

        return self.symbols.get(name)


class SymbolTableBuilder(ast.NodeVisitor):
    def __init__(self):
        self.scope = None
        self.scope_out = None

    def visit_TranslationUnit(self, node):
        self.scope = ScopedSymbolTable(scope_name='global', scope_level=1)
        self.scope_out = SymbolTable(self.scope)
        for n in node.items:
            self.visit(n)
        self.scope_out.set_symbols(self.scope)

    def visit_Declaration(self, node):
        decl_infos = node.get_decls_info()
        for d in decl_infos:
            if type(d.ctype) == ctypes.FunctionCType:
                func_name = d.identifier.value
                if self.scope.lookup(func_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % func_name)
                self.scope.define(FunctionSymbol(func_name, d.ctype))
            else:
                var_name = d.identifier.value
                if self.scope.lookup(var_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % var_name)
                self.scope.define(VarSymbol(var_name, d.ctype))
                if d.init is not None:
                    self.visit(d.init)

    def visit_Function(self, node):
        func_name = node.name.identifier.value
        func_symbol = FunctionSymbol(func_name, node.make_ctype())
        self.scope.define(func_symbol)
        procedure_scope = ScopedSymbolTable(
            scope_name=str(id(node)),
            scope_level=self.scope.scope_level + 1,
            enclosing_scope=self.scope,
        )
        self.scope = procedure_scope
        for param in node.params:
            param = ast.Declaration(param)
            param = param.get_decls_info()[0]
            param_name = param.identifier.value
            if self.scope.lookup(param_name, current_scope_only=True):
                raise SyntaxError("Duplicate identifier '%s' found" % param_name)
            self.scope.define(VarSymbol(param_name, param.ctype))
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

    def visit_WhileStatement(self, node):
        self.visit(node.condition)
        self.visit(node.statement)

    def visit_DoWhileStatement(self, node):
        self.visit(node.statement)
        self.visit(node.condition)

    def visit_ForStatement(self, node):
        self.visit(node.first)
        self.visit(node.second)
        self.visit(node.third)
        self.visit(node.statement)

    def visit_Break(self, node):
        pass

    def visit_Continue(self, node):
        pass

    def visit_FuncCall(self, node):
        func_name = node.func.identifier.value
        func = self.scope.lookup(func_name)
        if func is None:
            raise NameError(repr(func_name))
        if len(func.type.args) != len(node.args):
            raise NameError("Calling " + str(func.name) + " with wrong number of params")
        for a in node.args:
            self.visit(a)

    def visit_NoOp(self, node):
        pass

    def visit_Return(self, node):
        self.visit(node.right)
