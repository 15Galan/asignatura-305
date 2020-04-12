-- Paso #4
SELECT *
    FROM v$datafile;

SELECT *
    FROM dba_tablespaces;

-- Paso #5
DROP TABLESPACE ts_autoracle
    INCLUDING CONTENTS;

CREATE TABLESPACE ts_autoracle
    DATAFILE 'C:\USERS\APP\ALUMNOS\ORADATA\ORCL\autoracle.dbf'
    SIZE 16M
    AUTOEXTEND ON NEXT 200K
    MAXSIZE 128M;


-- Paso #6
DROP USER autoracle
    CASCADE;

CREATE USER autoracle
    IDENTIFIED BY autoracle
    DEFAULT TABLESPACE ts_autoracle
    QUOTA UNLIMITED ON ts_autoracle;

GRANT
    CONNECT,
    CREATE TABLE,
    CREATE VIEW,
    CREATE MATERIALIZED VIEW
        TO AUTORACLE;
    