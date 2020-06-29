-- Ejercicio 1 (desde SYSTEM)
CREATE TABLESPACE ts_conce
    DATAFILE 'C:\Users\app\alumnos\concesionario.dbf'
    SIZE 5M
    AUTOEXTEND ON
    NEXT 1M
    MAXSIZE 100M;

ALTER TABLESPACE ts_conce
    ADD DATAFILE 'C:\Users\app\alumnos\concesionario2.dbf'
    SIZE 1M
    AUTOEXTEND ON
    NEXT 1M
    MAXSIZE 200M;


-- Ejercicio 2 (desde SYSTEM)
CREATE PROFILE perf_comercial
    LIMIT SESSIONS_PER_USER 1
    FAILED_LOGIN_ATTEMPTS 3
    PASSWORD_LOCK_TIME 7;

CREATE USER u_agente
    IDENTIFIED BY uagente
    DEFAULT TABLESPACE ts_conce
    QUOTA 100M ON ts_conce
    PROFILE perf_comercial;

    GRANT CONNECT
        TO u_agente;
    
CREATE TABLE u_agente.clientes (
    cif VARCHAR2(10) PRIMARY KEY,
    nombre VARCHAR2(60),
    direccion VARCHAR2(60),
    persona_contacto VARCHAR2(60),
    email VARCHAR2(60));

CREATE ROLE r_jefe;
    
    GRANT SELECT, INSERT, DELETE
        ON u_agente.clientes
        TO r_jefe;

CREATE USER esc
    IDENTIFIED BY esc
    DEFAULT TABLESPACE ts_conce
    QUOTA 100M ON ts_conce;
    
    GRANT r_jefe
        TO esc;
    
    -- Deben añadirse los permisos CONNECT y UPDATE (clientes) para poder hacer lo pedido.
    GRANT CONNECT
        TO r_jefe;
    
    GRANT UPDATE
        ON u_agente.clientes
        TO r_jefe;


-- Ejercicio 3
    -- 1. Para crear una tabla externa, primero hay que dar de alta un directorio en Oracle. Para ello
    -- vamos a buscar un directorio donde el usuario tenga acceso. Por ejemplo, podemos usar el
    -- directorio: 'C:\Users\app\alumnos\Oracle' y movemos el fichero ahí (suponemos que se llama CLIENTES.CSV).
    
    -- 2. Con el usuario system ejecutamos:
CREATE OR REPLACE
    DIRECTORY directorio_ext
        AS 'C:\Users\app\alumnos\Oracle';

    -- 3. Damos permiso a U_AGENTE para leer y escribir en el directorio:
GRANT READ, WRITE
    ON DIRECTORY directorio_ext
    TO u_agente;

GRANT CREATE TABLE
    TO u_agente;

    -- 4. Conectarse como ese usuario: u_agente.
    -- 5. Crear la tabla externa (desde U_AGENTE):
CREATE TABLE clientes_ext (
    cif VARCHAR2(10),
    nombre VARCHAR2(60),
    direccion VARCHAR2(60),
    personacontacto VARCHAR2(60),
    email VARCHAR2(60))
    ORGANIZATION EXTERNAL(
        DEFAULT DIRECTORY directorio_ext
            ACCESS PARAMETERS (
                records delimited BY newline
                fields terminated BY ','
                optionally enclosed BY '"')
            LOCATION ('clientes.csv'));
            
    -- 6. Cargamos los datos de la tabla externa en la tabla clientes (desde U_AGENTE)
INSERT INTO clientes
    SELECT *
        FROM clientes_ext;


-- Ejercicio 4 (desde SYSTEM)
CREATE ROLE r_administrativo;

    GRANT CONNECT
        TO r_administrativo;
    
    GRANT SELECT, INSERT, UPDATE(direccion)
        ON u_agente.clientes
        TO r_administrativo;


-- Ejercicio 6 (desde SYSTEM)
CREATE INDEX u_agente.idx_cliente_nombre
    ON u_agente.clientes(UPPER(nombre));

SELECT tablespace_name
    FROM dba_indexes
        WHERE index_name LIKE UPPER('%idx_cliente_nombre%');


-- Ejercicio 7 (desde SYSTEM)
CREATE TABLE esc.modelos (
    idmodelo NUMBER NOT NULL PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL ,
    num_puertas NUMBER,
    precio_Venta NUMBER,
    coste NUMBER,
    descuento NUMBER);

CREATE OR REPLACE
    VIEW esc.vmodelo AS (
        SELECT idmodelo, nombre, num_puertas, precio_venta, descuento
            FROM esc.modelos)
        WITH READ ONLY;
        
GRANT SELECT
    ON esc.vmodelo
    TO r_administrativo;


-- Ejercicio 8 (desde SYSTEM)
ALTER USER esc
    ACCOUNT LOCK;

CREATE USER njef
    IDENTIFIED BY njef
    PASSWORD EXPIRE;

    GRANT r_jefe
        TO njef;
