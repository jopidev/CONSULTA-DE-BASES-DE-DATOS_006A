CREATE OR REPLACE SYNONYM syn_trabajador FOR trabajador;
CREATE OR REPLACE SYNONYM syn_bono_antiguedad FOR bono_antiguedad;
CREATE OR REPLACE SYNONYM syn_tickets_concierto FOR tickets_concierto;

CREATE OR REPLACE SYNONYM syn_bono_escolar FOR bono_escolar;
CREATE OR REPLACE SYNONYM syn_asignacion_familiar FOR asignacion_familiar;

INSERT INTO detalle_bonificaciones_trabajador (
    num,
    rut,
    nombre_trabajador,
    sueldo_base,
    num_ticket,
    direccion,
    sistema_salud,
    monto,
    bonif_x_ticket,
    simulacion_x_ticket,
    simulacion_antiguedad
)
SELECT
    seq_det_bonif.NEXTVAL,
    TO_CHAR(t.numrut) || '-' || t.dvrut,
    t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno,
    TO_CHAR(t.sueldo_base),
    NVL(TO_CHAR(tk.cantidad_tickets), 'No hay info'),
    t.direccion,
    i.nombre_isapre,
    NVL(TO_CHAR(tk.total_monto), 'No hay info'),
    CASE
        WHEN tk.total_monto IS NULL THEN 'No hay info'
        WHEN tk.total_monto <= 50000 THEN '0'
        WHEN tk.total_monto > 50000 AND tk.total_monto <= 100000 THEN TO_CHAR(ROUND(tk.total_monto * 0.05))
        WHEN tk.total_monto > 100000 THEN TO_CHAR(ROUND(tk.total_monto * 0.07))
    END,
    TO_CHAR(
        t.sueldo_base
        + NVL(
            CASE
                WHEN tk.total_monto IS NULL THEN 0
                WHEN tk.total_monto <= 50000 THEN 0
                WHEN tk.total_monto > 50000 AND tk.total_monto <= 100000 THEN ROUND(tk.total_monto * 0.05)
                WHEN tk.total_monto > 100000 THEN ROUND(tk.total_monto * 0.07)
            END,
            0
        )
    ),
    TO_CHAR(
        t.sueldo_base
        + NVL(ROUND(t.sueldo_base * ba.porcentaje), 0)
    )
FROM syn_trabajador t
JOIN isapre i
    ON i.cod_isapre = t.cod_isapre
LEFT JOIN (
    SELECT
        numrut_t,
        COUNT(*) cantidad_tickets,
        SUM(monto_ticket) total_monto
    FROM syn_tickets_concierto
    GROUP BY numrut_t
) tk
    ON tk.numrut_t = t.numrut
LEFT JOIN syn_bono_antiguedad ba
    ON FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE), t.fecing) / 12)
       BETWEEN ba.limite_inferior AND ba.limite_superior
WHERE
    i.porc_descto_isapre > 4
    AND t.fecnac IS NOT NULL
    AND FLOOR(MONTHS_BETWEEN(TRUNC(SYSDATE), t.fecnac) / 12) < 50
ORDER BY
    tk.total_monto DESC NULLS LAST,
    t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno ASC;

CREATE OR REPLACE VIEW v_aumentos_estudios
AS
SELECT
    TO_CHAR(t.numrut) || '-' || t.dvrut        AS rut,
    t.nombre || ' ' || t.appaterno || ' ' || t.apmaterno AS nombre_trabajador,
    be.descrip                                 AS nivel_educacion,
    be.porc_bono                               AS porcentaje_bono_estudio,
    t.sueldo_base                              AS sueldo_actual,
    ROUND(t.sueldo_base * (be.porc_bono / 100)) AS aumento_estudios,
    t.sueldo_base + ROUND(t.sueldo_base * (be.porc_bono / 100)) AS sueldo_simulado
FROM syn_trabajador t
JOIN syn_bono_escolar be
    ON be.id_escolar = t.id_escolaridad_t
WHERE
      (SELECT COUNT(*)
       FROM syn_asignacion_familiar af
       WHERE af.numrut_t = t.numrut) BETWEEN 1 AND 2
   OR t.id_categoria_t = (
        SELECT id_categoria
        FROM tipo_trabajador
        WHERE UPPER(desc_categoria) = 'CAJERO'
   )
WITH READ ONLY;

CREATE INDEX idx_trabajador_apmaterno
ON trabajador(apmaterno);

CREATE INDEX idx_trabajador_upper_apmaterno
ON trabajador(UPPER(apmaterno));
