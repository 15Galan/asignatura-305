# Consejo para hacer prácticas

A lo largo del curso tendrás que crear varios usuarios, lo que puede resultar un poco caótico y confuso, ya que durante las prácticas necesitarás crear objetos y quizás no tengas permisos necesarios.

El método descrito te permitirá organizarte mejor dentro de SQL Developer para poder encontrar un objeto más rápidamente y evitarte preguntas del tipo «si la sentencia es así, ¿por qué no hace nada?».

Por eso considero que una forma eficiente de trabajar es a través de esta similitud:
* `Espacio de Tablas ( Usuario ( Objetos ) )`
* `Todas las Prácticas ( Práctica ( Ejercicios ) )`


## 1 - Usa el usuario *system* para hacer las prácticas
A principio de curso tendrás acceso a 2 usuarios:

* *System*, con todos los permisos, en la base de datos *Afrodita* (no suelen cambiarle el nombre).
* *UBDxxx*, con algunos permisos, en la base de datos *Apolo*, una instancia de la anterior. Este usuario es con el que harás los exámenes, así que está más limitado.

*System* tiene permisos de administración, por lo que puede crear cualquier objeto y en cualquier esquema / usuario, de este modo no tendrás que acceder a la base de datos como un usuario distinto.

## 2 - Crea un espacio de tablas para todas las prácticas
Nunca se debe escribir en el mismo espacio de tablas SYSTEM, ya que este se usa con fines administrativos.

Creando un espacio de tablas adicional en la base de datos (por ejemplo, *TS_PRACTICAS*), podrás agruparlo todo de una forma más ordenada. Este espacio de tablas debería contener a todos los usuarios las prácticas pidan crear (excepto aquellos que deban hacerse en un espacio de tablas concreto).

## 3 - Crea un usuario para cada práctica
Dado que es necesario un usuario para crear los objetos, lo mejor es crear un usuario que represente cada una de las diferentes prácticas y cuyo espacio de tablas sea el especificado en el paso anterior (por ejemplo, *practica_x*).

Recuerda que los espacios de tablas contienen a los usuarios, y que los objetos pertenecen al usuario que los crea (y se almacenan en el espacio de tablas de este).
