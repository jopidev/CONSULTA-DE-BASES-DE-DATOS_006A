/* =====================================================
   CONSULTA 1 — CLIENTES POR RANGO DE RENTA
   - Variables: &RENTA_MINIMA, &RENTA_MAXIMA
   - Solo clientes con celular
   - RUT con puntos y guion
   - Tramos por renta
   - Orden: Nombre completo ASC
   ===================================================== */

COLUMN rut FORMAT A15
COLUMN nombre_completo FORMAT A40

SELECT 
    TRIM(TO_CHAR(c.numrut_cli, 'FM999G999G999')) || '-' || c.dvrut_cli AS rut,
    INITCAP(c.apPaterno_cli || ' ' || c.apMaterno_cli || ' ' || c.nombre_cli) AS nombre_completo,
    c.renta_cli,
    CASE 
        WHEN c.renta_cli > 500000 THEN 'TRAMO 1'
        WHEN c.renta_cli BETWEEN 400000 AND 500000 THEN 'TRAMO 2'
        WHEN c.renta_cli BETWEEN 200000 AND 399999 THEN 'TRAMO 3'
        ELSE 'TRAMO 4'
    END AS tramo
FROM cliente c
WHERE c.renta_cli BETWEEN &RENTA_MINIMA AND &RENTA_MAXIMA
  AND c.celular_cli IS NOT NULL
ORDER BY nombre_completo ASC;

/* =====================================================
   CONSULTA 2 — SUELDO PROMEDIO POR CATEGORÍA Y SUCURSAL
   - Variable: &SUELDO_PROMEDIO_MINIMO
   - Conteo de empleados
   - Promedio de sueldo formateado
   - Orden: promedio DESC
   ===================================================== */

SELECT
    CASE e.id_categoria_emp
        WHEN 1 THEN 'Gerente'
        WHEN 2 THEN 'Supervisor'
        WHEN 3 THEN 'Ejecutivo de Arriendo'
        WHEN 4 THEN 'Auxiliar'
    END AS categoria,
    s.desc_sucursal AS sucursal,
    COUNT(*) AS total_empleados,
    TO_CHAR(ROUND(AVG(e.sueldo_emp)), 'L999G999G999') AS promedio_sueldo
FROM empleado e
JOIN sucursal s 
  ON s.id_sucursal = e.id_sucursal
GROUP BY e.id_categoria_emp, s.desc_sucursal
HAVING AVG(e.sueldo_emp) > &SUELDO_PROMEDIO_MINIMO
ORDER BY AVG(e.sueldo_emp) DESC;

/* =====================================================
   CONSULTA 3 — ARRIENDO PROMEDIO POR TIPO DE PROPIEDAD
   - Indicadores: total, avg arriendo, avg superficie, arriendo/m2
   - Clasificación por arriendo/m2: <5000 Económico, 5000-9999 Medio, >=10000 Alto
   - Mostrar solo promedio m2 > 1000
   - Orden: arriendo_m2 DESC
   ===================================================== */

SELECT 
    tp.desc_tipo_propiedad AS tipo_propiedad,
    COUNT(*) AS total_propiedades,
    ROUND(AVG(p.valor_arriendo)) AS promedio_arriendo,
    ROUND(AVG(p.superficie)) AS promedio_superficie,
    ROUND(AVG(p.valor_arriendo / p.superficie)) AS arriendo_m2,
    CASE 
        WHEN AVG(p.valor_arriendo / p.superficie) < 5000 THEN 'Económico'
        WHEN AVG(p.valor_arriendo / p.superficie) BETWEEN 5000 AND 9999 THEN 'Medio'
        ELSE 'Alto'
    END AS clasificacion
FROM propiedad p
JOIN tipo_propiedad tp 
  ON tp.id_tipo_propiedad = p.id_tipo_propiedad
GROUP BY tp.desc_tipo_propiedad
HAVING AVG(p.valor_arriendo / p.superficie) > 1000
ORDER BY arriendo_m2 DESC;
