/* EJERCICIO 1 */
-- Trigger
CREATE OR REPLACE
    TRIGGER tr_nomina
        AFTER INSERT OR UPDATE
            ON nomina
                FOR EACH ROW

    BEGIN
        INSERT INTO control_nomina
            VALUES (sysdate, user, :new.empledo, :old.importe_bruto, :new.importe_bruto);
    END;
/


/* EJERCICIOS 2, 3, 4 y 5 */
-- Paquete (declaracion)
CREATE OR REPLACE
    PACKAGE pk_nomina AS     -- No puede crearse el cuerpo antes que la declaracion

        PROCEDURE p_crea_nomina(fecha_actual DATE, mes VARCHAR2);
        PROCEDURE p_borra_nomina(mes VARCHAR2);
        PROCEDURE p_vistas_empleados(categoria NUMBER);

    END pk_nomina;
/

-- Paquete (cuerpo)
CREATE OR REPLACE
    PACKAGE BODY pk_nomina AS

        -- Ejercicio 2
        PROCEDURE p_crea_nomina(fecha_actual DATE, mes VARCHAR2) AS
            BEGIN
                INSERT INTO nomina
                    SELECT fecha_actual, importe_neto, empleado, importe_bruto
                        FROM nomina
                            WHERE TO_CHAR(fecha_emision, 'mm/yyyy') = mes;
            END;
        
        
        -- Ejercicio 3
        PROCEDURE p_borra_nomina(mes VARCHAR2) AS
            BEGIN
                DELETE FROM nomina
                    WHERE TO_CHAR(fecha_emision, 'mm/yyyy') LIKE mes;
            END;
          
          
        -- Ejercicio 4
        PROCEDURE p_vistas_empleados(categoria NUMBER) AS
    
            sentencia VARCHAR2;
    
            CURSOR empleados IS
                SELECT *
                    FROM empleados;
    
            BEGIN
                FOR empleado IN empledos LOOP
                    
                    sentencia := 'CREATE OR REPLACE VIEW '||empleado.usuario||'_nomina AS
                      SELECT * FROM empleado E JOIN nomina N ON E.id = N.empleado WHERE E.id = '||empleado.id||';';
    
                    BEGIN
                        EXECUTE IMMEDIATE sentencia;
                        COMMIT;
                    
                    -- Ejercicio 5
                    /* Descomentar para incluir la correcion pedida en el ejercicio 5 
                    EXCEPTION
                        WHEN others THEN
                            DBMS_OUTPUT.put_line('ERROR: Excepcion en la creacion de la vista');
                    */
                    END;
                    
                END LOOP;
            END;
            
    END pk_nomina;
/


COMMIT;     -- Guardar los cambios en la BD
