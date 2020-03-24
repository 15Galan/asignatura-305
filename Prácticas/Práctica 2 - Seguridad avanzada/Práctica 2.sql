-- Paso #2
ALTER SYSTEM SET "WALLET_ROOT"='C:\Users\app\alumnos\Oracle_instalacion\wallet'
    SCOPE=SPFILE;

    -- No se us� la ruta C:\Users\Usuario_UMA\Oracle\wallet porque el usuario
    -- no tiene permisos de escritura en ella, as� que la sentencia no funciona
    -- correctamente. Sobre la nueva ruta s� se tienen dichos permisos.

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE"
    SCOPE=BOTH;


-- Paso #5
CREATE TABLE usuario1.empleado (
    id NUMBER,
    nombre VARCHAR2(128),
    apellidos VARCHAR2(128),
    salario NUMBER(6) ENCRYPT);

INSERT INTO usuario1.empleado
    VALUES (1, 'Homer J.', 'Simpson', 1000);

INSERT INTO usuario1.empleado
    VALUES (2, 'Bart', 'Simpson', 100);


-- Paso #6
SELECT *
    FROM DBA_ENCRYPTED_COLUMNS;


-- Paso #7
ALTER SYSTEM FLUSH BUFFER_CACHE;


-- Paso #8
CREATE OR REPLACE
    FUNCTION sec_function(p_schema VARCHAR2, p_obj VARCHAR2)
        RETURN VARCHAR2

        IS usu VARCHAR2(100);

        BEGIN
            IF (SYS_CONTEXT('USERENV', 'ISDBA')='TRUE')
                THEN RETURN '';
                -- Si el usuario se conecta como sysdba, podr� ver toda la tabla.

            ELSE
                usu := SYS_CONTEXT('userenv', 'SESSION_USER');
                RETURN 'UPPER(USER_NAME) = ''' || usu || '''';

            END IF;
        END;
/

    -- userenv  = Contexto de aplicaci�n.
    -- p_obj    = Nombre de la tabla o vista al cual se le aplicar� la pol�tica.
    -- p_schema = Esquema en el que se encuentra dicha tabla / vista.


-- Paso #9
ALTER TABLE usuario1.empleado
    ADD user_name VARCHAR2(20);


-- Paso #10
CREATE USER homerojay
    IDENTIFIED BY homerojay
    DEFAULT TABLESPACE ts_autoracle
    QUOTA 100K ON ts_autoracle;

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema=>'usuario1',
        object_name=>'empleado',
        policy_name=>'politica_empleados',
        function_schema=>'system',
        policy_function=> 'sec_function',
        statement_types=> 'SELECT, UPDATE');
END;
/


-- Paso #11
GRANT SELECT, UPDATE
    ON usuario1.empleado
    TO homerojay;


-- Paso #12
    -- Solo aparece la informaci�n del mismo usuario que hace la consulta.


-- Paso #14
    -- No.
    -- No.
    -- No puedo.
    -- S�.


-- Paso #16
CREATE OR REPLACE
    FUNCTION usuario1.sec_function_salary (p_schema varchar2, p_obj varchar2)
    RETURN VARCHAR2

    IS usu VARCHAR2(100);

    BEGIN
      usu := SYS_CONTEXT('userenv', 'SESSION_USER');
      RETURN 'UPPER(USER_NAME) = ''' || usu || '''';
      
    END;
/
