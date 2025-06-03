# Analizador Léxico - Proyecto ROBINS

## Descripción del problema

El objetivo de este proyecto es construir un **Analizador Léxico** usando **Flex (Lex)** que pueda procesar y tokenizar palabras y cadenas de texto específicas para transformar una instrucción en lenguaje natural en varios tokens, que después serán usados para traducir dichas instrucciones a lenguaje ensamblador.

Por ejemplo, si el usuario escribe "Robot, please move 5 blocks." este analizador léxico convertirá esta instrucción en tokens, y se vería de la siguiente manera: [NOUN], [POLITE_WORDS], [INS_MOVE_VERB], [INT_L], [ARG_BLOCKS_UNIT]

---

## Definición de los TOKENS

**NOUN:** "Robot", "robot"  
**POLITE_WORDS:** "please", "would you please"  
**INS_CONJUNCTION:** ", and then", ", then"  
**INS_ROTATE_VERB:** "rotate"  
**INS_MOVE_VERB:** "move"  
**ARG_DEGREES_UNIT:** "deg"  
**ARG_BLOCKS_UNIT:** "blocks"  
**INT_L:** Cualquier número entero, como `5`, `10`, `7`
**REAL_L:** Cualquier número decimal, como `2.5`, `0.5`  
**Operadores:** "+", "-", "*", "/", "(", ")"  
**. (punto):** "." para terminar las instrucciones

---

## Input Examples

### Valid Input Examples

1. `Robot, please move 5 blocks.`
2. `Please rotate 90 deg.`
3. `Move 10 blocks, then rotate 180 deg.`
4. `Move 3 blocks and rotate 270 deg.`
5. `Robot rotate 90 deg, then move 7 blocks.`

### Invalid Input Examples

1. `Run over 3 blocks.` -> "Run" no es un token valido
2. `Rotate ninety degrees.` -> "ninet" no es un token valido porque solo acepta numeros 
3. `Robot move.` -> Falta deg o blocks, es una instruccion incompleta
4. `Please.` -> Instruccion incompleta
5. `10 blocks walk.` -> Estan en desorden, por lo que no es valido

---