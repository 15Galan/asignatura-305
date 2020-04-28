-- Trigger a nivel de orden:
-- Se ejecuta el bloque de c�digo una vez.

-- Trigger a nivel de fila:
-- Se ejecuta el bloque de c�digo una vez por cada fila tratada.

CREATE TABLE pieza (            -- Tabla para practicar
    codigo NUMBER PRIMARY KEY,
    nombre VARCHAR2(50),
    cantidad NUMBER,
    precio NUMBER);

CREATE OR REPLACE
    TRIGGER tr_nuevapieza
        BEFORE INSERT ON pieza
        FOR EACH ROW
            BEGIN
                SELECT MAX(codigo)+1 INTO :new.codigo   -- Cambia el c�digo del INSERT por 
                    FROM pieza;                         -- el c�digo m�ximo + 1 de la tabla
                
                IF :new.codigo IS NULL THEN     -- Si en el primer dato insertado
                    :new.codigo := 1;           -- el c�digo es NULL, se asigna un 1
                END IF;
            
            END tr_nuevapieza;
/


INSERT INTO pieza
    VALUES (5, 'tuerqu�n', 5, 3);

INSERT INTO pieza
    VALUES (null, 'tuerco', 7, 4);

INSERT INTO pieza
    VALUES (1, 'tuerc�n', 10, 5);


CREATE TABLE suministros (
    pieza NUMBER,
    precio NUMBER,
    suministrador VARCHAR2(50));

CREATE TABLE suministros (
    pieza NUMBER
        REFERENCES piezas (codigo)
            ON DELETE CASCADE,
    precio NUMBER,
    suministrador VARCHAR2(50));