# ROBINS Analizador Léxico

## Descripción del problema

Crear un **Analizador Léxico** usando **Flex
(Lex)** que pueda procesar y tokenizar palabras y cadenas de texto específicas
para transformar una instrucción en lenguaje natural en varios tokens, que
después serán usados para traducir dichas instrucciones a lenguaje ensamblador.

Por ejemplo, si el usuario escribe "Robot, please move 5 blocks.", este
analizador léxico convertirá esta instrucción en tokens, y se vería de la
siguiente manera: NOUN, POLITE_WORDS, INS_MOVE_VERB, INT_L, ARG_BLOCKS_UNIT

---

## Definición de los TOKENS

**NOUN:** "Robot", "robot"

**POLITE_WORDS:** "please", "would you please"

**INS_CONJUNCTION:** ", and then", ", then"

**INS_ROTATE_VERB:** "rotate"

**INS_MOVE_VERB:** "move"

**ARG_DEGREES_UNIT:** "deg"

**ARG_BLOCKS_UNIT:** "blocks"

**INT_L:** Cualquier número entero, como 5, 10, 7

**REAL_L:** Cualquier número decimal, como 2.5, 0.5

**Operadores:** "+", "-", "\*", "/", "(", ")"

**. (punto):** "." para terminar las instrucciones

---

---

## Notas aclaratorias

- Las palabras y frases entre comillas como `"please"`, `"robot"`, `"blocks"`, `"deg"` y otras similares están definidas mediante macros en el archivo `lexer.l.m4`, específicamente:

  - `ROBINS_NOUN_LEXEMAS()`
  - `ROBINS_POLITE_WORDS_LEXEMAS()`
  - `ROBINS_INS_VERB_LEXEMAS()`
  - `ROBINS_ARG_UNIT_LEXEMAS()`

- Las conjunciones válidas como `", and then"` y `", then"` son detectadas explícitamente por el lexer. Palabras como `"and"` por sí solas **no** son tokens válidos.

- El punto final `"."` se reconoce como token separado (`.`) y es obligatorio para indicar el final de una instrucción.

---

## Input Examples

### Valid Input Examples

1. `Robot, please move 5 blocks.` -> NOUN, POLITE_WORDS, INS_MOVE_VERB, INT_L, ARG_BLOCKS_UNIT
2. `Please rotate 90 deg.` -> POLITE_WORDS, INS_ROTATE_VERB, INT_L, ARG_DEGREES_UNIT
3. `Move 10 blocks, then rotate 180 deg.` -> INS_MOVE_VERB, INT_L, ARG_BLOCKS_UNIT, INS_CONJUNCTION, INS_ROTATE_VERB, INT_L, ARG_DEGREES_UNIT
4. `Move 3 blocks, and then rotate 270 deg.` -> INS_MOVE_VERB, INT_L, ARG_BLOCKS_UNIT, INS_CONJUNCTION, INS_ROTATE_VERB, INT_L, ARG_DEGREES_UNIT
5. `Robot rotate 90 deg, then move 7 blocks.` -> NOUN, INS_ROTATE_VERB, INT_L, ARG_DEGREES_UNIT, INS_CONJUNCTION, INS_MOVE_VERB, INT_L, ARG_BLOCKS_UNIT

### Invalid Input Examples

Es importante recordar que el analizador léxico solo reconoce secuencias de texto que coinciden con tokens válidos. Todo lo que no coincida con un token definido será ignorado o marcado como error lo que puede finalizar en instrucciones erroneas o incompletas.

1. `Run over 3 blocks.` -> `"Run over"` no es un token válido. No está definido dentro del conjunto de verbos válidos (INS_MOVE_VERB, INS_ROTATE_VERB).
2. `Rotate ninety degrees.` -> `"ninety"` no es un token válido. El lexer solo acepta números en digitos, como 90, para los tokens INT_L o REAL_L.
3. `Robot move.` -> La instrucción está incompleta. El verbo `move` requiere argumentos como INT_L seguido de ARG_BLOCKS_UNIT.
4. `Please.` -> Instrucción incompleta. El token POLITE_WORDS por sí solo no conforma una instrucción válida.
5. `10 blocks walk.` -> El orden de los elementos es incorrecto y `walk` no es un TOKEN reconocido.

---
