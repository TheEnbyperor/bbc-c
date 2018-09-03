from . import ast
from . import decl_tree
from . import ctypes
from .tokens import *


class SimpleSymbolTable:
    def __init__(self):
        self.symbols = []
        self.new_scope()

    def new_scope(self):
        self.symbols.append({})

    def end_scope(self):
        self.symbols.pop()

    def add_symbol(self, identifier, is_typedef):
        self.symbols[-1][identifier.value] = is_typedef

    def is_typedef(self, identifier):
        name = identifier.value
        for table in self.symbols[::-1]:
            if name in table:
                return table[name]
        return False


class Parser:
    def __init__(self, tokens):
        self.tokens = tokens
        self.symbols = SimpleSymbolTable()

    def error(self):
        raise SyntaxError("Invalid syntax")

    def eat(self, index, token_type):
        if self.tokens[index].type == token_type:
            return index+1
        else:
            self.error()

    def token_is(self, index, token_type):
        if self.tokens[index].type == token_type:
            return True
        else:
            return False

    def parse_translation_unit(self, index):
        # Read block items until there are no more.
        items = []
        while True:
            try:
                item, index = self.parse_external_deceleration(index)
                items.append(item)
                continue
            except SyntaxError:
                break

        if self.tokens[index:][0].type == EOF:
            return ast.TranslationUnit(items), index
        else:
            print(self.tokens[index:])
            self.error()

    def parse_external_deceleration(self, index):
        try:
            return self.parse_function_definition(index)
        except SyntaxError:
            pass

        return self.parse_declaration(index)

    def parse_function_definition(self, index):
        try:
            type_specifier, index = self.parse_decl_specifiers(index)
        except SyntaxError:
            type_specifier = None

        end = self.find_decl_end(index)
        decl = self.parse_declarator(index, end)

        node, index = self.parse_compound_statement(end)

        return ast.Function(decl_tree.Root(type_specifier, [decl]), node), index

    def parse_statement(self, index):
        """Parse a statement.
        Try each possible type of statement, catching/logging exceptions upon
        parse failures. On the last try, raise the exception on to the caller.
        """
        try:
            return self.parse_compound_statement(index)
        except SyntaxError:
            pass

        try:
            return self.parse_return(index)
        except SyntaxError:
            pass

        try:
            return self.parse_break(index)
        except SyntaxError:
            pass

        try:
            return self.parse_continue(index)
        except SyntaxError:
            pass

        try:
            return self.parse_if_statement(index)
        except SyntaxError:
            pass

        try:
            return self.parse_while_statement(index)
        except SyntaxError:
            pass

        try:
            return self.parse_do_while_statement(index)
        except SyntaxError:
            pass

        try:
            return self.parse_for_statement(index)
        except SyntaxError:
            pass

        return self.parse_expr_statement(index)

    def parse_compound_statement(self, index):
        """Parse a compound statement.
        A compound statement is a collection of several
        statements/declarations, enclosed in braces.
        """
        index = self.eat(index, LBRACE)
        p.symbols.new_scope()

        # Read block items (statements/declarations) until there are no more.
        items = []
        while True:
            try:
                item, index = self.parse_statement(index)
                items.append(item)
                continue
            except SyntaxError:
                pass

            try:
                item, index = self.parse_declaration(index)
                items.append(item)
                continue
            except SyntaxError:
                # When both of our parsing attempts fail, break out of the loop
                break

        p.symbols.end_scope()
        index = self.eat(index, RBRACE)

        return ast.Compound(items), index

    def parse_return(self, index):
        """Parse a return statement.
        Ex: return 5;
        """
        index = self.eat(index, RETURN)
        try:
            node, index = self.parse_expression(index)
        except SyntaxError:
            node = None

        index = self.eat(index, SEMI)
        return ast.Return(node), index

    def parse_break(self, index):
        """Parse a break statement."""
        index = self.eat(index, BREAK)
        index = self.eat(index, SEMI)
        return ast.Break(), index

    def parse_continue(self, index):
        """Parse a continue statement."""
        index = self.eat(index, CONTINUE)
        index = self.eat(index, SEMI)
        return ast.Continue(), index

    def parse_if_statement(self, index):
        """Parse an if statement."""

        index = self.eat(index, IF)
        index = self.eat(index, LPAREM)
        conditional, index = self.parse_expression(index)
        index = self.eat(index, RPAREM)
        statement, index = self.parse_statement(index)

        # If there is an else that follows, parse that too.
        is_else = self.token_is(index, ELSE)
        if not is_else:
            else_statement = None
        else:
            index = self.eat(index, ELSE)
            else_statement, index = self.parse_statement(index)

        return ast.IfStatement(conditional, statement, else_statement), index

    def parse_while_statement(self, index):
        """Parse a while statement."""
        index = self.eat(index, WHILE)
        index = self.eat(index, LPAREM)
        conditional, index = self.parse_expression(index)
        index = self.eat(index, RPAREM)
        statement, index = self.parse_statement(index)

        return ast.WhileStatement(conditional, statement), index

    def parse_do_while_statement(self, index):
        """Parse a do while statement."""
        index = self.eat(index, DO)
        statement, index = self.parse_statement(index)
        index = self.eat(index, WHILE)
        index = self.eat(index, LPAREM)
        conditional, index = self.parse_expression(index)
        index = self.eat(index, RPAREM)
        index = self.eat(index, SEMI)

        return ast.DoWhileStatement(conditional, statement), index

    def parse_for_statement(self, index):
        """Parse a for statement."""
        index = self.eat(index, FOR)
        index = self.eat(index, LPAREM)

        first, second, third, index = self._get_for_clauses(index)
        stat, index = self.parse_statement(index)

        return ast.ForStatement(first, second, third, stat), index

    def _get_for_clauses(self, index):
        """Get the three clauses of a for-statement.
        index - Index of the beginning of the first clause.
        returns - Tuple (Node, Node, Node, index). Each Node is the corresponding
        clause, or None if that clause is empty The index is that of first token
        after the close paren terminating the for clauses.
        Raises exception on malformed input.
        """

        first, index = self._get_first_for_clause(index)

        if self.token_is(index, SEMI):
            second = None
            index += 1
        else:
            second, index = self.parse_expression(index)
            index = self.eat(index, SEMI)

        if self.token_is(index, RPAREM):
            third = None
            index = index + 1
        else:
            third, index = self.parse_expression(index)
            index = self.eat(index, RPAREM)

        return first, second, third, index

    def _get_first_for_clause(self, index):
        """Get the first clause of a for-statement.
        index - Index of the beginning of the first clause in the for-statement.
        returns - Tuple. First element is a node if a clause is found and None if
        there is no clause (i.e. semicolon terminating the clause). Second element
        is an integer index where the next token begins.
        If malformed, raises exception.
        """
        if self.token_is(index, SEMI):
            return None, index + 1

        try:
            return self.parse_declaration(index)
        except SyntaxError:
            pass

        clause, index = self.parse_expression(index)
        index = self.eat(index, SEMI)
        return clause, index

    def parse_expr_statement(self, index):
        """Parse a statement that is an expression.
        Ex: a = 3 + 4
        """
        if self.token_is(index, SEMI):
            return ast.NoOp(), index + 1

        node, index = self.parse_expression(index)
        index = self.eat(index, SEMI)
        return ast.ExprStatement(node), index

    def parse_expression(self, index):
        """Parse expression."""
        return self.parse_series(
            index, self.parse_assignment,
            {COMMA: ast.MultiExpr})

    def parse_assignment(self, index):
        """Parse an assignment expression."""

        left, index = self.parse_conditional(index)

        if index < len(self.tokens):
            op = self.tokens[index]
            kind = op.type
        else:
            op = None
            kind = None

        node_types = {EQUALS: ast.Equals,
                      PLUSEQUALS: ast.PlusEquals,
                      MINUSEQUALS: ast.MinusEquals,
                      STAREQUALS: ast.StarEquals,
                      DIVEQUALS: ast.DivEquals,
                      MODEQUALS: ast.ModEquals}

        if kind in node_types:
            right, index = self.parse_assignment(index + 1)
            return node_types[kind](left, right, op), index
        else:
            return left, index

    def parse_conditional(self, index):
        """Parse a conditional expression."""
        cond, index = self.parse_logical_or(index)

        if self.tokens[index].type == QMARK:
            first, index = self.parse_expression(index + 1)
            index = self.eat(index, COLON)
            second, index = self.parse_conditional(index)

            return ast.Conditional(cond, first, second), index

        return cond, index

    def parse_logical_or(self, index):
        """Parse logical or expression."""
        return self.parse_series(
            index, self.parse_logical_and,
            {BOOLOR: ast.BoolOr})

    def parse_logical_and(self, index):
        """Parse logical and expression."""
        # TODO: Implement bitwise operators here.
        return self.parse_series(
            index, self.parse_inc_or,
            {BOOLAND: ast.BoolAnd})

    def parse_inc_or(self, index):
        return self.parse_series(
            index, self.parse_exc_or,
            {VLINE: ast.IncOr})

    def parse_exc_or(self, index):
        return self.parse_series(
            index, self.parse_and,
            {HAT: ast.ExcOr})

    def parse_and(self, index):
        return self.parse_series(
            index, self.parse_equality,
            {AMP: ast.And})

    def parse_equality(self, index):
        """Parse equality expression."""
        # TODO: Implement shift expressions here.
        return self.parse_series(
            index, self.parse_relational,
            {BOOLEQUALS: ast.Equality,
             BOOLNOT: ast.Inequality})

    def parse_relational(self, index):
        return self.parse_series(
            index, self.parse_additive,
            {LESSTHAN: ast.LessThan,
             MORETHAN: ast.MoreThan,
             LESSEQUAL: ast.LessEqual,
             MOREEQUAL: ast.MoreEqual})

    def parse_additive(self, index):
        """Parse additive expression."""
        return self.parse_series(
            index, self.parse_multiplicative,
            {PLUS: ast.Plus,
             MINUS: ast.Minus})

    def parse_multiplicative(self, index):
        """Parse multiplicative expression."""
        return self.parse_series(
            index, self.parse_cast,
            {STAR: ast.Mult,
             DIVIDE: ast.Div,
             MOD: ast.Mod})

    def parse_cast(self, index):
        """Parse cast expression."""
        try:
            return self.parse_unary(index)
        except SyntaxError:
            index = self.eat(index, LPAREM)
            t, index = self.parse_type_name(index)
            index = self.eat(index, RPAREM)
            e, index = self.parse_cast(index)
            return ast.Cast(t, e), index

    def parse_unary(self, index):
        """Parse unary expression."""
        if self.token_is(index, INCR):
            node, index = self.parse_unary(index + 1)
            return ast.PreIncr(node), index
        elif self.token_is(index, DECR):
            node, index = self.parse_unary(index + 1)
            return ast.PreDecr(node), index
        elif self.token_is(index, AMP):
            node, index = self.parse_cast(index + 1)
            return ast.AddrOf(node), index
        elif self.token_is(index, STAR):
            node, index = self.parse_cast(index + 1)
            return ast.Deref(node), index
        elif self.token_is(index, NOT):
            node, index = self.parse_cast(index + 1)
            return ast.BoolNot(node), index
        elif self.token_is(index, MINUS):
            node, index = self.parse_cast(index + 1)
            return ast.Negate(node), index
        elif self.token_is(index, TILDA):
            node, index = self.parse_cast(index + 1)
            return ast.Negate(node), index
        elif self.token_is(index, SIZEOF):
            try:
                node, index = self.parse_unary(index + 1)
                return ast.Sizeof(node), index
            except SyntaxError:
                index = self.eat(index+1, LPAREM)
                node, index = self.parse_type_name(index)
                index = self.eat(index, RPAREM)
                return ast.SizeofType(node), index
        else:
            return self.parse_postfix(index)

    def parse_postfix(self, index):
        """Parse postfix expression."""
        cur, index = self.parse_primary(index)

        while True:
            if self.token_is(index, LBRACK):
                index += 1
                arg, index = self.parse_expression(index)
                cur = ast.ArraySubsc(cur, arg)
                self.eat(index, RBRACK)
                index += 1

            elif self.token_is(index, DOT) or self.token_is(index, ARROW):
                index += 1
                if not self.token_is(index, ID):
                    self.error()
                member = self.tokens[index].value

                if self.token_is(index - 1, DOT):
                    cur = ast.ObjMember(cur, member)
                else:
                    cur = ast.ObjPtrMember(cur, member)
                index += 1

            elif self.token_is(index, LPAREM):
                args = []
                index += 1

                if self.token_is(index, RPAREM):
                    return ast.FuncCall(cur, args), index + 1

                while True:
                    arg, index = self.parse_assignment(index)
                    args.append(arg)

                    if self.token_is(index, COMMA):
                        index += 1
                    else:
                        break

                index = self.eat(
                    index, RPAREM)

                return ast.FuncCall(cur, args), index

            elif self.token_is(index, INCR):
                index += 1
                cur = ast.PostIncr(cur)
            elif self.token_is(index, DECR):
                index += 1
                cur = ast.PostDecr(cur)
            else:
                return cur, index

    def parse_primary(self, index):
        """Parse primary expression."""
        if self.token_is(index, LPAREM):
            node, index = self.parse_expression(index + 1)
            index = self.eat(index, RPAREM)
            return ast.ParenExpr(node), index
        elif self.token_is(index, INTEGER):
            return ast.Number(self.tokens[index].value), index + 1
        elif self.token_is(index, ID) and not self.symbols.is_typedef(self.tokens[index]):
            return ast.Identifier(self.tokens[index]), index + 1
        elif self.token_is(index, STRING):
            return ast.String(self.tokens[index].value + bytes([0])), index + 1
        elif self.token_is(index, CHARACTER):
            chars = self.tokens[index].value
            return ast.Number(chars), index + 1
        else:
            self.error()

    def parse_series(self, index, parse_base, separators):
        """Parse a series of symbols joined together with given separator(s).
        index (int) - Index at which to start searching.
        parse_base (function) - A parse_* function that parses the base symbol.
        separators (Dict(TokenKind -> Node)) - The separators that join
        instances of the base symbol. Each separator corresponds to a Node,
        which is the Node produced to join two expressions connected with that
        separator.
        """
        cur, index = parse_base(index)
        while True:
            for s in separators:
                if self.token_is(index, s):
                    break
            else:
                return cur, index

            tok = self.tokens[index]
            new, index = parse_base(index + 1)
            cur = separators[s](cur, new, tok)

    def parse_declaration(self, index):
        """Parse a declaration into a tree.nodes.Declaration node.
        Example:
            int *a, (*b)[], c
        """
        node, index = self.parse_decls_inits(index)
        return ast.Declaration(node), index

    def parse_decls_inits(self, index, parse_inits=True):
        """Parse declarations and initializers into a decl_nodes.Root node.
        The decl_nodes node is used by the caller to create a
        tree.nodes.Declaration node, and the decl_nodes node is traversed during
        the IL generation step to convert it into an appropriate ctype.
        If `parse_inits` is false, do not permit initializers. This is useful
        for parsing struct objects.
        """
        specs, index = self.parse_decl_specifiers(index)

        # If declaration specifiers are followed directly by semicolon
        if self.token_is(index, SEMI):
            return decl_tree.Root(specs, [], []), index + 1

        is_typedef = any(t.type == TYPEDEF for t in specs)

        decls = []
        inits = []

        while True:
            end = self.find_decl_end(index)
            node = self.parse_declarator(index, end, is_typedef)
            decls.append(node)
            index = end

            if self.token_is(index, EQUALS) and parse_inits:
                expr, index = self.parse_initializer(index + 1)
                inits.append(expr)
            else:
                inits.append(None)

            # Expect a comma, break if there isn't one
            if self.token_is(index, COMMA):
                index += 1
            else:
                break

        index = self.eat(index, SEMI)

        node = decl_tree.Root(specs, decls, inits)
        return node, index

    def parse_initializer(self, index):
        try:
            return self.parse_assignment(index)
        except SyntaxError:
            index = self.eat(index, LBRACE)
            expr, index = self.parse_intializer_list(index)
            if self.token_is(index, COMMA):
                index += 1
            index = self.eat(index, RBRACE)
            return expr, index

    def parse_intializer_list(self, index):
        inits = []
        while True:
            try:
              init, index = self.parse_initializer(index)
            except SyntaxError:
                break
            inits.append(init)
            if not self.token_is(index, COMMA):
                break
            index += 1
        return ast.InitializerList(inits), index

    def parse_decl_specifiers(self, index, _spec_qual=False):
        """Parse a declaration specifier list.
        Examples:
            int
            const char
            typedef int
        """
        type_specs = set(ctypes.simple_types.keys())
        type_specs |= set(TYPE_MODS.keys())

        type_quals = set(QUALIFIERS.keys())

        storage_specs = set(STORAGE.keys())

        specs = []

        while True:
            if self.token_is(index, STRUCT) or self.token_is(index, UNION):
                node, index = self.parse_struct_or_union_specifier(index)
                specs.append(node)

            elif self.token_is(index, ID) and self.symbols.is_typedef(self.tokens[index]):
                specs.append(self.tokens[index])
                index += 1

            elif self.tokens[index].value in type_specs:
                specs.append(self.tokens[index])
                index += 1

            elif self.tokens[index].value in type_quals:
                specs.append(self.tokens[index])
                index += 1

            elif self.tokens[index].value in storage_specs:
                if not _spec_qual:
                    specs.append(self.tokens[index])
                else:
                    self.error()
                index += 1

            else:
                break

        if specs:
            return specs, index
        else:
            self.error()

    def parse_type_name(self, index):
        # TODO: Abstract declarator

        t, index = self.parse_specifier_qualifier_list(index)
        end = self.find_decl_end(index)
        d = self.parse_declarator(index, end)

        return decl_tree.Root(t, [d]), end

    def parse_specifier_qualifier_list(self, index):
        return self.parse_decl_specifiers(index, True)

    def parse_storage_class_specifier(self, index):
        specifiers = list(STORAGE.keys())

        for spec in specifiers:
            if self.token_is(index, spec):
                return self.tokens[index], index + 1
        else:
            self.error()

    def parse_type_specifier(self, index):
        specifiers = list(ctypes.simple_types.keys()) + list(TYPE_MODS.keys())
        for spec in specifiers:
            if self.token_is(index, spec):
                return self.tokens[index], index + 1
        else:
            decl, index = self.parse_struct_or_union_specifier(index)
            return decl, index

    def parse_struct_or_union_specifier(self, index):
        soru, index = self.parse_struct_or_union(index)

        name = None
        if self.token_is(index, ID):
            name = self.tokens[index]
            index += 1

        members = None
        try:
            index = self.eat(index, LBRACE)
            members, index = self.parse_struct_declaration_list(index)
            index = self.eat(index, RBRACE)
        except SyntaxError:
            pass

        if name is None and members is None:
            self.error()

        decl = None
        if soru == STRUCT:
            decl = decl_tree.Struct(name, members)
        elif soru == UNION:
            decl = decl_tree.Union(name, members)
        else:
            self.error()

        return decl, index

    def parse_struct_or_union(self, index):
        try:
            index = self.eat(index, STRUCT)
            return STRUCT, index
        except SyntaxError:
            index = self.eat(index, UNION)
            return UNION, index

    def parse_struct_declaration_list(self, index):
        members = []

        while True:
            try:
                node, index = self.parse_struct_declaration(index)
                members.append(node)
            except SyntaxError:
                break

        return members, index

    def parse_struct_declaration(self, index):
        specs, index = self.parse_specifier_qualifier_list(index)
        decl, index = self.parse_struct_declarator_list(index)
        index = self.eat(index, SEMI)
        return decl_tree.Root(specs, decl), index

    def parse_struct_declarator_list(self, index):
        decls = []

        decl, index = self.parse_struct_declarator(index)
        decls.append(decl)

        try:
            index = self.eat(index, COMMA)
            decl, index = self.parse_struct_declarator_list(index)
            decls.extend(decl)
        except SyntaxError:
            pass

        return decls, index

    def parse_struct_declarator(self, index):
        decl = None
        try:
            end = self.find_decl_end(index)
            decl = self.parse_declarator(index, end)
            index = end
        except SyntaxError:
            pass

        bit = None
        try:
            index = self.eat(index, COLON)
            if self.tokens[index].type == INTEGER:
                bit = self.tokens[index].value
                index += 1
            else:
                self.error()
        except SyntaxError:
            pass

        if bit is None and decl is None:
            self.error()

        return decl, index

    def parse_type_qualifier(self, index):
        specifiers = list(QUALIFIERS.keys())

        for spec in specifiers:
            if self.token_is(index, spec):
                return self.tokens[index], index + 1
        else:
            self.error()

    def find_pair_forward(self, index,
                          open=LPAREM,
                          close=RPAREM):
        """Find the closing parenthesis for the opening at given index.
        index - position to start search, should be of kind `open`
        open - token kind representing the open parenthesis
        close - token kind representing the close parenthesis
        mess - message for error on mismatch
        """
        depth = 0
        for i in range(index, len(self.tokens)):
            if self.tokens[i].type == open:
                depth += 1
            elif self.tokens[i].type == close:
                depth -= 1

            if depth == 0:
                break
        else:
            # if loop did not break, no close paren was found
            self.error()
        return i

    def find_pair_backward(self, index,
                           open=LPAREM,
                           close=RPAREM):
        """Find the opening parenthesis for the closing at given index.
        Same parameters as _find_pair_forward above.
        """
        depth = 0
        for i in range(index, -1, -1):
            if self.tokens[i].type == close:
                depth += 1
            elif self.tokens[i].type == open:
                depth -= 1

            if depth == 0:
                break
        else:
            # if loop did not break, no open paren was found
            self.error()
        return i

    def find_decl_end(self, index):
        """Find the end of the declarator that starts at given index.
        If a valid declarator starts at the given index, this function is
        guaranteed to return the correct end point. Returns an index one
        greater than the last index in this declarator.
        """
        if (self.token_is(index, STAR) or
                self.token_is(index, ID)):
            return self.find_decl_end(index + 1)
        elif self.token_is(index, LPAREM):
            close = self.find_pair_forward(index)
            return self.find_decl_end(close + 1)
        elif self.token_is(index, LBRACK):
            close = self.find_pair_forward(index, LBRACK, RBRACK)
            return self.find_decl_end(close + 1)
        else:
            # Unknown token. If this declaration is correctly formatted,
            # then this must be the end of the declaration.
            return index

    def parse_declarator(self, start, end, is_typedef=False):
        """Parse the given tokens that comprises a declarator.
        This function parses both declarator and abstract-declarators. For
        an abstract declarator, the Identifier node at the leaf of the
        generated tree has the identifier None.
        Expects the declarator to start at start and end at end-1 inclusive.
        Returns a decl_tree.Node.
        """
        if start == end:
            return decl_tree.Identifier(None)
        elif start + 1 == end and self.tokens[start].type == ID:
            self.symbols.add_symbol(self.tokens[start], is_typedef)
            return decl_tree.Identifier(self.tokens[start])

        elif self.tokens[start].type == STAR:
            return decl_tree.Pointer(self.parse_declarator(start + 1, end, is_typedef))

        func_decl = self.try_parse_func_decl(start, end, is_typedef)
        if func_decl:
            return func_decl

        # First and last elements make a parenthesis pair
        elif self.tokens[start].type == LPAREM and self.find_pair_forward(start) == end - 1:
            return self.parse_declarator(start + 1, end - 1, is_typedef)

        # Last element indicates an array type
        elif self.tokens[end - 1].type == RBRACK:
            first = self.tokens[end - 3].type == LBRACK or self.tokens[end - 2].type == LBRACK
            number = self.tokens[end - 2].type == INTEGER
            if first and number:
                return decl_tree.Array(int(self.tokens[end - 2].value), self.parse_declarator(start, end - 3, is_typedef))
            elif first:
                return decl_tree.Array(None, self.parse_declarator(start, end - 2, is_typedef))

        self.error()

    def try_parse_func_decl(self, start, end, is_typedef=False):
        if self.tokens[end - 1].type != RPAREM:
            return None
        open_paren = self.find_pair_backward(end - 1)
        try:
            params, index = self.parse_parameter_list(open_paren + 1)
            if index == end - 1:
                return decl_tree.Function(
                    params, self.parse_declarator(start, open_paren, is_typedef))
        except SyntaxError:
            pass
        return None

    def parse_parameter_list(self, index):
        """Parse a function parameter list.
        Returns a list of decl_tree arguments and the index right after the
        last argument token. This index should be the index of a closing
        parenthesis, but that check is left to the caller.
        index - index right past the opening parenthesis
        """
        # List of decl_nodes arguments
        params = []

        # No arguments
        if self.token_is(index, RPAREM):
            return params, index

        while True:
            if self.token_is(index, ELLIPSIS):
                params.append(decl_tree.Root([self.tokens[index]], [None], [None]))
                index += 1
                break

            # Try parsing declaration specifiers, quit if no more exist
            specs, index = self.parse_decl_specifiers(index)

            end = self.find_decl_end(index)
            decl = self.parse_declarator(index, end)
            params.append(decl_tree.Root(specs, [decl], [None]))

            index = end

            # Expect a comma, and break if there isn't one
            if self.token_is(index, COMMA):
                index += 1
            else:
                break

        return params, index

    def parse(self):
        return self.parse_translation_unit(0)[0]
