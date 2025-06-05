# CPU de Robins
Este sencillo sitio web hecho con Vite + React muestra una cuadrícula de 8x8, toma nuestras instrucciones compiladas de la CPU desde un archivo .txt y mueve a nuestro robot en la cuadrícula de acuerdo con ellas.

[Repositorio de Github](https://github.com/DaifMX/ITESM_TC2037_Robins_React)

Nuestra CPU funciona con base en el siguiente AFD (Autómata Finito Determinista):  
![Diagrama de Graphviz](src/graphviz.svg 'Diagrama de Graphviz')

## Primeros Pasos
Antes de compilar, por favor asegúrate de tener instalada la última versión LTS de Node.JS en tu máquina.

Luego elige uno de los modos de ejecución:
- [CPU de Robins](#cpu-de-robins)
  - [Primeros Pasos](#primeros-pasos)
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