# CPU de Robins

## Descripción del problema

Generar una máquina de estados que describa el comportamiento de un robot 2D en una cuadrícula de 8x8.

Nuestra máquina de estados modela los posibles comportamientos del robot, considerando su posición actual y orientación.

Cada punto cardinal (Norte, Sur, Este, Oeste) tiene tres posibles estados:

- **Puro**: Por ejemplo, `Norte`, que representa que el robot está orientado hacia el norte.
- **Wait mov**: El robot está esperando recibir una instrucción de tipo `mov` mientras está orientado en esa dirección.
- **Wait turn**: El robot está esperando recibir una instrucción de tipo `turn` mientras está orientado en esa dirección.

El autómata comienza en un estado de inicio (`Start`). Dependiendo de la primera instrucción que recibe,`mov` o `turn`, se dirige al estado correspondiente:

- Si recibe un `turn`, el robot pasa a un estado `Wait turn`, indicando que ha girado y está listo para nuevas instrucciones.
- Si recibe un `mov`, el robot entra a un estado `Wait mov`, donde se desplaza cierta cantidad de espacios en la dirección actual.

El autómata tiene cuatro estados de aceptación, que corresponden a los cuatro estados cardinales puros. Esto significa que, al finalizar las instrucciones, el robot se encuentra en un estado válido, sin estar a la espera de un valor numérico (`1-8`) o un ángulo de giro (`90`, `180`, `270`, `360`).

El ciclo continúa dependiendo de las siguientes instrucciones. Si después de un `mov` el robot recibe un `turn`, cambia de orientación y entra al estado de espera de giro correspondiente. Si después de un `turn` recibe un `mov`, se traslada en la nueva dirección.

Este diseño nos permite modelar de forma clara las transiciones entre `mov` y `turn`, y cómo cada instrucción afecta el estado y la orientación del robot.

## Representación formal como tupla

A = (Q, Alfabeto, q0, F)

- Q = {Start, Norte, Sur, Este, Oeste, Wait Move Norte, Wait Move Sur, Wait Move Este, Wait Move Oeste, Wait Turn Norte, Wait Turn Sur, Wait Turn Este, Wait Turn Oeste }
- Alfabeto = {MOVE, TURN, {1-8}, 90, 180, 270, 360}
- q0 = Start
- F = {Norte, Sur, Este, Oeste}

## Tabla de transición del DFA del robot

| Estado actual       | Entrada        | Siguiente estado      |
|---------------------|----------------|------------------------|
| Start               | MOVE           | Wait MOVE ESTE        |
| Start               | TURN           | Wait TURN ESTE        |
| ESTE                | MOVE           | Wait MOVE ESTE        |
| ESTE                | TURN           | Wait TURN ESTE        |
| Wait MOVE ESTE      | 1-8            | ESTE                  |
| Wait TURN ESTE      | 90             | SUR                   |
| Wait TURN ESTE      | 180            | OESTE                 |
| Wait TURN ESTE      | 270            | NORTE                 |
| Wait TURN ESTE      | 360            | ESTE                  |
| SUR                 | MOVE           | Wait MOVE SUR         |
| SUR                 | TURN           | Wait TURN SUR         |
| Wait MOVE SUR       | 1-8            | SUR                   |
| Wait TURN SUR       | 90             | OESTE                 |
| Wait TURN SUR       | 180            | NORTE                 |
| Wait TURN SUR       | 270            | ESTE                  |
| Wait TURN SUR       | 360            | SUR                   |
| OESTE               | MOVE           | Wait MOVE OESTE       |
| OESTE               | TURN           | Wait TURN OESTE       |
| Wait MOVE OESTE     | 1-8            | OESTE                 |
| Wait TURN OESTE     | 90             | NORTE                 |
| Wait TURN OESTE     | 180            | ESTE                  |
| Wait TURN OESTE     | 270            | SUR                   |
| Wait TURN OESTE     | 360            | OESTE                 |
| NORTE               | MOVE           | Wait MOVE NORTE       |
| NORTE               | TURN           | Wait TURN NORTE       |
| Wait MOVE NORTE     | 1-8            | NORTE                 |
| Wait TURN NORTE     | 90             | ESTE                  |
| Wait TURN NORTE     | 180            | SUR                   |
| Wait TURN NORTE     | 270            | OESTE                 |
| Wait TURN NORTE     | 360            | NORTE                 |

---

## Imputs validos


### Ejemplo 1

```txt
mov 3
turn 90
mov 2
```

---

### Ejemplo 2

```txt
turn 180
mov 10
turn 90
mov 1
```

---

### Ejemplo 3

```txt
mov 5
turn 270
mov 4
turn 180
```


## Imputs Invalidos

### Ejemplo 1

```txt
mov
turn 90
```

**Motivo**: Falta el número de bloques después de `mov`.

---

### Ejemplo 2

```txt
turn
mov 5
```

**Motivo**: Falta el ángulo después de `turn`.

---

### Ejemplo 3

```txt
mov 12
turn 90
```

**Motivo**: El valor de `mov` excede el límite. Solo se permiten valores de 1-10

---

## Repositorio de Github, Diagrama y Video

[Repositorio de Github](https://github.com/DaifMX/ITESM_TC2037_Robins_React)

Nuestra CPU funciona con base en el siguiente AFD (Autómata Finito Determinista):  
![Diagrama de Graphviz](src/graphviz2.png 'Diagrama de Graphviz')

[Link Video](https://drive.google.com/file/d/15PYCazbe4jKoH70TE0nNI-5dkl20CCE0/view?usp=drive_link)

## Primeros Pasos
Antes de compilar, por favor asegúrate de tener instalada la última versión LTS de Node.JS en tu máquina.

Luego elige uno de los modos de ejecución:
  - [Compilacion Estandar](#compilacion-estandar)
  - [Modo Desarrollador](#modo-desarrollador)

## Compilacion Estandar
Para compilar, clona este repositorio en tu máquina y ejecuta los siguientes comandos desde la raíz del proyecto:
```
npm i
npm run build
```

## Modo Desarrollador
Si deseas ejecutar este proyecto en modo desarrollador, ejecuta:
```
npm i
npm run dev
```