/* ===========================
   CASO 1: Reportería de Asesorías
   Banca (cod_sector = 3) y Retail (cod_sector = 4)
   =========================== */

SELECT
    p.id_profesional                                    AS id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre AS nombre_profesional,
    NVL(b.nro_asesorias_banca, 0)                       AS nro_asesorias_banca,
    NVL(b.monto_banca, 0)                               AS monto_honorarios_banca,
    NVL(r.nro_asesorias_retail, 0)                      AS nro_asesorias_retail,
    NVL(r.monto_retail, 0)                              AS monto_honorarios_retail,
    NVL(b.nro_asesorias_banca, 0)
      + NVL(r.nro_asesorias_retail, 0)                  AS total_asesorias,
    NVL(b.monto_banca, 0)
      + NVL(r.monto_retail, 0)                          AS total_honorarios
FROM profesional p
JOIN (
       /* Profesionales que tienen asesorías en Banca Y en Retail (operador SET) */
       SELECT id_profesional
       FROM asesoria a
       JOIN empresa e ON a.cod_empresa = e.cod_empresa
       WHERE e.cod_sector = 3
       INTERSECT
       SELECT id_profesional
       FROM asesoria a
       JOIN empresa e ON a.cod_empresa = e.cod_empresa
       WHERE e.cod_sector = 4
     ) mix
  ON p.id_profesional = mix.id_profesional
LEFT JOIN (
           /* Resumen por profesional en sector Banca */
           SELECT
               a.id_profesional,
               COUNT(*)        AS nro_asesorias_banca,
               SUM(a.honorario) AS monto_banca
           FROM asesoria a
           JOIN empresa e ON a.cod_empresa = e.cod_empresa
           WHERE e.cod_sector = 3
           GROUP BY a.id_profesional
         ) b
  ON p.id_profesional = b.id_profesional
LEFT JOIN (
           /* Resumen por profesional en sector Retail */
           SELECT
               a.id_profesional,
               COUNT(*)        AS nro_asesorias_retail,
               SUM(a.honorario) AS monto_retail
           FROM asesoria a
           JOIN empresa e ON a.cod_empresa = e.cod_empresa
           WHERE e.cod_sector = 4
           GROUP BY a.id_profesional
         ) r
  ON p.id_profesional = r.id_profesional
ORDER BY
    p.id_profesional;



/* ===========================
   CASO 2: Resumen de Honorarios
   Asesorías finalizadas en abril del año pasado
   =========================== */

/* Creación de la tabla de reporte mensual */
CREATE TABLE REPORTE_MES (
    id_profesional       NUMBER(10),
    nombre_profesional   VARCHAR2(60),
    nombre_profesion     VARCHAR2(25),
    nombre_comuna        VARCHAR2(20),
    nro_asesorias        NUMBER(4),
    total_honorarios     NUMBER(12),
    promedio_honorarios  NUMBER(12),
    minimo_honorario     NUMBER(12),
    maximo_honorario     NUMBER(12)
);

/* Carga de la información en REPORTE_MES */
INSERT INTO REPORTE_MES (
    id_profesional,
    nombre_profesional,
    nombre_profesion,
    nombre_comuna,
    nro_asesorias,
    total_honorarios,
    promedio_honorarios,
    minimo_honorario,
    maximo_honorario
)
SELECT
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre  AS nombre_profesional,
    pr.nombre_profesion                                   AS nombre_profesion,
    c.nom_comuna                                          AS nombre_comuna,
    COUNT(*)                                              AS nro_asesorias,
    ROUND(SUM(a.honorario))                               AS total_honorarios,
    ROUND(AVG(a.honorario))                               AS promedio_honorarios,
    ROUND(MIN(a.honorario))                               AS minimo_honorario,
    ROUND(MAX(a.honorario))                               AS maximo_honorario
FROM profesional p
JOIN asesoria  a ON a.id_profesional = p.id_profesional
JOIN empresa   e ON a.cod_empresa   = e.cod_empresa
JOIN profesion pr ON p.cod_profesion = pr.cod_profesion
JOIN comuna    c ON p.cod_comuna     = c.cod_comuna
WHERE
    EXTRACT(YEAR  FROM a.fin_asesoria) = EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12))
    AND EXTRACT(MONTH FROM a.fin_asesoria) = 4
GROUP BY
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre,
    pr.nombre_profesion,
    c.nom_comuna
ORDER BY
    p.id_profesional;



/* ===========================
   CASO 3: Modificación de Honorarios
   Marzo del año pasado
   =========================== */

/* Reporte ANTES de actualizar los sueldos */
SELECT
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre AS nombre_profesional,
    SUM(a.honorario)                                     AS total_honorarios_marzo,
    p.sueldo                                             AS sueldo_actual
FROM profesional p
JOIN asesoria a ON a.id_profesional = p.id_profesional
WHERE
    EXTRACT(YEAR  FROM a.fin_asesoria) = EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12))
    AND EXTRACT(MONTH FROM a.fin_asesoria) = 3
GROUP BY
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre,
    p.sueldo
ORDER BY
    p.id_profesional;


/* Actualización de sueldos según total de honorarios de marzo del año pasado */
UPDATE (
    SELECT
        p.sueldo,
        SUM(a.honorario) AS total_honorarios_marzo
    FROM profesional p
    JOIN asesoria a ON a.id_profesional = p.id_profesional
    WHERE
        EXTRACT(YEAR  FROM a.fin_asesoria) = EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12))
        AND EXTRACT(MONTH FROM a.fin_asesoria) = 3
    GROUP BY
        p.id_profesional,
        p.sueldo
)
SET sueldo = ROUND(
    CASE
        WHEN total_honorarios_marzo < 1000000 THEN sueldo * 1.10
        ELSE sueldo * 1.15
    END
);


/* Reporte DESPUÉS de actualizar los sueldos */
SELECT
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre AS nombre_profesional,
    SUM(a.honorario)                                     AS total_honorarios_marzo,
    p.sueldo                                             AS sueldo_actualizado
FROM profesional p
JOIN asesoria a ON a.id_profesional = p.id_profesional
WHERE
    EXTRACT(YEAR  FROM a.fin_asesoria) = EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12))
    AND EXTRACT(MONTH FROM a.fin_asesoria) = 3
GROUP BY
    p.id_profesional,
    p.appaterno || ' ' || p.apmaterno || ' ' || p.nombre,
    p.sueldo
ORDER BY
    p.id_profesional;

COMMIT;
