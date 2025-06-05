# ROBINS YACC Grammar




## Descripción del problema

El proyecto ROBINS requiere un analizador sintáctico que procese instrucciones en lenguaje natural para controlar un robot en una cuadrícula. Estas instrucciones pueden incluir comandos como "move", "turn", combinados con números y unidades como "blocks" o "degrees", y opcionalmente palabras de cortesía como "please".

El parser debe aceptar comandos secuenciales, instrucciones compuestas con conjunciones como "then" o "and then", y ser capaz de distinguir entradas válidas de aquellas que no cumplen con la gramática definida.



## Definición de la gramática (CFG)

La siguiente es una representación de la gramática definida en el archivo `parser.y.m4`:

```
statement_list → e
               | '.' statement_list
               | error '.' statement_list
               | full_stmt statement_list

full_stmt → NOUN stmt '.'

stmt → ins
     | stmt INS_CONJUNCTION ins

ins → (definido en ROBINS_INS_GRAMMAR_RULE_STRUCTURE())

num_expr → term
         | '-' term
         | num_expr '+' term
         | num_expr '-' term

term → factor
     | term '*' factor
     | term '/' factor

factor → num_literal
       | '(' num_expr ')'

num_literal → INT_L
            | REAL_L
```

**Nota:** Las reglas específicas de instrucciones (`move`, `rotate`, etc.) y argumentos (`blocks`, `degrees`) están definidas dentro de los macros:

- `ROBINS_INS_GRAMMAR_RULE_STRUCTURE()`
- `ROBINS_INS_GRAMMAR_RULES()`
- `ROBINS_ARG_GRAMMAR_RULES()`

Estas incluyen el manejo opcional de `POLITE_WORDS`, así como expresiones aritméticas en los argumentos.

### TOKENS

**NOUN, POLITE_WORDS, INS_CONJUNCTION, INS_ROTATE_VERB, INS_MOVE_VERB, ARG_DEGREES_UNIT, ARG_BLOCKS_UNIT, INT_L, REAL_L, Operadores, . (punto)**



## Ejemplos de entradas válidas e inválidas

### Entradas válidas

1. `Robot move 4 blocks.` -> Instrucción básica ins_move con NOUN y punto final.

2. `Robot rotate 90 deg.` -> Instrucción básica ins_rotate.

3. `Robot please move 5 blocks.` -> Uso del token POLITE_WORDS antes de ins_move.

4. `Robot would you please rotate 180 deg.` -> Variante de cortesía seguida de ins_rotate.

5. `Robot move 2 blocks , then rotate 90 deg.` -> Dos instrucciones compuestas usando INS_CONJUNCTION.

### Entradas inválidas

1. `Robot move blocks 3.` -> Regla: arg_blocks -> num_expr ARG_BLOCKS_UNIT  
   El número (INT_L) debe ir antes de la unidad, no después.

2. `please Robot rotate 90 deg.` -> Regla: full_stmt -> NOUN stmt '.'  
   El comando debe iniciar con NOUN. POLITE_WORDS no puede ir antes.

3. `Robot rotate (90 +) deg.` -> Regla: num_expr -> num_expr '+' term  
   La expresión aritmética está incompleta; falta un término después de '+'.

4. `Robot move 2 blocks rotate 90 deg.` -> Regla: múltiples instrucciones deben ir unidas por INS_CONJUNCTION.

5. `Robot move 2 blocks and then rotate 90 deg.` -> Regla: INS_CONJUNCTION requiere coma inicial: ', and then'.