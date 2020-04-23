-- Ejercicio 1 (desde el usuario para el examen)
CREATE TABLE MARCA (
    IDMARCA NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(50),
    PRECIOHORA NUMBER(6,2))
    TABLESPACE ts_examen2020
    PCTFREE 10;


-- Ejercicio 2 (desde el usuario para el examen)
CREATE TABLE MODELO (
    IDMODELO NUMBER PRIMARY KEY,
    MARCA_IDMARCA NUMBER,
    NUMPUERTAS NUMBER,
    COMBUSTIBLE VARCHAR2(64),
    CAPACMALETERO NUMBER,
    NOMBRE VARCHAR(100))
    TABLESPACE TS_ALUMNOS
    PCTFREE 15;


-- Ejercicio 3 (desde el usuario para el examen)
    -- Claves primarias asignadas en los ejercicios 1 y 2.
SELECT *
    FROM user_ts_quotas;


-- Ejercicio 4 (desde el usuario para el examen)
CREATE INDEX idx_modelo_combustible
    ON modelo(UPPER(combustible))
    TABLESPACE ts_alumnos;

CREATE UNIQUE INDEX idx_marca_nombre
    ON marca(UPPER(nombre))
    TABLESPACE ts_alumnos;
    
CREATE INDEX idx_modelo_marca
    ON modelo(UPPER(marca_idmarca))
    TABLESPACE ts_alumnos;

CREATE INDEX idx_modelo_nombre
    ON modelo(UPPER(nombre))
    TABLESPACE ts_alumnos;

    -- Revisar dónde se crearon los índices
    SELECT index_name, tablespace_name
        FROM dba_indexes
            WHERE index_name LIKE 'IDX_%';


-- Ejercicio 5 (desde el usuario para el examen)
GRANT UPDATE(capacmaletero)
    ON modelo
    TO r_corrige;

GRANT SELECT
    ON modelo
    TO r_corrige;

    CREATE OR REPLACE
        VIEW vmarca AS (
            SELECT idmarca, nombre
                FROM marca)
            WITH READ ONLY;
        
GRANT SELECT
    ON vmarca
    TO r_corrige;


-- Ejercicio 6 (desde el usuario para el examen)
SELECT *
    FROM fis2020.v_preguntas;

    -- Pregunta 1
    SELECT *
        FROM dba_indexes
            WHERE index_name LIKE UPPER('idx_puertas');
    
    UPDATE fis2020.v_preguntas
        SET respuesta = 'ESC'
            WHERE id = 1;
    
    
    -- Pregunta 2
    SELECT *
        FROM user_users;
    
    UPDATE fis2020.v_preguntas
        SET respuesta = 'TS_DELTA'
            WHERE id = 2;
            
    
    -- Pregunta 3
    SELECT *
        FROM V$DATAFILE;    -- Filtré por fecha en la consulta, usando la GUI.

    UPDATE fis2020.v_preguntas
        SET respuesta = '/u01/app/oracle/product/18.0.0/dbhome_1/dbs/examen2020.dbf'
            WHERE id = 3;
    
    
    -- Pregunta 4


    -- Pregunta 5
    SELECT *
        FROM dba_profiles
            WHERE profile LIKE '%P_ALUMNO%'
                AND resource_name LIKE '%SESSIONS%';

    UPDATE fis2020.v_preguntas
        SET respuesta = '25'
            WHERE id = 5;

COMMIT;
