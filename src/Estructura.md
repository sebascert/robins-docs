# Estructura del Compilador

El compilador este dividido en 4 partes, el analizador lexico y sintactico
ambos previamente explicados, el codigo del frontend que construye el AST,
junto con el analisis semantico, el cual valida tipos y significados de los
argumentos de las instrucciones (como por ejemplo que los grados tienen que ser
un multiplo de 90), y por ultimo el "backend", el cual se limita unicamente a
generar el codigo assembly-like, y como opcion adicional (-g|--graph) se puede
generar un grafico de graphviz del AST parseado.

Ademas el lenguaje que compila ROBINS se puede configurar por medio de macros,
utilizando el procesador de macros M4, el cual genera codigo de lex, yacc y c,
con los especificos de las configuraciones. Estos son los lugares del codigo
fuente en donde se substituyen los macros:

## lexer: tokens especificos a la configuracion
src/frontend/lexer.l.m4
19:ROBINS_NOUN_LEXEMAS()
21:ROBINS_POLITE_WORDS_LEXEMAS()
23:ROBINS_CONJUNCTION_LEXEMAS()
25:ROBINS_INS_VERB_LEXEMAS()
27:ROBINS_ARG_UNIT_LEXEMAS()

## parser: estructuras gramaticales especificas
src/frontend/parser.y.m4
24:ROBINS_INS_GRAMMAR_MACROS()
26:ROBINS_ARG_GRAMMAR_MACROS()
56:ROBINS_INS_GRAMMAR_RULE_STRUCTURE()
60:ROBINS_INS_PARTIAL_GRAMMAR_RULE()
63:ROBINS_INS_GRAMMAR_RULES()
66:ROBINS_ARG_GRAMMAR_RULES()

## analisis semantico: validacion de tipos y por funciones configuradas por el usuario
src/semantic/argument.c.m4
6:ROBINS_ARG_TYPE_MAP()
10:ROBINS_ARG_SV_DECL()
15:ROBINS_ARG_SV_CASES()

## tipos e identificadores de instruciones o argumentos
include/ast/user_types.h.m4
8:ROBINS_INS_TYPES()
14:ROBINS_ARG_TYPES()

src/ast/user_types.c.m4
5:ROBINS_INS_MNEMONICS()
9:ROBINS_ARG_TYPE_NAMES()