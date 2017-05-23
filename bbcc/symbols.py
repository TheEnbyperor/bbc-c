import collections
from .tokens import *
from . import ast
from . import decl_tree


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
    def __init__(self, name, type, location):
        super(VarSymbol, self).__init__(name, type)
        self.location = location

    def __str__(self):
        return '<VAR({name}:{type}:{loc})>'.format(name=self.name, type=self.type, loc=self.location)

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
        self._symbols = collections.OrderedDict()
        self.scope_name = scope_name
        self.scope_level = scope_level
        self.enclosing_scope = enclosing_scope
        if self.enclosing_scope == None:
            self._init_builtins()

    def _init_builtins(self):
        self.define(BuiltinTypeSymbol(INT, 0x2))
        self.define(BuiltinTypeSymbol(CHAR, 0x2))
        self.define(BuiltinTypeSymbol(VOID, 0x2))

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
            for key, value in self._symbols.items()
        )
        lines.append('\n')
        s = '\n'.join(lines)
        return s

    __repr__ = __str__

    def define(self, symbol):
        print('Define: %s' % symbol)
        self._symbols[symbol.name] = symbol

    def lookup(self, name, current_scope_only=False):
        print('Lookup: %s. (Scope name: %s)' % (name, self.scope_name))
        symbol = self._symbols.get(name)
        # 'symbol' is either an instance of the Symbol class or 'None'
        if symbol is not None:
            return symbol

        if current_scope_only:
            return None

        # recursively go up the chain and lookup the name
        if self.enclosing_scope is not None:
            return self.enclosing_scope.lookup(name)


class SymbolTableBuilder(ast.NodeVisitor):
    memstart = 0x2FFF

    def __init__(self):
        self.scope = None

    def visit_Root(self, node):
        self.scope = ScopedSymbolTable(scope_name='global', scope_level=1)
        for n in node.nodes:
            self.visit(n)
        print(self.scope)

    def visit_Declaration(self, node):
        for i, d in enumerate(node.decls):
            type_name = d.specs[-1].type
            type_symbol = self.scope.lookup(type_name)
            if type(d.child) == decl_tree.Identifier:
                var_name = d.child.identifier.value
                if self.scope.lookup(var_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % var_name)
                self.scope.define(VarSymbol(var_name, type_symbol, self.memstart))
                self.memstart -= type_symbol.size
                if node.inits[i] is not None:
                    self.visit(node.inits[i])
            elif type(d.child) == decl_tree.Function:
                func_name = d.child.child.identifier.value
                if self.scope.lookup(func_name, current_scope_only=True):
                    raise SyntaxError("Duplicate identifier '%s' found" % func_name)
                print(d.child.args[0].child)
                self.scope.define(FunctionSymbol(func_name, type_symbol, d.child.args))

    def visit_Main(self, node):
        type_symbol = self.scope.lookup(INT)
        func_name = "main"
        func_symbol = FunctionSymbol(func_name, type_symbol)
        self.scope.define(func_symbol)
        print('ENTER scope: %s' % func_name)
        procedure_scope = ScopedSymbolTable(
            scope_name=func_name,
            scope_level=self.scope.scope_level + 1,
            enclosing_scope=self.scope,
        )
        self.scope = procedure_scope
        if ast.Return not in [type(n) for n in node.body.items] and type_symbol.name != VOID:
            raise SyntaxError("No return in function")
        self.visit(node.body)
        print(procedure_scope)
        self.scope = self.scope.enclosing_scope
        print('LEAVE scope: %s' % func_name)

    def visit_Identifier(self, node):
        var_name = node.identifier.value
        val = self.scope.lookup(var_name)
        if val is None:
            raise NameError(repr(var_name))

    def visit_Compound(self, node):
        for n in node.items:
            self.visit(n)

    def visit_ExprStatement(self, node):
        self.visit(node.expr)

    def visit_Equals(self, node):
        self.visit(node.right)
        self.visit(node.left)

    def visit_PlusEquals(self, node):
        self.visit(node.right)
        self.visit(node.left)

    def visit_MinusEquals(self, node):
        self.visit(node.right)

    def visit_StarEquals(self, node):
        self.visit(node.right)
        self.visit(node.left)
        self.visit(node.left)

    def visit_DivEquals(self, node):
        self.visit(node.right)
        self.visit(node.left)

    def visit_ModEquals(self, node):
        self.visit(node.right)
        self.visit(node.left)

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

    def visit_Dref(self, node):
        self.visit(node.expr)

    def visit_FuncCall(self, node):
        func_name = node.func.identifier.value
        func = self.scope.lookup(func_name)
        if func is None:
            raise NameError(repr(func_name))

        print(func, node.args)
        if len(func.params) != len(node.args):
            raise NameError("Calling " + str(func.name) + " with wrong number of params")
        for i, a in enumerate(node.args):
            arg_name = a.identifier.value
            arg_type = self.scope.lookup(arg_name).type.name
            if arg_type != func.params[i].specs[-1].type:
                raise TypeError("Calling " + str(func.name) + " with wrong param type")

    def visit_NoOp(self, node):
        pass

    def visit_Return(self, node):
        self.visit(node.right)

