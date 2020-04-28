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
                        null;

                    ELSIF DELETING THEN
                        UPDATE mensajes_info
                            SET cuantos_mensajes = cuantos_mensajes - 1,
                                ultimo = null
                                WHERE tipo = :old.tipo;

                    END IF;
                END audita_mensajes_info;
/




