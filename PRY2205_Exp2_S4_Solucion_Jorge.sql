/* PRY2205 - Experiencia 2 - Semana 4
   Consulta de Bases de Datos - JOINS
   Script de solución
*/

ALTER SESSION SET nls_date_format = 'DD/MM/YYYY';

/* =========================================================
   CASO 1: Listado de Trabajadores
   ========================================================= */

SELECT
    t.numrut || '-' || t.dvrut                                AS "RUT_TRABAJADOR",
    INITCAP(t.appaterno || ' ' || t.apmaterno || ' ' || t.nombre) AS "NOMBRE_TRABAJADOR",
    NVL(INITCAP(c.nombre_ciudad), 'Sin ciudad')               AS "CIUDAD",
    t.sueldo_base                                             AS "SUELDO_BASE",
    tt.desc_categoria                                         AS "TIPO_TRABAJADOR",
    b.sigla                                                   AS "ESCOLARIDAD",
    a.nombre_afp                                              AS "AFP",
    i.nombre_isapre                                           AS "SISTEMA_SALUD"
FROM trabajador t
    LEFT JOIN comuna_ciudad   c  ON t.id_ciudad        = c.id_ciudad
    JOIN tipo_trabajador      tt ON t.id_categoria_t   = tt.id_categoria
    JOIN bono_escolar         b  ON t.id_escolaridad_t = b.id_escolar
    JOIN afp                  a  ON t.cod_afp          = a.cod_afp
    JOIN isapre               i  ON t.cod_isapre       = i.cod_isapre
WHERE t.sueldo_base BETWEEN 650000 AND 3000000
ORDER BY
    c.nombre_ciudad DESC,
    t.sueldo_base ASC;


/* =========================================================
   CASO 2: Listado de Cajeros
   ========================================================= */

SELECT
    t.numrut || '-' || t.dvrut                                AS "RUT_TRABAJADOR",
    INITCAP(t.appaterno || ' ' || t.apmaterno || ' ' || t.nombre) AS "NOMBRE_TRABAJADOR",
    INITCAP(c.nombre_ciudad)                                 AS "COMUNA_TRABAJADOR",
    COUNT(tc.nro_ticket)                                     AS "CANT_TICKETS",
    SUM(tc.monto_ticket)                                     AS "TOTAL_VENDIDO",
    NVL(SUM(ct.valor_comision), 0)                           AS "TOTAL_COMISION"
FROM trabajador t
    JOIN tipo_trabajador  tt ON t.id_categoria_t = tt.id_categoria
    LEFT JOIN comuna_ciudad c ON t.id_ciudad      = c.id_ciudad
    JOIN tickets_concierto tc ON t.numrut        = tc.numrut_t
    LEFT JOIN comisiones_ticket ct ON tc.nro_ticket = ct.nro_ticket
WHERE UPPER(tt.desc_categoria) = 'CAJERO'
GROUP BY
    t.numrut,
    t.dvrut,
    t.appaterno,
    t.apmaterno,
    t.nombre,
    c.nombre_ciudad
HAVING
    SUM(tc.monto_ticket) > 50000
ORDER BY
    SUM(tc.monto_ticket) DESC;


/* =========================================================
   CASO 3: Listado de Bonificaciones
   ========================================================= */

SELECT
    t.numrut || '-' || t.dvrut                                AS "RUT_TRABAJADOR",
    INITCAP(t.appaterno || ' ' || t.apmaterno || ' ' || t.nombre) AS "NOMBRE_TRABAJADOR",
    EXTRACT(YEAR FROM t.fecing)                               AS "ANNO_INGRESO",
    TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12)             AS "ANNOS_TRABAJADOS",
    NVL(COUNT(af.numrut_carga), 0)                            AS "CANT_CARGAS",
    i.nombre_isapre                                           AS "SISTEMA_SALUD",
    ROUND(
        CASE
            WHEN UPPER(i.nombre_isapre) = 'FONASA'
            THEN t.sueldo_base * 0.01
            ELSE 0
        END
    )                                                         AS "BONO_FONASA",
    ROUND(
        CASE
            WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12) <= 10
                THEN t.sueldo_base * 0.10
            ELSE t.sueldo_base * 0.15
        END
    )                                                         AS "BONO_ANTIGUEDAD",
    ROUND(
          CASE
              WHEN UPPER(i.nombre_isapre) = 'FONASA'
              THEN t.sueldo_base * 0.01
              ELSE 0
          END
        + CASE
              WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, t.fecing) / 12) <= 10
                  THEN t.sueldo_base * 0.10
              ELSE t.sueldo_base * 0.15
          END
    )                                                         AS "TOTAL_BONO"
FROM trabajador t
    JOIN isapre     i  ON t.cod_isapre = i.cod_isapre
    JOIN est_civil  ec ON ec.numrut_t  = t.numrut
    LEFT JOIN asignacion_familiar af ON af.numrut_t = t.numrut
WHERE
      ec.fecter_estcivil IS NULL
   OR ec.fecter_estcivil > SYSDATE
GROUP BY
    t.numrut,
    t.dvrut,
    t.appaterno,
    t.apmaterno,
    t.nombre,
    t.fecing,
    t.sueldo_base,
    i.nombre_isapre
ORDER BY
    t.numrut ASC;
