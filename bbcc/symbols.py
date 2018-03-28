import collections

from . import ast
from . import decl_tree
from . import il
from .tokens import *


class Symbol:
    def __init__(self, name, stype=None):
        self.name = name
        self.type = stype


class BuiltinTypeSymbol(Symbol):
    def __init__(self, name, size):
        super(BuiltinTypeSymbol, self).__init__(name)
        self.size = size

    def __str__(self):
        return '<BUILTIN({name}:{type})>'.format(name=self.name, type=self.size)

    __repr__ = __str__


class VarSymbol(Symbol):
    def __init__(self, name, var_type):
        super(VarSymbol, self).__init__(name, var_type)
        self.il_value = il.ILValue(var_type)

    def __str__(self):
        return '<VAR({name}:{type}:{il_value})>'.format(name=self.name, type=self.type, il_value=self.il_value)

    __repr__ = __str__


class FunctionSymbol(Symbol):
    def __init__(self, name, rtype, params=None):
        super(FunctionSymbol, self).__init__(name, rtype)
        # a list of formal parameters
        self.params = params if params is not None else []

    def __str__(self):
        return '<{class_name}(name={name}, parameters={params})>'.format(
            class_name=self.__class__.__name__,
            name=self.name,
            params=self.params,
        )

    __repr__ = __str__


class ScopedSymbolTable(object):
    def __init__(self, scope_name, scope_level, enclosing_scope=None):
        self.symbols = collections.OrderedDict()
        self.scope_name = scope_name
        self.scope_level = scope_level
        self.enclosing_scope = enclosing_scope
        if self.enclosing_scope is None:
            self._init_builtins()

    def _init_builtins(self):
        self.define(BuiltinTypeSymbol(INT, 0x2))
        self.define(BuiltinTypeSymbol(CHAR, 0x1))
        self.define(BuiltinTypeSymbol(VOID, 0x0))

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
        self.name = scope.scope_name
        self.symbols = scope.symbols
        self.sub_scopes = []

    def set_symbols(self, scope):
        self.symbols = scope.symbols

    def add_scope(self, scope):
        self.sub_scopes.append(SymbolTable(scope))

    def __str__(self):
        h1 = 'SYMBOL TABLE: ' + self.name
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
                if s.name == scope_name:
                    scope = s
                    break
        r = scope.symbols.get(name)
        if r is not None:
            return r

        return self.symbols.get(name)


class SymbolTableBuilder(ast.NodeVisitor):
    memstart = 0x2FFF

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
        for i, d in enumerate(node.decls):
            type_name = d.specs[-1].type
            type_symbol = self.scope.lookup(type_name)
            if type(d.child) == decl_tree.Identifier:
                var_name = d.child.identifier.value
                if self.scope.lookup(var_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % var_name)
                self.scope.define(VarSymbol(var_name, type_symbol))
                self.memstart -= type_symbol.size
                if node.inits[i] is not None:
                    self.visit(node.inits[i])

            elif type(d.child) == decl_tree.Array:
                var_name = d.child.child.identifier.value
                if self.scope.lookup(var_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % var_name)
                self.scope.define(VarSymbol(var_name, type_symbol))
                self.memstart -= type_symbol.size
                if node.inits[i] is not None:
                    self.visit(node.inits[i])

            elif type(d.child) == decl_tree.Function:
                func_name = d.child.child.identifier.value
                if self.scope.lookup(func_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % func_name)
                self.scope.define(FunctionSymbol(func_name, type_symbol, d.child.args))

    def visit_Function(self, node):
        type_symbol = self.scope.lookup(node.type[-1].type)
        func_name = node.name.identifier.value
        func_symbol = FunctionSymbol(func_name, type_symbol, node.params)
        self.scope.define(func_symbol)
        memstart = self.memstart
        procedure_scope = ScopedSymbolTable(
            scope_name=func_name,
            scope_level=self.scope.scope_level + 1,
            enclosing_scope=self.scope,
        )
        self.scope = procedure_scope
        for param in node.params:
            type_name = param.specs[-1].type
            type_symbol = self.scope.lookup(type_name)
            if type(param.child) == decl_tree.Identifier:
                param_name = param.child.identifier.value
                if self.scope.lookup(param_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % param_name)

                self.scope.define(VarSymbol(param_name, type_symbol))
                self.memstart -= type_symbol.size
        self.visit(node.nodes)
        self.scope_out.add_scope(procedure_scope)
        self.scope = self.scope.enclosing_scope
        self.memstart = memstart

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name)
        if val is None:
            raise NameError(repr(var_name))

    def visit_Array(self, node):
        pass

    def visit_Compound(self, node):
        for n in node.items:
            self.visit(n)

    def visit_TranlationUnit(self, node):
        for n in node.items:
            self.visit(n)

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        if type(node.left) != ast.Identifier and type(node.left) != ast.Deref:
            raise TypeError("Can only assign variables or pointers")
        self.visit(node.left)
        self.visit(node.right)

    def visit_PlusEquals(self, node):
        if type(node.left) != ast.Identifier and type(node.left) != ast.Deref:
            raise TypeError("Can only assign variables or pointers")
        self.visit(node.left)
        self.visit(node.right)

    def visit_MinusEquals(self, node):
        if type(node.left) != ast.Identifier and type(node.left) != ast.Deref:
            raise TypeError("Can only assign variables or pointers")
        self.visit(node.left)
        self.visit(node.right)

    def visit_StarEquals(self, node):
        if type(node.left) != ast.Identifier and type(node.left) != ast.Deref:
            raise TypeError("Can only assign variables or pointers")
        self.visit(node.left)
        self.visit(node.right)
        self.visit(node.left)

    def visit_DivEquals(self, node):
        if type(node.left) != ast.Identifier and type(node.left) != ast.Deref:
            raise TypeError("Can only assign variables or pointers")
        self.visit(node.left)
        self.visit(node.right)

    def visit_ModEquals(self, node):
        if type(node.left) != ast.Identifier and type(node.left) != ast.Deref:
            raise TypeError("Can only assign variables or pointers")
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
        if type(node.expr) != ast.Identifier and type(node.expr) != ast.Deref:
            raise TypeError("Can only increment variables or pointers")
        self.visit(node.expr)

    def visit_PostIncr(self, node):
        if type(node.expr) != ast.Identifier and type(node.expr) != ast.Deref:
            raise TypeError("Can only increment variables or pointers")
        self.visit(node.expr)

    def visit_PreDecr(self, node):
        if type(node.expr) != ast.Identifier and type(node.expr) != ast.Deref:
            raise TypeError("Can only decrement variables or pointers")
        self.visit(node.expr)

    def visit_PostDecr(self, node):
        if type(node.expr) != ast.Identifier and type(node.expr) != ast.Deref:
            raise TypeError("Can only decrement variables or pointers")
        self.visit(node.expr)

    def visit_AddrOf(self, node):
        if type(node.expr) != ast.Identifier and type(node.expr) != ast.Deref:
            raise TypeError("Can only get address of variables or pointers")
        self.visit(node.expr)

    def visit_Deref(self, node):
        if type(node.expr) != ast.Identifier and type(node.expr) != ast.Deref:
            raise TypeError("Can only dereference variables or pointers")
        self.visit(node.expr)

    def visit_IfStatement(self, node):
        self.visit(node.condition)
        self.visit(node.statement)
        if node.else_statement is not None:
            self.visit(node.else_statement)

    def visit_WhileStatement(self, node):
        self.visit(node.condititon)
        self.visit(node.statement)

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
        if len(func.params) != len(node.args):
            raise NameError("Calling " + str(func.name) + " with wrong number of params")
        for a in node.args:
            self.visit(a)

    def visit_NoOp(self, node):
        pass

    def visit_Return(self, node):
        self.visit(node.right)
