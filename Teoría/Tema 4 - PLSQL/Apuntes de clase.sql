-- Funci�n que almacena en 'variable' un nombre de la 'tabla'
-- que cumplan la condici�n.
DECLARE
  variable VARCHAR2(200);

  BEGIN
    SELECT nombre INTO variable
      FROM tabla
        WHERE condicion;
  END;
/

  -- Si la selecci�n devuelve m�s de una fila que cumpla la condici�n, se necesitan cursores.

-- Declaraci�n expl�cita de un cursor (estructura ABRIR-TRAER-CERRAR):
DECLARE
  variable VARCHAR2(200);

  CURSOR cursor IS
    SELECT nombre INTO variable
      FROM tabla
        WHERE condicion;

  BEGIN
    OPEN cursor;                  -- ABRIR
    FETCH cursor INTO variable;   -- Esto trata cada fila de un conjunto (TRAER).

    DBMS_OUTPUT.PUT_LINE('La primera l�nea es '||variable);

    CLOSE cursor;                 -- CERRAR
  END;
/


-- Declaraci�n impl�cita de un cursor:
DECLARE
  variable VARCHAR2(200);

  BEGIN
    FOR variable IN (   -- Almacena en 'variable' cada valor obtenido
      SELECT nombre     -- usando un cursor impl�cito en cada iteraci�n
        FROM tabla)
          LOOP

      NULL;
    END LOOP;
  END;
/


-- Usar un cursor para actualizar datos (hacer cualquier cosa con una fila):
DECLARE
  variable VARCHAR2(200);

  CURSOR cursor IS
    SELECT nombre INTO variable
      FROM tabla
        WHERE condicion
          FOR UPDATE OF columna;  -- Si no se especifica la columna, bloquea el resto de procesos.
                                  -- Si se sabe qu� columna modificar, se debe especificar.

  BEGIN
    OPEN cursor;                  -- ABRIR
    FETCH cursor INTO variable;   -- Esto trata cada fila de un conjunto (TRAER).

    DBMS_OUTPUT.PUT_LINE('La primera l�nea es '||variable);

    CLOSE cursor;                 -- CERRAR
  END;
/



-- PAQUETES
-- Un paquete es un conjunto de funciones y/o procedimientos,
-- sirve para organizar

-- C�mo crear un paquete de definiciones:
CREATE OR REPLACE
  PACKAGE paquete AS

    PROCEDURE procedimiento (atributo NUMBER);  -- Definici�n de 'procedimiento'

    FUNCTION funcion (atributo NUMBER)          -- Definici�n de 'funcion'
      RETURN NUMBER;

  END paquete;


-- C�mo crear un paquete:
CREATE OR REPLACE
  PACKAGE paquete AS

    PROCEDURE procedimiento (atributo NUMBER) AS
      BEGIN
        null;
      END procedimiento;

    FUNCTION funcion (atributo NUMBER)  -- Devuelve el mismo n�mero
      RETURN NUMBER AS
      BEGIN
        RETURN atributo;
      END funcion;

  END paquete;


-- Usar un paquete:
EXEC paquete.procedimiento(5);    -- Ejecutar un procedimiento

DECLARE                           -- Las funciones deben usarse en un cuerpo,
  resultado NUMBER;               -- para usar el valor de su RETURN

  EXCEPTION mi_error;             -- Tipo de excepci�n creado por m�

  BEGIN
    resultado := paquete.funcion(3);    -- Cambiar el 3 para probar las excepciones

    DBMS_OUTPUT.PUT_LINE('El par�metro es '||resultado);

    EXCEPTION           -- Tratamiento de excepciones
      WHEN zero_divide
        THEN DBMS_OUTPUT.PUT_LINE('Se ha dividido por 0.');

      WHEN mi_error
        THEN DBMS_OUTPUT.PUT_LINE('Se ha producido una excepci�n que yo he creado');

      WHEN others   -- Para cualquier otro caso.
        THEN DBMS_OUTPUT.PUT_LINE('Ni idea de qu� ha pasado.');

  END;  -- Si no se trata la excepci�n, se eleva.
/


-- Diferencias entre DBMS_SQL y EXECUTE IMMEDIATE:
DECLARE
  tabla VARCHAR2(100);

  BEGIN
    tabla := 'EMPLEADOS';

    EXECUTE IMMEDIATE   -- Necesario si se usa una sentencia DDL dentro de PL/SQL
                        -- o si se usa una sentencia DML con objetos desconocidos
                        -- cuando se quiera ejecutar
      'INSERT INTO '||tabla||' VALUES (121562, ''Gal�n'');';

    COMMIT;
  END;
