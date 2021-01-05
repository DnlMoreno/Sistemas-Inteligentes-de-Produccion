breed [productos producto]


productos-own [CostoProd CostoMan demanda tpm1 tpm2 tpm3 tpm4 pos pos1 pos2 pos3 flag3]
patches-own [CapacidadMax]


globals [posiciones tpo_final tp1 tp2 tp3 tp4 ite mejor_posicion ndiv ndivreal flag flag2 inventario1 inventario2 inventario3 costop costoFinal Util1 pos_perturbada posiciones1]

to setup
  ca
  set flag false
  set flag2 false
  set ndiv 1
  set tp1 []
  set tp2 []
  set tp3 []
  set tp4 []
  set costop []
  interfaz
  crt-maquinas
  crt-productos
  posicion
  reset-ticks
end

to go
  evaluar
  ifelse count turtles-on patches with [plabel = "End"] = count turtles[
    set tpo_final max tp4
    makespan
    inventarios
    costos
    ask turtles [move-to patch -10 0 set tp1 [] set tp2 [] set tp3 [] set tp4 []]
    ifelse perturbar = false [clasificacion][tipo-perturbado]
    posicion]
  [

  if flag2 = false [
      flow-shop]
  ]

  tick
end

to crt-productos
   create-productos 1 [
    setxy -10 0
    set demanda D1
    set tpm1 2
    set tpm2 1
    set tpm3 2
    set tpm4 2
    set label "1"
    set label-color 5
    set heading 90
    set color pink
    set shape "arrow"
  ]

  create-productos 1 [
    setxy -10 0
    set demanda D2
    set tpm1 2
    set tpm2 4
    set tpm3 1
    set tpm4 1
    set label "2"
    set label-color 5
    set heading 90
    set color yellow
    set shape "arrow"
  ]

  create-productos 1 [
    setxy -10 0
    set demanda D3
    set tpm1 4
    set tpm2 2
    set tpm3 2
    set tpm4 3
    set label "3"
    set label-color 5
    set heading 90
    set color green
    set shape "arrow"
  ]
end

to interfaz
  ask patches [if pxcor > -5 and pxcor < 8 and pycor > -6 and pycor < 6
    [set pcolor brown]]
  ask patches [if pxcor < 11 and pycor > -2 and pycor < 2
    [set pcolor 49]]
  ask patches [if pxcor > -4 and pxcor < 7 and pycor > -5 and pycor < 5
    [set pcolor 49]]
end

to crt-maquinas
  ask patches [if pxcor = -10 and pycor = 0
    [set pcolor red set plabel "Inicio"]]
  ask patches [if pxcor = -3 and pycor = 0
    [set pcolor blue set plabel "M1"]]
  ask patches [if pxcor = 0 and pycor = 0
    [set pcolor blue set plabel "M2"]]
  ask patches [if pxcor = 3 and pycor = 0
    [set pcolor blue set plabel "M3"]]
  ask patches [if pxcor = 6 and pycor = 0
    [set pcolor blue set plabel "M4"]]
  ask patches [if pxcor = 9 and pycor = 0
    [set pcolor brown set plabel "End"]]
end

to flow-shop
  ifelse count turtles-on patches with [plabel = "M1"] = 0 and count turtles-on patches with [plabel = "Inicio"] != 0 [ask productos with [min [pos] of turtles-on patches with [plabel = "Inicio"] = pos][move-to patch -3 0 M1]][
    ifelse count turtles-on patches with [plabel = "M2"] = 0 and count turtles-on patches with [plabel = "M1"] != 0 [ask one-of turtles-on patches with [plabel = "M1"][move-to patch 0 0 M2]][
      ifelse count turtles-on patches with [plabel = "M3"] = 0 and count turtles-on patches with [plabel = "M2"] != 0 [ask one-of turtles-on patches with [plabel = "M2"][move-to patch 3 0 M3]][
        ifelse count turtles-on patches with [plabel = "M4"] = 0 and count turtles-on patches with [plabel = "M3"] != 0 [ask one-of turtles-on patches with [plabel = "M3"][move-to patch 6 0 M4]][
          if count turtles-on patches with [plabel = "M4"] != 0 [ask one-of turtles-on patches with [plabel = "M4"][move-to patch 9 0]]]]]]
end

to evaluar
  ifelse perturbar = false[
  ifelse (( [tpm1] of one-of turtles with [label = "1"] * D1 ) + ( [tpm1] of one-of turtles with [label = "2"] * D2) + ( [tpm1] of one-of turtles with [label = "3"] * D3)) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 1 Sobrepasada")][
  ifelse (( [tpm2] of one-of turtles with [label = "1"] * D1) + ( [tpm2] of one-of turtles with [label = "2"] * D2) + ( [tpm2] of one-of turtles with [label = "3"] * D3)) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 2 Sobrepasada")][
  ifelse (( [tpm3] of one-of turtles with [label = "1"] * D1) + ( [tpm3] of one-of turtles with [label = "2"] * D2) + ( [tpm3] of one-of turtles with [label = "3"] * D3)) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 3 Sobrepasada")][
  ifelse (( [tpm4] of one-of turtles with [label = "1"] * D1) + ( [tpm4] of one-of turtles with [label = "2"] * D2) + ( [tpm4] of one-of turtles with [label = "3"] * D3)) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 4 Sobrepasada")][set flag2 false ifelse perturbar = false  [actualizar][tipo-perturbado] ]]]]]
 [ifelse (( [tpm1] of one-of turtles with [label = "1"] * sum [demanda] of turtles with [label = "1"] ) + ( [tpm1] of one-of turtles with [label = "2"] * sum [demanda] of turtles with [label = "2"]) + ( [tpm1] of one-of turtles with [label = "3"] * sum [demanda] of turtles with [label = "3"])) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 1 Sobrepasada")][
  ifelse (( [tpm2] of one-of turtles with [label = "1"] * sum [demanda] of turtles with [label = "1"]) + ( [tpm2] of one-of turtles with [label = "2"] * sum [demanda] of turtles with [label = "2"]) + ( [tpm2] of one-of turtles with [label = "3"] * sum [demanda] of turtles with [label = "3"])) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 2 Sobrepasada")][
  ifelse (( [tpm3] of one-of turtles with [label = "1"] * sum [demanda] of turtles with [label = "1"]) + ( [tpm3] of one-of turtles with [label = "2"] * sum [demanda] of turtles with [label = "2"]) + ( [tpm3] of one-of turtles with [label = "3"] * sum [demanda] of turtles with [label = "3"])) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 3 Sobrepasada")][
  ifelse (( [tpm4] of one-of turtles with [label = "1"] * sum [demanda] of turtles with [label = "1"]) + ( [tpm4] of one-of turtles with [label = "2"] * sum [demanda] of turtles with [label = "2"]) + ( [tpm4] of one-of turtles with [label = "3"] * sum [demanda] of turtles with [label = "3"])) > CapacidadMaxima [set flag2 true Print ("Capacidad Maquina 4 Sobrepasada")][set flag2 false ifelse perturbar = false  [actualizar][tipo-perturbado] ]]]]]

end

to M1
  ifelse length tp1 = 0 [set tp1 lput [tpm1 * demanda] of one-of turtles-here tp1][set tp1 lput ([tpm1 * demanda] of one-of turtles-here + last tp1) tp1]
end

to M2
  ifelse length tp2 = 0 [set tp2 lput ([tpm2 * demanda] of one-of turtles-here + item 0 tp1) tp2][
    ifelse last tp2 >= last tp1 [set tp2 lput (last tp2 + [tpm2 * demanda] of one-of turtles-here) tp2][set tp2 lput (last tp1 + [tpm2 * demanda] of one-of turtles-here) tp2]]
end

to M3
  ifelse length tp3 = 0 [set tp3 lput ([tpm3 * demanda] of one-of turtles-here + item 0 tp2) tp3][
    ifelse last tp3 >= last tp2 [set tp3 lput (last tp3 + [tpm3 * demanda] of one-of turtles-here) tp3][set tp3 lput (last tp2 + [tpm3 * demanda] of one-of turtles-here) tp3]]
end

to M4
  ifelse length tp4 = 0 [set tp4 lput ([tpm4 * demanda] of one-of turtles-here + item 0 tp3) tp4][
    ifelse last tp4 >= last tp3 [set tp4 lput (last tp4 + [tpm4 * demanda] of one-of turtles-here) tp4][set tp4 lput (last tp3 + [tpm4 * demanda] of one-of turtles-here) tp4]]
end

to posicion
  if Funcion = "Entrenar"[
    let aux 0
    set posiciones shuffle(n-values count productos [i -> i])
    foreach [who] of productos [x -> ask producto x [set pos item aux posiciones set aux aux + 1]]]

  if Funcion = "Makespan" [ ask turtles [set pos pos1]
    if mejorar = true [
      let aux 0
      set posiciones1 shuffle(n-values count productos with [pos >= pos_perturbada][i -> (i + pos_perturbada)])
      foreach [who] of productos with [pos >= pos_perturbada] [x -> ask producto x [set pos3 item aux posiciones1 set pos item aux posiciones1 set aux aux + 1]]]
      ]
end

to tipo-perturbado
  if flag = false[
    ask one-of turtles [if label = "1" [set demanda (ceiling (D1 /(ndivreal + 1)) + cantidad_cambio) set flag3 1 set pos_perturbada pos1 ask  turtles with [pos1 > pos_perturbada][set flag3 true]]
    if label = "2" [set demanda (ceiling (D2 /(ndivreal + 1)) + cantidad_cambio) set flag3 1 set pos_perturbada pos1 ask  turtles with [pos1 > pos_perturbada][set flag3 true ]]
    if label = "3" [set demanda (ceiling (D3 /(ndivreal + 1)) + cantidad_cambio) set flag3 1 set pos_perturbada pos1 ask  turtles with [pos1 > pos_perturbada][set flag3 true ]]]
    set flag  true]
end

to makespan
  set ite (se ite tpo_final) set ite remove 0 ite
  if min ite = tpo_final [ask turtles [set pos1 pos]]

end

to actualizar
  ask turtles-on patch -10 0 [if label = "1" [set demanda ceiling (D1 /(ndivreal + 1))]]
  ask turtles-on patch -10 0 [if label = "2" [set demanda ceiling (D2 /(ndivreal + 1))]]
  ask turtles-on patch -10 0 [if label = "3" [set demanda ceiling (D3 /(ndivreal + 1))]]
end

to clasificacion
  ask turtles-on patch -10 0 [if label = "1" [set demanda ceiling (D1 /(ndivreal + 1))]]
  ask turtles-on patch -10 0 [if label = "2" [set demanda ceiling (D2 /(ndivreal + 1))]]
  ask turtles-on patch -10 0 [if label = "3" [set demanda ceiling (D3 /(ndivreal + 1))]]
  if ndiv < N_max_sublotes[
    ask one-of productos with [label = "1"] [hatch 1]
    ask one-of productos with [label = "2"] [hatch 1]
    ask one-of productos with [label = "3"] [hatch 1]
    set ndiv ndiv + 1
    set ndivreal ndivreal + 1
    if ndiv = N_max_sublotes [set ndivreal ndiv - 1]]
end

to inventarios
  ifelse  perturbar = true and any? turtles with [flag3 =  1  and label = "1"] [set inventario1 (sum [demanda] of turtles with [label = "1"] - ( D1 + cantidad_cambio))][set inventario1 (sum [demanda] of turtles with [label = "1"] - D1)]
  ifelse  perturbar = true and  any? turtles with [flag3 =  1  and label = "2"] [set inventario2 (sum [demanda] of turtles with [label = "2"] - ( D2 + cantidad_cambio))][set inventario2 (sum [demanda] of turtles with [label = "2"] - D2)]
  ifelse  perturbar = true and any? turtles with [flag3 =  1  and label = "3"] [set inventario3 (sum [demanda] of turtles with [label = "3"] - ( D3 + cantidad_cambio))][set inventario3 (sum [demanda] of turtles with [label = "3"] - D3)]
end

to costos
  set costop []
  set costop lput (sum [demanda] of turtles with [label = "1"] * 10 * 4) costop
  set costop lput (sum [demanda] of turtles with [label = "2"] * 15 * 4) costop
  set costop lput (sum [demanda] of turtles with [label = "3"] * 12 * 4) costop
  set costop lput (inventario1 * 3) costop
  set costop lput (inventario2 * 4) costop
  set costop lput (inventario3 * 3) costop
  set costop lput ((last ite * 5)) costop
  set costoFinal sum costop
end
@#$#@#$#@
GRAPHICS-WINDOW
312
60
691
440
-1
-1
17.7
1
10
1
1
1
0
1
1
1
-10
10
-10
10
0
0
1
ticks
30.0

SLIDER
16
70
179
103
D1
D1
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
16
110
179
143
D2
D2
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
16
151
179
184
D3
D3
0
100
15.0
1
1
NIL
HORIZONTAL

BUTTON
16
26
79
59
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
89
26
152
59
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
313
10
486
55
Funcion
Funcion
"Entrenar" "Makespan" "Tiempo Medo Finalizacion"
0

MONITOR
704
281
806
326
Makespan Total
last ite
17
1
11

MONITOR
704
71
792
116
Makespan M1
last tp1
17
1
11

MONITOR
704
122
792
167
Makespan M2
last tp2
17
1
11

MONITOR
704
175
792
220
Makespan M3
last tp3
17
1
11

MONITOR
704
228
792
273
Makespan M4
last tp4
17
1
11

MONITOR
704
334
806
379
Mejor Makespan
min ite
17
1
11

SLIDER
186
151
300
184
N_max_sublotes
N_max_sublotes
0
3
3.0
1
1
NIL
HORIZONTAL

PLOT
813
71
1272
273
Makespan
Iteración
Makespan
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot last ite"

MONITOR
16
198
108
243
Lote/Sublotes P1
[demanda] of turtles with [label = \"1\"]
17
1
11

MONITOR
16
252
104
297
Inventario P1
inventario1
17
1
11

MONITOR
109
253
197
298
Inventario P2
inventario2
17
1
11

MONITOR
202
253
290
298
Inventario P3
inventario3
17
1
11

MONITOR
16
306
221
351
Costos Produccion/Inventario/Makespan
costop
17
1
11

MONITOR
226
306
297
351
NIL
CostoFinal
17
1
11

INPUTBOX
16
357
127
417
CapacidadMaxima
400.0
1
0
Number

MONITOR
139
372
268
417
Capacidad Sobrepasada
flag2
17
1
11

MONITOR
928
285
1031
330
Cant. Utilizada M1
(( [tpm1] of one-of turtles with [label = \"1\"] * sum [demanda] of turtles with [label = \"1\"]) + ( [tpm1] of one-of turtles with [label = \"2\"] * sum [demanda] of turtles with [label = \"2\"]) + ( [tpm1] of one-of turtles with [label = \"3\"] * sum [demanda] of turtles with [label = \"3\"]))
17
1
11

MONITOR
1041
285
1144
330
Cant. Utilizada M2
(( [tpm2] of one-of turtles with [label = \"1\"] * sum [demanda] of turtles with [label = \"1\"]) + ( [tpm2] of one-of turtles with [label = \"2\"] * sum [demanda] of turtles with [label = \"2\"]) + ( [tpm2] of one-of turtles with [label = \"3\"] * sum [demanda] of turtles with [label = \"3\"]))
17
1
11

MONITOR
928
335
1032
380
Cant. Utilizada M3
(( [tpm3] of one-of turtles with [label = \"1\"] * sum [demanda] of turtles with [label = \"1\"]) + ( [tpm3] of one-of turtles with [label = \"2\"] * sum [demanda] of turtles with [label = \"2\"]) + ( [tpm3] of one-of turtles with [label = \"3\"] * sum [demanda] of turtles with [label = \"3\"]))
17
1
11

MONITOR
1041
335
1144
380
Cant. Utilizada M4
(( [tpm4] of one-of turtles with [label = \"1\"] * sum [demanda] of turtles with [label = \"1\"]) + ( [tpm4] of one-of turtles with [label = \"2\"] * sum [demanda] of turtles with [label = \"2\"]) + ( [tpm4] of one-of turtles with [label = \"3\"] * sum [demanda] of turtles with [label = \"3\"]))
17
1
11

SWITCH
493
22
590
55
perturbar
perturbar
1
1
-1000

SLIDER
705
21
985
54
cantidad_cambio
cantidad_cambio
-100
100
15.0
1
1
NIL
HORIZONTAL

SWITCH
599
22
690
55
mejorar
mejorar
1
1
-1000

MONITOR
217
447
274
492
Pos P0
[pos1] of turtle 0
17
1
11

MONITOR
281
448
338
493
Pos P1
[pos1] of turtle 1
17
1
11

MONITOR
346
448
403
493
Pos P2
[pos1] of turtle 2
17
1
11

MONITOR
411
448
468
493
Pos P3
[pos1] of turtle 3
17
1
11

MONITOR
476
449
533
494
Pos P4
[pos1] of turtle 4
17
1
11

MONITOR
542
449
599
494
Pos P5
[pos1] of turtle 5
17
1
11

MONITOR
607
449
664
494
Pos P6
[pos1] of turtle 6
17
1
11

MONITOR
674
449
731
494
Pos P7
[pos1] of turtle 7
17
1
11

MONITOR
740
449
797
494
Pos P8
[pos1] of turtle 8
17
1
11

MONITOR
217
497
274
542
Pos P0
[pos3] of turtle 0
17
1
11

MONITOR
282
498
339
543
Pos P1
[pos3] of turtle 1
17
1
11

MONITOR
346
498
403
543
Pos P2
[pos3] of turtle 2
17
1
11

MONITOR
411
498
468
543
Pos P3
[pos3] of turtle 3
17
1
11

MONITOR
476
499
533
544
Pos P4
[pos3] of turtle 4
17
1
11

MONITOR
542
499
599
544
Pos P5
[pos3] of turtle 5
17
1
11

MONITOR
607
500
664
545
Pos P6
[pos3] of turtle 6
17
1
11

MONITOR
673
500
730
545
Pos P7
[pos3] of turtle 7
17
1
11

MONITOR
740
501
797
546
Pos P8
[pos3] of turtle 8
17
1
11

MONITOR
112
198
205
243
Lote/Sublotes P2
[demanda] of turtles with [label = \"2\"]
17
1
11

MONITOR
209
198
302
243
Lote/Sublotes P3
[demanda] of turtles with [label = \"3\"]
17
1
11

TEXTBOX
53
452
203
480
Secuencia del mejor makespan
11
0.0
1

TEXTBOX
53
500
203
528
Reordenamiento en tiempo real
11
0.0
1

MONITOR
707
392
899
437
Numero de producto perturbado
[who] of turtles with [flag3 = 1]
17
1
11

@#$#@#$#@
## WHAT IS IT?

Este proyecto simula un sistema de producción de 4 máquinas y 3 productos. Aborda el problema del lot streaming dentro de un entorno dinámico de flow shop, en donde la producción se adapte de manera eficiente a perturbaciones durante el proceso de producción, determinando la secuencia optima y disminuyendo los costos mediante la minimización del makespan del proceso que se adapten de mejor manera a la perturbación.

## HOW IT WORKS

El ambiente se desarrolla con 3 tipos de lotes de productos que simulan el proceso de producción flow shop. Una vez que se realiza la primera secuencia, los lotes se dividen a la mitad quedando dos sublotes de cada lote. El tamaño de estos sublotes serán iguales en cada máquina por lo que serán consistentes. El numero máximo de sublotes en los que se pueden dividir los lotes es 3.

De esta manera cuando se llega a la máxima división de sublotes, los agentes comienzan a entrenar hasta que obtienen la secuencia optima del makespan. 

Una vez obtenida la secuencia optima se puede producir una perturbación en un momento "t" del proceso de producción produciendo una disminución o aumento en el tamaño de un sublote. Al producirse la perturbación los agentes guardan la secuencia de los sublotes que ya pasaron por las máquinas y obtienen la mejor secuencia de los sublotes que faltan por pasar disminuyendo el makespan para el proceso con perturbación.

## HOW TO USE IT

Se comienza por fijar la cantidad demanda de cada producto en D1, D2 y D3 junto con el numero máximo de sublotes (N_max_sublotes) y la capacidad máxima de cada maquina 
(CapacidadMaxima, misma capacidad para cada máquina). Y, además, se debe fijar el seleccionador "Funcion" en entrenar y el interruptor de perturbar y mejorar en Off. Asimismo, también se tiene que fijar la cantidad en la que va a cambiar un sublote.

Luego se debe hacer click en SETUP para inicializar la interfaz y en GO para comenzar el entrenamiento de los agentes.

Una vez que los agentes hayan entrenado, se debe fijar el seleccionador "Funcion" en makespan para observar la secuencia de los sublotes que obtuvieron el menor makespan y el valor de este mismo.

Posteriormente se puede realizar la perturbación al sistema cambiando el interruptor "perturbar" a On, el cual dará la secuencia que obtenga el menor makespan considerando la perturbación que se realizó en el sistema. Por consiguiente, se puede cambiar el interruptor "mejorar" a On para entrenar el sistema y ver si encuentra una secuencia mejor.

La observación de cual sublote se perturbo se puede ver en los monitores "Lote/Sublotes P1, P2 y P3".

Los monitores "Inventarios P1, P2 y P3" permiten visualizar el inventario (o productos extras) que se producen cuando se dividen los lotes en sublotes iguales.

El monitor "Costos Producción/Inventario/Makespan" entrega en los tres primeros ítems de la lista los costos de producción de cada tipo de producto, los tres siguiente ítem luego del tercer ítem muestran los costos de inventario y el ultimo ítem muestra el costo del makespan (makespan transformado a costo D). El monitor "CostoFinal" entrega el costo de la función objetivo cuando se disminuye el makespan.

El monitor "capacidad sobrepasada" muestra True si la capacidad de alguna maquina fue sobrepasada por la demanda de productos. Estas mismas cantidades de utilización de cada máquina se pueden observar en los monitores "Cant. Utilizada M1, M2, M3 y M4".

Los monitores "Makespan M1, M2, M3 y M4" muestran el makespan de todos los productos que han pasado por esa máquina.

El monitor "Makespan Total" muestra el makespan total del proceso que se obtuvo en esa iteración.

El monitor "Mejor Makespan" muestra el mínimo makespan que se ha obtenido durante la simulación.

## THINGS TO NOTICE

Si la cantidad de alguna maquina fue sobrepasada por la demanda que se entregaron a los productos, el simulador se detiene hasta que se cumpla la restricción de la capacidad de las maquinas.

Puede realizarse solo una perturbación durante la simulación, ya que, si se vuelve a modificar el interruptor luego de ya haber realizado una perturbación, esta no se verá apreciada en el gráfico.

## EXTENDING THE MODEL

Se podría sugerir construir un modelo en donde el usuario pueda modificar el sublote que se quiere perturbar, ya que en estos momentos se está haciendo la perturbación en un sublote aleatorio.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
