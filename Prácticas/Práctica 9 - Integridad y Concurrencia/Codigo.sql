/* Ejecutar desde SYSTEM */
CREATE TABLESPACE practica_9
    DATAFILE 'C:\Users\app\alumnos\oradata\ORCL\practica_9.dbf'
    SIZE 500M;

CREATE USER pepito
    IDENTIFIED BY pepito
    DEFAULT TABLESPACE practica_9
    QUOTA UNLIMITED ON practica_9;

GRANT CREATE SESSION, RESOURCE, CONNECT
    TO pepito;



/* Ejecutar desde PEPITO
Este script corresponde a la sesion A.
Las instrucciones de la sesion B aparecen comentadas en orden de ejecucion.
*/

-- Ejercicio 1
CREATE TABLE CUENTA (numero number primary key, saldo number);
INSERT INTO CUENTA VALUES (11,1000);
INSERT INTO CUENTA VALUES (22,2000);
COMMIT;

    -- (B) UPDATE CUENTA SET saldo = 9000 WHERE Numero = 11;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 2
    -- (B) COMMIT;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 3
-- Lectura erronea (ejercicio 1), porque la sesion B modifico los datos pero no
-- ejecuto un commit, por tanto esos cambios no estaban guardados y en la sesion
-- A no quedaron reflejados



-- Ejercicio 4
UPDATE CUENTA SET saldo = 90 WHERE Numero = 11;
SELECT SALDO FROM CUENTA WHERE NUMERO = 11;
ROLLBACK;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 5
UPDATE CUENTA SET saldo = 90 WHERE Numero = 11;

    -- (B) UPDATE CUENTA SET saldo = 75 WHERE Numero = 11;

-- Bloqueo, porque la sesion A evita que se acepten actualizaciones para esa
-- fila, quedando bloqueada; puede apreciarse que la consola de la sesion B se
-- queda bloqueada tambien (intentando ejecutar la instruccion de modificacion)



-- Ejercicio 6
COMMIT;

-- Liberacion del bloqueo, porque una vez confirmado el cambio en la sesion A,
-- la fila ya puede aceptar modificaciones, por lo que la instruccion de la
-- sesion B que estaba bloqueada accede al dato y lo cambia (tambien se puede
-- ver en la consola, que se desbloquea)



-- Ejercicio 7
INSERT INTO CUENTA VALUES (33, 3000);

    -- (B) INSERT INTO CUENTA VALUES (33, 3333);

-- Bloqueo, porque no puede asegurarse la unicidad de la clave primaria ya que
-- las 2 filas usan el mismo ID, que es 33



-- Ejercicio 8
COMMIT;

    -- (B) COMMIT;

-- Error, ya que al liberarse la fila por la insercion de la sesion A, ya existe
-- una fila con ID = 30, por tanto, no puede insertarse otra fila con ese ID, que
-- es justo lo que estaba haciendo la sesion B



-- Ejercicio 9
ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;
COMMIT;

    -- (B)  UPDATE CUENTA SET saldo = 990 WHERE Numero = 11;
    --      COMMIT;


SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 10
ALTER SESSION SET ISOLATION_LEVEL = READ COMMITTED;
COMMIT;

UPDATE CUENTA SET saldo = 90 WHERE Numero = 11;
COMMIT;

    -- (B) COMMIT;

ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;
COMMIT;

    -- (B) COMMIT;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;

    -- (B)  UPDATE CUENTA SET saldo = 990 WHERE Numero = 11;
    --      COMMIT;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 11
UPDATE CUENTA SET saldo = 9500 WHERE Numero = 11;
COMMIT;



-- Ejercicio 12
ALTER SESSION SET ISOLATION_LEVEL = READ COMMITTED;
COMMIT;

UPDATE CUENTA SET saldo = 700 Where Numero = 11;
COMMIT;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11 FOR UPDATE;

    -- (B) UPDATE CUENTA SET saldo = 300 where Numero = 11;



-- Ejercicio 13
COMMIT;

    -- (B) SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 14 (A)
SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 15
    -- (B) ROLLBACK;

UPDATE CUENTA SET saldo = 740 Where Numero = 11;
COMMIT;

	-- (B) SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 16
    -- (B) LOCK TABLE CUENTA IN EXCLUSIVE MODE

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 17
UPDATE CUENTA SET saldo = 800 Where Numero = 11;



-- Ejercicio 18
    -- (B) COMMIT;

SELECT SALDO FROM CUENTA WHERE NUMERO = 11;



-- Ejercicio 19
UPDATE CUENTA SET saldo = 600 Where Numero = 11;



-- Ejercicio 20
COMMIT;
INSERT INTO CUENTA VALUES(44, 4000);

    -- (B) INSERT INTO CUENTA VALUES(55, 5000);

INSERT INTO CUENTA VALUES(55, 5500);



-- Ejercicio 21
    -- (B) INSERT INTO CUENTA VALUES(44, 4400);

-- Deadlock (interbloqueo o bloqueo mutuo en español), porque se producen accesos
-- cruzados a filas cuyos cambios no han sido confirmados, lo que produciria un
-- bloqueo infinito si no fuera porque Oracle lo interrumpe (el error actual)



-- Ejercicio 22
COMMIT;

-- Error por restriccion unica violada, porque al confirmarse los cambios en la
-- sesion A, las sentencias de la sesion B se ejecutan y coinciden las IDs 44 y
-- 55 (lo mismo que en el ejercicio 8, pero con 2 filas en vez de una)
