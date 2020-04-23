-- Ejercicio 1 (desde UBDxxx)
    -- Las siguientes instrucciones fallan si se comenta en la misma línea.
    
    -- Describir la tabla (ver su estructura).
    DESC user_tables;
    -- Ver el usuario conectado (yo mismo).
    SHOW user;

    -- Ver el estado del parámetro SERVEROUTPUT.
    SHOW serveroutput;
    -- Activar SERVEROUTPUT durante esta sesión (habilitar mensajes por pantalla).
    SET SERVEROUTPUT ON;

-- Bloque de PL/SQL anónimo
DECLARE
    -- fila conjunto_tablas%ROW_TYPE;    -- Declarar la variable 'fila' con el tipo de la columna.

    CURSOR tablas IS
        SELECT table_name
            FROM user_tables;
            
BEGIN
    FOR tabla IN tablas LOOP     -- FOR variable IN (1..a)
        DBMS_OUTPUT.PUT_LINE('La tabla '||tabla.table_name||' pertenece al esquema '||user);
    END LOOP;
    
    -- EXIT WHEN cursor%NO_DATA_FOUND   -- Salir cuando el cursor se quede sin datos (con FOR es automático)
END;
/


-- Ejercicio 2 (desde UBDxxx)
DECLARE
    CURSOR tablas IS
        SELECT owner, table_name
            FROM all_tables;
            
BEGIN
    FOR tabla IN tablas LOOP
        DBMS_OUTPUT.PUT_LINE('La tabla '||tabla.table_name||' pertenece al esquema '||tabla.owner);
    END LOOP;
END;
/


-- Ejercicio 3
-- No he modificado nada, ya que mi usuario no tiene acceso.


-- Ejercicio 4
-- Ambas sentencias devolverían lo mismo si en la segunda se especifica 'owner = user'.
-- No obstante, ocurre que la primera es mucho más eficiente ya que la definición del cursor
-- se especifica sobre la vista del diccionario 'user_tables', que ya son las tablas de 'user'.
-- Mediante esa definición se evita comprobar la condición 'owner = user' para cada fila de la
-- vista 'all_tables' en la segunda sentencia.


-- Ejercicio 5 (desde UBDxxx)
CREATE OR REPLACE
    PROCEDURE recorre_tablas(p_mode IN NUMBER) AS
        BEGIN
            IF p_mode = 0 THEN
                DECLARE
                    CURSOR cursor IS
                        SELECT owner, table_name
                            FROM all_tables;
                            
                BEGIN
                    FOR tabla IN cursor LOOP
                        DBMS_OUTPUT.PUT_LINE('La tabla '||tabla.table_name||' pertenece al esquema '||tabla.owner);
                    END LOOP;
                END;
            
            ELSIF p_mode IS NOT NULL THEN
                DECLARE
                    CURSOR cursor IS
                        SELECT table_name
                            FROM user_tables;
                            
                BEGIN
                    FOR tabla IN cursor LOOP
                        DBMS_OUTPUT.PUT_LINE('La tabla '||tabla.table_name||' pertenece al esquema '||user);
                    END LOOP;
                END;
                
            END IF;
            
            EXCEPTION
                WHEN no_data_found
                    THEN DBMS_OUTPUT.PUT_LINE('Entrada 0: tablas a las que tiene acceso el usuario.\nEntrada no 0: muestra las tablas propias del usuario');
                
        END recorre_tablas;
/

EXEC recorre_tablas(0);
EXEC recorre_tablas(5);
EXEC recorre_tablas( ); -- No funciona aún.
