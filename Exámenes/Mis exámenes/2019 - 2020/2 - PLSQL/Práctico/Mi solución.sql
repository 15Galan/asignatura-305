-- Tablas NECESARIAS
CREATE TABLE T_CONTROL (
    TABLA VARCHAR2(64) NOT NULL,
    FECHA DATE NOT NULL);

CREATE TABLE T_AUDITA (
    USUARIO VARCHAR2(64) NOT NULL,
    TABLA VARCHAR2(64) NOT NULL,
    FECHA DATE NOT NULL);


-- Tablas para hacer PRUEBAS
CREATE TABLE MARCA (
    IDMARCA NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(128),
    PRECIOHORA NUMBER(6,2));

CREATE TABLE MODELO (
    IDMODELO NUMBER PRIMARY KEY,
    IDMARCA NUMBER REFERENCES MARCA (IDMARCA),
    NOMBRE VARCHAR2(128),
    NUMPUERTAS NUMBER,
    COMBUSTIBLE VARCHAR2(64),
    CAPACMALETERO NUMBER);

CREATE TABLE CLIENTE (
    IDCLIENTE VARCHAR2(16) PRIMARY KEY,
    TELEFONO NUMBER,
    NOMBRE VARCHAR2(64),
    APELLIDO1 VARCHAR2(64),
    APELLIDO2 VARCHAR2(64),
    EMAIL VARCHAR2(64));

CREATE TABLE VEHICULO (
    NUMBASTIDOR VARCHAR2(64) PRIMARY KEY,
    MATRICULA VARCHAR2(16) UNIQUE,
    FABRICACION NUMBER,
    IDMODELO NUMBER REFERENCES MODELO (IDMODELO),
    CLIENTE_IDCLIENTE VARCHAR2(16 ) REFERENCES CLIENTE,
    KILOMETRAJE NUMBER);

CREATE TABLE SERVICIO (
    IDSERVICIO NUMBER PRIMARY KEY,
    ESTADO VARCHAR2(64) NOT NULL,
    FECAPERTURA DATE,
    FECRECEPCION DATE,
    FECREALIZACION DATE,
    OBSCHAPA VARCHAR2(1024),
    NUMBASTIDOR VARCHAR2(64) REFERENCES VEHICULO,
    IDCLIENTE VARCHAR2(16) REFERENCES CLIENTE);


/* EJERCICIO 1 */
-- Trigger
CREATE OR REPLACE
    TRIGGER tr_control
        AFTER INSERT            -- Se indica que es ua vez insertada la fila
            ON t_control
                FOR EACH ROW    -- Se quiere ejecutar por cada fila insertada

    BEGIN
        INSERT INTO t_audita
            VALUES (user, :new.tabla, :new.fecha);
    END;
/


/* EJERCICIOS 2, 3, 4 y 5 */
-- Paquete (declaracion)
CREATE OR REPLACE
    PACKAGE PAQ_CREA AS     -- No puede crearse el cuerpo antes que la declaracion

        ERROR_TABLA EXCEPTION;      -- Ya se declara la excepcion aqui

        FUNCTION NUM_COLUMNAS (P_TABLA VARCHAR2) RETURN NUMBER;
        FUNCTION NUM_REFERENCIAS (P_TABLA VARCHAR2) RETURN NUMBER;
        PROCEDURE CREA_VISTAS_COLUMNAS (MIN_COLUMNAS NUMBER);
        FUNCTION NUM_TABLAS_REFERENCIADAS (P_TABLA VARCHAR2) RETURN NUMBER;
    END;
/

-- Paquete (cuerpo)
CREATE OR REPLACE
    PACKAGE BODY paq_crea AS

        -- Ejercicio 2
        FUNCTION num_columnas(p_tabla VARCHAR2)
            RETURN NUMBER AS

            resultado NUMBER;   -- Necesaria, para almacenar y comparar el valor pedido

            /* Investigando como sacar el numero de columnas
                -- Que vistas del diccionario da informacion sobre columnas?
                SELECT *
                    FROM DICT
                        WHERE comments LIKE '%COLUMNS%';

                -- Devuelve la cantidad de columnas de la tabla CLIENTE (por ejemplo)?
                SELECT COUNT(*)
                    FROM cols
                        WHERE table_name = 'CLIENTE';
                */

            BEGIN
                SELECT COUNT(*) INTO resultado      -- Devuelve 0 si la tabla no existe
                    FROM cols
                        WHERE table_name = p_tabla;

                IF resultado = 0 THEN
                    RAISE error_tabla;      -- Elevacion de la excepcion
                END IF;

                RETURN resultado;

            EXCEPTION                       -- Captura de la excepcion
                WHEN error_tabla THEN
                    DBMS_OUTPUT.PUT_LINE('Error de tabla');
            END;


        -- Ejercicio 3
        FUNCTION num_referencias(p_tabla VARCHAR2)
            RETURN NUMBER AS

            resultado NUMBER;   -- Necesaria, para almacenar y comparar el valor pedido

            BEGIN
                SELECT COUNT(*) INTO resultado
                    FROM USER_CONSTRAINTS           -- Vista del diccionario del enunciado
                        WHERE table_name = p_tabla
                            AND constraint_type = 'R';  -- Porque R es de REFERENCE

                IF resultado = 0 THEN
                    RAISE error_tabla;      -- Elevacion de la excepcion
                END IF;

                RETURN resultado;

            EXCEPTION                       -- Captura de la excepcion
                WHEN error_tabla THEN
                    DBMS_OUTPUT.PUT_LINE('Error de tabla');
            END;


        -- Ejercicio 4
        PROCEDURE crea_vistas_columnas(min_columnas NUMBER) AS

            sentencia VARCHAR2(516);    -- Opcional, la creo para comprobar la instruccion

            CURSOR tablas IS
                SELECT *
                    FROM user_tables;

            BEGIN
                FOR tabla IN tablas LOOP
                    IF min_columnas <= NUM_COLUMNAS(tabla.table_name) THEN      -- Funcion del ejercicio 3

                        sentencia := 'CREATE OR REPLACE VIEW VC_'||tabla.table_name||' AS
                            SELECT * FROM '||tabla.table_name;

                        -- DBMS_OUTPUT.PUT_LINE(sentencia);    -- Mostrar sentencias por pantalla

                        EXECUTE IMMEDIATE sentencia;

                    END IF;
                END LOOP;
            END;


        -- Ejercicio 5
        FUNCTION num_tablas_referenciadas(p_tabla VARCHAR2)
            RETURN NUMBER AS

            resultado NUMBER;   -- Necesaria, para almacenar y comparar el valor pedido

            BEGIN
                -- Instruccion del enunciado modificada tras estudiar el funcionamiento
                SELECT COUNT(a2.table_name) INTO resultado
                    FROM user_constraints a1, user_constraints a2
                        WHERE a1.r_constraint_name = a2.constraint_name
                            AND a1.table_name = p_tabla;

                IF resultado = 0 THEN
                    RAISE error_tabla;      -- Elevacion de la excepcion
                END IF;

                RETURN resultado;

            EXCEPTION                       -- Captura de la excepcion
                WHEN error_tabla THEN
                    DBMS_OUTPUT.PUT_LINE('Error de tabla');
            END;
    END;
/


COMMIT;     -- Guardar los cambios en la BD
