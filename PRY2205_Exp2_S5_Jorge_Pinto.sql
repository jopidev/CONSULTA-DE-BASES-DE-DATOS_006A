
/*===========================================================
  CASO 1: LISTADO DE CLIENTES
===========================================================*/

SELECT 
    TO_CHAR(c.numrun, '99G999G999') || '-' || UPPER(c.dvrun)         AS "RUT_CLIENTE",
    INITCAP(
        TRIM(
            c.pnombre || ' ' || 
            NVL(c.snombre, '') || ' ' || 
            c.appaterno || ' ' || 
            NVL(c.apmaterno, '')
        )
    )                                                              AS "NOMBRE_CLIENTE",
    UPPER(p.nombre_prof_ofic)                                      AS "PROFESION_OFICIO",
    UPPER(t.nombre_tipo_cliente)                                   AS "TIPO_CLIENTE",
    EXTRACT(YEAR FROM c.fecha_inscripcion)                         AS "ANIO_INSCRIPCION"
FROM cliente c
     JOIN profesion_oficio p ON c.cod_prof_ofic = p.cod_prof_ofic
     JOIN tipo_cliente t     ON c.cod_tipo_cliente = t.cod_tipo_cliente
WHERE UPPER(t.nombre_tipo_cliente) = 'TRABAJADORES DEPENDIENTES'
  AND UPPER(p.nombre_prof_ofic) IN ('CONTADOR', 'VENDEDOR')
  AND EXTRACT(YEAR FROM c.fecha_inscripcion) >
        (SELECT ROUND(AVG(EXTRACT(YEAR FROM fecha_inscripcion)))
         FROM cliente)
ORDER BY c.numrun ASC;


/*===========================================================
  CASO 2: AUMENTO DE CRÉDITO
===========================================================*/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE clientes_cupos_compra PURGE';
EXCEPTION
    WHEN OTHERS THEN
        NULL;
END;
/

CREATE TABLE clientes_cupos_compra AS
SELECT
    TO_CHAR(c.numrun, '99G999G999') || '-' || UPPER(c.dvrun)        AS rut_cliente,
    TRUNC(MONTHS_BETWEEN(SYSDATE, c.fecha_nacimiento)/12)          AS edad,
    tc.cupo_disp_compra                                            AS cupo_disp_compra
FROM cliente c
     JOIN tarjeta_cliente tc ON c.numrun = tc.numrun
WHERE tc.cupo_disp_compra >=
        (SELECT MAX(tc2.cupo_disp_compra)
         FROM tarjeta_cliente tc2
         WHERE EXTRACT(YEAR FROM tc2.fecha_solic_tarjeta) = EXTRACT(YEAR FROM SYSDATE) - 1);

SELECT
    rut_cliente           AS "RUT_CLIENTE",
    edad                  AS "EDAD",
    cupo_disp_compra      AS "CUPO_DISP_COMPRAS"
FROM clientes_cupos_compra
ORDER BY edad ASC;
