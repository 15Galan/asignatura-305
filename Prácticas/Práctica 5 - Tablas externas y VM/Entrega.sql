-- Paso #3
CREATE OR REPLACE
    DIRECTORY directorio_ext
        AS 'C:\Users\app\alumnos\Oracle';


-- Paso #4
GRANT READ, WRITE
    ON DIRECTORY directorio_ext
    TO autoracle;


GRANT CREATE PUBLIC SYNONYM, CREATE MATERIALIZED VIEW
    TO autoracle;


-- (Desde AUTORACLE)
    -- Paso #6
    CREATE TABLE cliente_externo (
        cliente_id varchar2(3),
        apellido varchar2(50),
        nombre varchar2(50),
        dni varchar2(9),
        usuario varchar2(20),
        email varchar2(100),
        direccion varchar2(100),
        codigo_postal number(5))
            ORGANIZATION EXTERNAL (
                DEFAULT DIRECTORY directorio_ext
                ACCESS PARAMETERS (
                    RECORDS DELIMITED BY newline
                    FIELDS TERMINATED BY ',')
                LOCATION ('clientes.txt'));
                
                
    SELECT *
        FROM cliente_externo;


    -- Paso #8
    INSERT INTO cliente
        SELECT cliente_id, null, nombre, apellido, null, email
            FROM cliente_externo;


    -- Paso #9
    CREATE INDEX idx_apellido
        ON cliente(upper(apellido1));


    -- Paso #11
    CREATE MATERIALIZED VIEW mv_facturas20
        REFRESH START WITH sysdate NEXT sysdate+1
        AS SELECT  c.idcliente, c.nombre, c.apellido1, c.apellido2, f.idfactura, f.fecemision, sum(p.preciounidadventa) total
                FROM cliente c  JOIN factura f ON c.idcliente = f.CLIENTE_idcliente
                                JOIN contiene co ON co.FACTURA_IDFACTURA = f.IDFACTURA 
                                JOIN pieza p ON co.PIEZA_CODREF = p.CODREF
                    WHERE EXTRACT (YEAR FROM f.fecemision) = 2020
                    GROUP BY c.idcliente, c.nombre, c.apellido1, c.apellido2, f.idfactura, f.fecemision;


    -- Paso #12
    CREATE PUBLIC SYNONYM vm_facturas
        FOR mv_facturas20;
