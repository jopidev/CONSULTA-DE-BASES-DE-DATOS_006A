
/*****************************************************************
  CASO 1: Análisis de Facturas
  Reglas:
  - Clasificación por total: 0–50000=Bajo, 50001–100000=Medio, >100000=Alto.
  - Forma de pago: 1=EFECTIVO, 2=TARJETA DEBITO, 3=TARJETA CREDITO, otro=CHEQUE.
  - RUT con largo 10, rellenando con 0 a la izquierda.
  - Solo facturas del año anterior al de ejecución.
  - Orden: fecha desc, monto neto desc.
  - Fechas y montos formateados, redondeo a enteros cuando aplique.
******************************************************************/
-- Tablas esperadas: FACTURA (ajusta si difiere)
-- Columnas usadas (ajusta si difiere):
-- f.id_factura, f.fecha, f.rut, f.cod_pago, f.monto_neto, f.total

SELECT
    f.id_factura                                          AS ID_FACTURA,
    TO_CHAR(f.fecha, 'DD-MON-YYYY')                       AS FECHA_FACTURA,
    LPAD(f.rut, 10, '0')                                  AS RUT_10,
    CASE 
        WHEN ROUND(f.total) BETWEEN 0 AND 50000 THEN 'Bajo'
        WHEN ROUND(f.total) BETWEEN 50001 AND 100000 THEN 'Medio'
        WHEN ROUND(f.total) > 100000 THEN 'Alto'
        ELSE 'Sin clasificar'
    END                                                   AS CLASIF_TOTAL,
    CASE f.cod_pago
        WHEN 1 THEN 'EFECTIVO'
        WHEN 2 THEN 'TARJETA DEBITO'
        WHEN 3 THEN 'TARJETA CREDITO'
        ELSE 'CHEQUE'
    END                                                   AS FORMA_PAGO,
    ROUND(f.monto_neto)                                   AS MONTO_NETO_RED,
    ROUND(f.total)                                        AS TOTAL_RED
FROM factura f
WHERE EXTRACT(YEAR FROM f.fecha) = EXTRACT(YEAR FROM ADD_MONTHS(SYSDATE, -12))
ORDER BY f.fecha DESC, f.monto_neto DESC;


/*****************************************************************
  CASO 2: Clasificación de Clientes
  Reglas:
  - Mostrar RUT invertido (derecha a izquierda) y rellenar con * hasta largo 10.
  - Manejo de nulos: teléfono ('Sin teléfono'), comuna ('Sin comuna'), correo ('Correo no registrado').
  - Solo clientes con estado 'A' y crédito > 0.
  - Dominio correo: parte después de '@'.
  - Categoría por (saldo/credito): 
      < 0.5 → 'Bueno' (mostrar diferencia crédito - saldo)
      0.5–0.8 → 'Regular' (mostrar saldo)
      > 0.8 → 'Crítico'
  - Orden por nombre asc.
******************************************************************/
-- Tabla esperada: CLIENTE (ajusta si difiere)
-- Columnas usadas (ajusta si difiere):
-- c.id_cliente, c.nombre, c.rut, c.telefono, c.comuna, c.correo, c.estado, c.credito, c.saldo

SELECT
    c.id_cliente                                                AS ID_CLIENTE,
    c.nombre                                                    AS NOMBRE,
    -- Invertir RUT y rellenar a la derecha con '*' hasta 10 caracteres.
    -- REVERSE está disponible en versiones modernas. Si no existe, reemplazar por un método alternativo.
    RPAD(REVERSE(LPAD(c.rut, 10, '0')), 10, '*')                AS RUT_INV_PAD,
    NVL(c.telefono, 'Sin teléfono')                             AS TELEFONO,
    NVL(c.comuna, 'Sin comuna')                                 AS COMUNA,
    NVL(c.correo, 'Correo no registrado')                       AS CORREO,
    CASE 
        WHEN c.correo IS NOT NULL AND INSTR(c.correo, '@') > 0 
            THEN SUBSTR(c.correo, INSTR(c.correo, '@') + 1)
        ELSE NULL
    END                                                         AS DOMINIO_CORREO,
    c.credito                                                   AS CREDITO,
    c.saldo                                                     AS SALDO,
    ROUND(c.saldo / NULLIF(c.credito, 0), 4)                    AS RATIO_SALDO_CREDITO,
    CASE 
        WHEN (c.saldo / NULLIF(c.credito, 0)) < 0.5 THEN 'Bueno'
        WHEN (c.saldo / NULLIF(c.credito, 0)) <= 0.8 THEN 'Regular'
        ELSE 'Crítico'
    END                                                         AS CATEGORIA,
    CASE 
        WHEN (c.saldo / NULLIF(c.credito, 0)) < 0.5 THEN TO_CHAR(ROUND(c.credito - c.saldo), 'FM999G999G999')
        WHEN (c.saldo / NULLIF(c.credito, 0)) <= 0.8 THEN TO_CHAR(ROUND(c.saldo), 'FM999G999G999')
        ELSE NULL
    END                                                         AS VALOR_MOSTRAR
FROM cliente c
WHERE c.estado = 'A'
  AND c.credito > 0
ORDER BY c.nombre ASC;


/*****************************************************************
  CASO 3: Stock de Productos
  Reglas:
  - Mostrar valor de compra en dólares; si es nulo, 'Sin registro'.
  - Convertir a CLP con variable :TIPOCAMBIO_DOLAR.
  - Alertas por stock usando :UMBRAL_BAJO y :UMBRAL_ALTO.
  - Descuento 10% si TOTALSTOCK > 80 (aplicado sobre valor unitario).
  - Solo productos con DESCRIPCION que contenga 'zapato' (case-insensitive)
    y PROCEDENCIA = 'i'.
  - Orden por id de producto desc.
******************************************************************/
-- Tabla esperada: PRODUCTO (ajusta si difiere)
-- Columnas usadas (ajusta si difiere):
-- p.id_producto, p.descripcion, p.procedencia, p.totalstock, p.valor_compra_usd, p.valor_unitario

-- Variables de sustitución (SQL*Plus/SQL Developer):
-- :TIPOCAMBIO_DOLAR, :UMBRAL_BAJO, :UMBRAL_ALTO

SELECT
    p.id_producto                                              AS ID_PRODUCTO,
    p.descripcion                                              AS DESCRIPCION,
    p.procedencia                                              AS PROCEDENCIA,
    CASE 
        WHEN p.valor_compra_usd IS NULL THEN 'Sin registro'
        ELSE TO_CHAR(ROUND(p.valor_compra_usd), 'FM999G999G999')
    END                                                        AS VALOR_COMPRA_USD,
    CASE 
        WHEN p.valor_compra_usd IS NULL THEN NULL
        ELSE ROUND(p.valor_compra_usd * :TIPOCAMBIO_DOLAR)
    END                                                        AS VALOR_COMPRA_CLP,
    p.totalstock                                               AS TOTALSTOCK,
    CASE 
        WHEN p.totalstock IS NULL THEN 'Sin datos'
        WHEN p.totalstock < :UMBRAL_BAJO THEN '¡ALERTA stock muy bajo!'
        WHEN p.totalstock BETWEEN :UMBRAL_BAJO AND :UMBRAL_ALTO THEN '¡Reabastecer pronto!'
        ELSE 'OK'
    END                                                        AS ALERTA_STOCK,
    p.valor_unitario                                           AS VALOR_UNITARIO,
    CASE 
        WHEN p.totalstock > 80 THEN ROUND(p.valor_unitario * 0.10)
        ELSE 0
    END                                                        AS DESCUENTO_APLICADO,
    CASE 
        WHEN p.totalstock > 80 THEN ROUND(p.valor_unitario * 0.90)
        ELSE ROUND(p.valor_unitario)
    END                                                        AS VALOR_CON_DESCUENTO
FROM producto p
WHERE LOWER(p.descripcion) LIKE '%zapato%'
  AND p.procedencia = 'i'
ORDER BY p.id_producto DESC;

