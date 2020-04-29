-- Ejercicio 1
CREATE TABLE mensajes (
    codigo NUMBER(20) PRIMARY KEY,
    texto VARCHAR2(200));

CREATE TABLE audita_mensajes (
    quien VARCHAR2(20),
    como VARCHAR2(20),
    cuando DATE);


-- Ejercicio 2
CREATE OR REPLACE
    TRIGGER audita_mensajes         -- Dejará de funcionar en el siguiente ejercicio
        AFTER INSERT OR UPDATE      -- ya que se le añaden columnas a la tabla 'mensajes'
            ON mensajes
                BEGIN                    
                    IF INSERTING THEN
                        INSERT INTO audita_mensajes
                            VALUES (user, 'INSERT', sysdate);
                    
                    ELSIF UPDATING THEN
                        INSERT INTO audita_mensajes
                            VALUES (user, 'UPDATING', sysdate);
                    END IF;
                    
                END audita_mensajes;
/


-- Ejercicio 2
ALTER TABLE mensajes
    ADD tipo VARCHAR2(23);


INSERT INTO mensajes
    VALUES(1, '2 + 2 = 4', 'informacion');

INSERT INTO mensajes
    VALUES(2, 'No entrar', 'restriccion');

INSERT INTO mensajes
    VALUES(3, '¡AAAAAAAAAAAAH!', 'error');

INSERT INTO mensajes
    VALUES(4, 'Mejor no entres', 'aviso');

INSERT INTO mensajes
    VALUES(5, '2 + 2 = ?', 'ayuda');

INSERT INTO mensajes
    VALUES(6, 'La fecha de hoy es '||TO_CHAR(sysdate), 'informacion');

INSERT INTO mensajes
    VALUES(7, 'No se me ocurre nada', 'restriccion');

INSERT INTO mensajes
    VALUES(8, '2 + 2 = 5', 'error');

INSERT INTO mensajes
    VALUES(9, 'Cuidado', 'aviso');

INSERT INTO mensajes
    VALUES(10, '¿Y ahora qué?', 'ayuda');


CREATE TABLE mensajes_info (
    tipo VARCHAR(30) PRIMARY KEY,
    cuantos_mensajes NUMBER(2),
    ultimo VARCHAR2(200));

    -- Se ha cargado manualmente la información en la tabla
    -- 'mensajes_info' usando la interfaz de SQL Developer

CREATE OR REPLACE
    TRIGGER audita_mensajes_info
        AFTER INSERT OR UPDATE OR DELETE
            ON mensajes FOR EACH ROW
                BEGIN
                    IF INSERTING THEN
                        UPDATE mensajes_info
                            SET cuantos_mensajes = cuantos_mensajes + 1,
                                ultimo = :new.texto
                                WHERE tipo = :new.tipo;

                    ELSIF UPDATING THEN
                        IF :new.tipo != :old.tipo THEN
                            UPDATE mensajes_info
                                SET cuantos_mensajes = cuantos_mensajes + 1,
                                    ultimo = :new.texto
                                    WHERE tipo = :new.tipo;
                            
                            UPDATE mensajes_info
                                SET cuantos_mensajes = cuantos_mensajes - 1,
                                    ultimo = null
                                    WHERE tipo = :old.tipo;
                        END IF;

                    ELSIF DELETING THEN
                        UPDATE mensajes_info
                            SET cuantos_mensajes = cuantos_mensajes - 1,
                                ultimo = null
                                WHERE tipo = :old.tipo;

                    END IF;
                END audita_mensajes_info;
/


-- Ejercicio 3
DROP TABLE mensajes;

CREATE TABLE mensajes_texto (
    codigo VARCHAR2(20),
    texto VARCHAR2(200));

CREATE TABLE mensajes_tipo (
    codigo VARCHAR2(20),
    tipo VARCHAR2(23));

CREATE VIEW mensajes AS
    SELECT Tx.codigo, texto, tipo
        FROM mensajes_texto Tx
            JOIN mensajes_tipo Ti ON Tx.codigo = Ti.codigo;

SELECT *
    FROM mensajes;
    
    -- Sí, sale lo mismo que antes (estructura)
    
INSERT INTO mensajes
    VALUES(1, '2 + 2 = 4', 'informacion');
    
    -- No puedo hacer inserciones, porque es una vista
    
    -- Se podría arreglar creando un disparador que se active al intentar
    -- insertar datos en una vista y, antes de que eso suceda, inserte dichos datos
    -- en las tablas que la componen; de forma que no se inserta una fila en la vista,
    -- sino que se inserta una fila en cada tabla, actualizando la vista

CREATE OR REPLACE
    TRIGGER insertar_mensajes
        INSTEAD OF INSERT
            ON mensajes
                BEGIN
                    INSERT INTO mensajes_texto
                        VALUES (:new.codigo, :new.texto);
                    
                    INSERT INTO mensajes_tipo
                        VALUES (:new.codigo, :new.tipo);
                        
                END insertar_mensajes;
/

    -- Volviendo a ejecutar el INSERT anterior, la vista se actualiza correctamente


-- Ejercicio 4
CREATE TABLE mensajes_borrados (
    codigo VARCHAR2(20),
    texto VARCHAR2(200));

CREATE OR REPLACE 
    TRIGGER borrar_mensajes
        BEFORE DELETE
            ON mensajes_texto FOR EACH ROW
                BEGIN
                    INSERT INTO mensajes_borrados
                        VALUES (:old.codigo, :old.texto);
                        
                END borrar_mensajes;
/


-- Ejercicio 5
-- Usando la interfaz de SQL Developer:
    -- Conexion > Programador > Trabajos > Nuevo Trabajo

-- Escribiendo la sentencia SQL:
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '"UBD689"."BORRAR_MENSAJES_BORRADOS"',
            job_type => 'PLSQL_BLOCK',
            job_action =>
                'BEGIN
                    EXECUTE IMMEDIATE
                        ''TRUNCATE mensajes_borrados;'';
                END;',
                    
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=2;BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN',
            end_date => NULL,
            enabled => FALSE,
            auto_drop => FALSE,
            comments => 'Elimina las filas de la tabla MENSAJES_BORRADOS cada 2 min.');


    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"UBD689"."BORRAR_MENSAJES_BORRADOS"', 
             attribute => 'store_output', value => TRUE);
    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => '"UBD689"."BORRAR_MENSAJES_BORRADOS"', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_OFF);
      

    DBMS_SCHEDULER.enable(
             name => '"UBD689"."BORRAR_MENSAJES_BORRADOS"');
END;

    -- Esta vista permite ver información sobre la ejecución de los trabajos:
    SELECT *
        FROM dba_scheduler_job_run_details
            WHERE owner LIKE user;          -- Mostrará solo los trabajos de este usuario

