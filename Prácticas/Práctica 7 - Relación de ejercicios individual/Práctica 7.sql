SHOW SERVEROUTPUT;
SET SERVEROUTPUT ON;

-- Ejercicio 1
CREATE TABLE datos (
    codigo NUMBER(9),
    nombre VARCHAR2(15),
    fecha DATE);


-- Ejercicio 2
CREATE SEQUENCE secuencia_datos
    START WITH 100
    INCREMENT BY 3;


-- Ejercicio 3
CREATE OR REPLACE
    FUNCTION num_aleatorio (n NUMBER)
        RETURN NUMBER
        AS
            BEGIN
                DECLARE
                    numero NUMBER := 0;
                    digito NUMBER;
                    
                BEGIN
                    FOR contador IN 0 .. n-1 LOOP
                        digito := TRUNC(DBMS_RANDOM.value(0,10));
                        numero := numero + digito * POWER(10,contador);
                        
                        -- DBMS_OUTPUT.put_line('Digito : '||digito);
                        -- DBMS_OUTPUT.put_line('Numero : '||numero);
                        
                    END LOOP;
                    
                    RETURN numero;
                END;
                
            END num_aleatorio;
/


-- Ejercicio 4
CREATE OR REPLACE
    FUNCTION cadena_aleatoria (n NUMBER)
        RETURN VARCHAR2
        AS
            BEGIN
                RETURN DBMS_RANDOM.string('u',n);
            END cadena_aleatoria;
/


-- Ejercicio 5
CREATE OR REPLACE
    FUNCTION calcular_fecha (f DATE, d VARCHAR2, n NUMBER)
                RETURN DATE
        AS
            BEGIN
                IF n >= 0 THEN
                    DECLARE
                        fecha_final DATE := f;

                    BEGIN
                        FOR i IN 0 .. n-1 LOOP
                            fecha_final := NEXT_DAY(fecha_final,d);
                        END LOOP;

                        -- DBMS_OUTPUT.put_line(fecha_final);
                        RETURN fecha_final;
                    END;

                ELSE
                    RETURN null;
                    
                END IF;

            END calcular_fecha;
/


-- Ejercicio 6
CREATE OR REPLACE
    PROCEDURE rellenar (n NUMBER) AS
        BEGIN
            DECLARE
                contador NUMBER := 0;
                
            BEGIN            
                WHILE (contador <= n-1) AND (contador <= 99) LOOP
                    INSERT INTO datos
                        VALUES (
                        secuencia_datos.nextval,
                        cadena_aleatoria(n),
                        calcular_fecha(sysdate, TO_CHAR(sysdate, 'day'), num_aleatorio(n)));
                    
                    contador := contador+1;
                END LOOP;
                
                COMMIT;
            END;
            
        END rellenar;
/


-- Ejercicio 7
DESC all_objects;

SELECT *
    FROM all_objects;

CREATE TABLE tb_objetos (
    nombre VARCHAR2(128),
    codigo NUMBER,
    fecha_creacion DATE,
    fecha_modificacion DATE,
    tipo VARCHAR2(23),
    esquema_original VARCHAR2(128));

CREATE OR REPLACE
    PROCEDURE rellenar (n NUMBER) AS
        BEGIN
            DECLARE
                CURSOR filas IS (
                    SELECT
                        object_name,
                        object_id,
                        created,
                        last_ddl_time,
                        object_type,
                        owner
                            FROM all_objects)
                        FOR UPDATE;
                        
            BEGIN            
                FOR fila IN filas LOOP
                    NULL;
                END LOOP;
                
                COMMIT;
            END;
            
        END rellenar;
/
