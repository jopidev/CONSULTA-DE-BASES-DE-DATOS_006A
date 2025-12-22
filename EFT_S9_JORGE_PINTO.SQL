
/* 0.1 Creación de ROLES */

CREATE ROLE PRY2205_ROL_D;
CREATE ROLE PRY2205_ROL_C;


/* 0.2 Creación de USUARIOS
   Ajustar DEFAULT TABLESPACE según entorno:
   - Oracle XE      : USERS
   - Oracle Cloud   : DATA
*/

-- Usuario OWNER: PRY2205_EFT
CREATE USER PRY2205_EFT
    IDENTIFIED BY "Seg#2024DbUsrA"      -- >=12, 1 min, 2 mayus, 2 digitos, sin "EFT"
    DEFAULT TABLESPACE USERS            -- cambiar a DATA si usas Oracle Cloud
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS;                 -- o 10M ON DATA

-- Usuario DESARROLLADOR: PRY2205_EFT_DES
CREATE USER PRY2205_EFT_DES
    IDENTIFIED BY "Seg#2024DbUsrB"      -- misma regla, sin "DES"
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS;

-- Usuario CONSUMIDOR DE INFORMES: PRY2205_EFT_CON
CREATE USER PRY2205_EFT_CON
    IDENTIFIED BY "Seg#2024DbUsrC"      -- misma regla, sin "CON"
    DEFAULT TABLESPACE USERS
    TEMPORARY TABLESPACE TEMP
    QUOTA 10M ON USERS;


/* 0.3 Privilegios básicos de conexión */

GRANT CREATE SESSION TO PRY2205_EFT;
GRANT CREATE SESSION TO PRY2205_EFT_DES;
GRANT CREATE SESSION TO PRY2205_EFT_CON;


/* 0.4 Privilegios del OWNER (Tabla 2 - Caso 1)
   - Crear tablas, índices, vistas, secuencias
   - Crear sinónimos públicos y privados
*/

GRANT CREATE TABLE,
      CREATE INDEX,
      CREATE VIEW,
      CREATE SEQUENCE,
      CREATE SYNONYM,
      CREATE PUBLIC SYNONYM
TO PRY2205_EFT;


/* 0.5 Privilegios del DESARROLLADOR
   - Crear vistas, perfiles, usuarios
*/

GRANT CREATE VIEW,
      CREATE PROFILE,
      CREATE USER
TO PRY2205_EFT_DES;

/* 0.6 PRY2205_EFT_CON
   - Solo tendrá SELECT sobre objetos autorizados
*/


/* 0.7 Asignación de ROLES a usuarios */

GRANT PRY2205_ROL_D TO PRY2205_EFT_DES;
GRANT PRY2205_ROL_C TO PRY2205_EFT_CON;



/* =========================================================
   BLOQUE 1: USUARIO PRY2205_EFT (OWNER)
   CASO 1: Estrategia de seguridad
   CASO 3.1: Vista VW_EMPRESAS_ASESORADAS
   CASO 3.2: Índices de optimización
   ========================================================= */

-- Conectarse como: PRY2205_EFT
SHOW USER;
-- Esperado en el video: USER is "PRY2205_EFT"


/* 1.1 SINÓNIMOS PRIVADOS (uso interno del OWNER)
   Ajustar nombres de tablas según modelo real.
   Ejemplos:
   EMPRESA, PROFESIONAL, CONTRATO, ISAPRE,
   TIPO_CONTRATO, ASESORIA, HONORARIO_TRAMO, etc.
*/

CREATE SYNONYM EMPRESA_SIN          FOR PRY2205_EFT.EMPRESA;
CREATE SYNONYM PROFESIONAL_SIN      FOR PRY2205_EFT.PROFESIONAL;
CREATE SYNONYM CONTRATO_SIN         FOR PRY2205_EFT.CONTRATO;
CREATE SYNONYM ISAPRE_SIN           FOR PRY2205_EFT.ISAPRE;
CREATE SYNONYM TIPO_CONTRATO_SIN    FOR PRY2205_EFT.TIPO_CONTRATO;
CREATE SYNONYM ASESORIA_SIN         FOR PRY2205_EFT.ASESORIA;
CREATE SYNONYM HONORARIO_TRAMO_SIN  FOR PRY2205_EFT.HONORARIO_TRAMO;


/* 1.2 SINÓNIMOS PÚBLICOS (para DES y CON)
   Permite que PRY2205_EFT_DES y PRY2205_EFT_CON accedan
   sin usar el esquema explícito.
*/

CREATE PUBLIC SYNONYM EMPRESA          FOR PRY2205_EFT.EMPRESA;
CREATE PUBLIC SYNONYM PROFESIONAL      FOR PRY2205_EFT.PROFESIONAL;
CREATE PUBLIC SYNONYM CONTRATO         FOR PRY2205_EFT.CONTRATO;
CREATE PUBLIC SYNONYM ISAPRE           FOR PRY2205_EFT.ISAPRE;
CREATE PUBLIC SYNONYM TIPO_CONTRATO    FOR PRY2205_EFT.TIPO_CONTRATO;
CREATE PUBLIC SYNONYM ASESORIA         FOR PRY2205_EFT.ASESORIA;
CREATE PUBLIC SYNONYM HONORARIO_TRAMO  FOR PRY2205_EFT.HONORARIO_TRAMO;


/* 1.3 PRIVILEGIOS A ROLES (Principio del menor privilegio)
   - PRY2205_ROL_D: acceso para análisis y construcción de informes
   - PRY2205_ROL_C: acceso solo para consumo
*/

-- Rol de DESARROLLO
GRANT SELECT ON PRY2205_EFT.EMPRESA          TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_EFT.PROFESIONAL      TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_EFT.CONTRATO         TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_EFT.ISAPRE           TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_EFT.TIPO_CONTRATO    TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_EFT.ASESORIA         TO PRY2205_ROL_D;
GRANT SELECT ON PRY2205_EFT.HONORARIO_TRAMO  TO PRY2205_ROL_D;

-- Rol de CONSUMO
GRANT SELECT ON PRY2205_EFT.EMPRESA          TO PRY2205_ROL_C;
GRANT SELECT ON PRY2205_EFT.PROFESIONAL      TO PRY2205_ROL_C;
GRANT SELECT ON PRY2205_EFT.CONTRATO         TO PRY2205_ROL_C;
GRANT SELECT ON PRY2205_EFT.ISAPRE           TO PRY2205_ROL_C;
GRANT SELECT ON PRY2205_EFT.TIPO_CONTRATO    TO PRY2205_ROL_C;
GRANT SELECT ON PRY2205_EFT.ASESORIA         TO PRY2205_ROL_C;
GRANT SELECT ON PRY2205_EFT.HONORARIO_TRAMO  TO PRY2205_ROL_C;



/* =========================================================
   CASO 3.1: Creación de vista VW_EMPRESAS_ASESORADAS
   Usuario: PRY2205_EFT
   =========================================================
   Suposiciones de columnas (ajusta a tu modelo real):
   - EMPRESA(RUT_EMPRESA, NOMBRE_EMPRESA,
             FECHA_INICIO_ACTIVIDADES, IVA_DECLARADO)
   - ASESORIA(ID_ASESORIA, RUT_EMPRESA,
              FECHA_TERMINO, ESTADO)
   ========================================================= */

CREATE OR REPLACE VIEW VW_EMPRESAS_ASESORADAS AS
SELECT
    e.RUT_EMPRESA                                       AS RUT_EMPRESA,
    e.NOMBRE_EMPRESA                                    AS NOMBRE_EMPRESA,
    TRUNC(
        MONTHS_BETWEEN(TRUNC(SYSDATE),
                       e.FECHA_INICIO_ACTIVIDADES) / 12
    )                                                   AS ANIOS_ANTIGUEDAD,
    e.IVA_DECLARADO                                     AS IVA_DECLARADO,
    ROUND(COUNT(a.ID_ASESORIA) / 12, 2)                 AS PROMEDIO_ASESORIAS_ANUAL,
    ROUND(
        e.IVA_DECLARADO
        * (ROUND(COUNT(a.ID_ASESORIA) / 12, 2)) / 100
    )                                                   AS DEVOLUCION_IVA_ESTIMADA,
    CASE
        WHEN ROUND(COUNT(a.ID_ASESORIA) / 12, 2) > 5
            THEN 'CLIENTE PREMIUM'
        WHEN ROUND(COUNT(a.ID_ASESORIA) / 12, 2)
             BETWEEN 3 AND 5
            THEN 'CLIENTE'
        ELSE 'CLIENTE POCO CONCURRIDO'
    END                                                 AS TIPO_CLIENTE,
    CASE
        WHEN ROUND(COUNT(a.ID_ASESORIA) / 12, 2) > 5
             AND COUNT(a.ID_ASESORIA) >= 7
             THEN '1 ASESORÍA GRATIS'
        WHEN ROUND(COUNT(a.ID_ASESORIA) / 12, 2) > 5
             AND COUNT(a.ID_ASESORIA) < 7
             THEN '1 ASESORÍA 40% DE DESCUENTO'
        WHEN ROUND(COUNT(a.ID_ASESORIA) / 12, 2) = 5
             THEN '1 ASESORÍA 30% DE DESCUENTO'
        WHEN ROUND(COUNT(a.ID_ASESORIA) / 12, 2)
             BETWEEN 3 AND 5
             AND COUNT(a.ID_ASESORIA) < 5
             THEN '1 ASESORÍA 20% DE DESCUENTO'
        ELSE 'CAPTAR CLIENTE'
    END                                                 AS PROMOCION
FROM
    EMPRESA e
    JOIN ASESORIA a
        ON a.RUT_EMPRESA = e.RUT_EMPRESA
WHERE
    EXTRACT(YEAR FROM a.FECHA_TERMINO)
        = EXTRACT(YEAR FROM SYSDATE) - 1
    AND a.ESTADO = 'TERMINADA'
GROUP BY
    e.RUT_EMPRESA,
    e.NOMBRE_EMPRESA,
    e.FECHA_INICIO_ACTIVIDADES,
    e.IVA_DECLARADO;


-- Dar acceso al usuario de consumo a la vista
GRANT SELECT ON VW_EMPRESAS_ASESORADAS TO PRY2205_EFT_CON;



/* =========================================================
   CASO 3.2: Creación de ÍNDICES para mejorar rendimiento
   Usuario: PRY2205_EFT
   =========================================================
   En el VIDEO:
   - Mostrar plan de ejecución ANTES del índice
   - Crear índice(s)
   - Mostrar plan de ejecución DESPUÉS del índice
   ========================================================= */

-- Índice sobre ASESORIA para filtrar por empresa, fecha de término y estado
CREATE INDEX IDX_ASESORIA_EMPRESA_FECHATER
    ON ASESORIA (RUT_EMPRESA, FECHA_TERMINO, ESTADO);

-- Índice sobre EMPRESA por RUT
CREATE INDEX IDX_EMPRESA_RUT
    ON EMPRESA (RUT_EMPRESA);



/* =========================================================
   BLOQUE 2: USUARIO PRY2205_EFT_DES (DESARROLLADOR)
   CASO 2: Creación de informe CARTOLA_PROFESIONALES
   ========================================================= */

-- Conectarse como: PRY2205_EFT_DES
SHOW USER;
-- En el video: USER is "PRY2205_EFT_DES"


/* 2.1 Creación de tabla CARTOLA_PROFESIONALES
   Ajustar tamaños de columnas según requisitos de formato.
*/

CREATE TABLE CARTOLA_PROFESIONALES (
    RUT_PROFESIONAL      VARCHAR2(20),
    NOMBRE_COMPLETO      VARCHAR2(200),
    PROFESION            VARCHAR2(100),
    SUELDO_BASE          NUMBER(12,0),
    NOMBRE_ISAPRE        VARCHAR2(100),
    VALOR_COMISION       NUMBER(12,0),
    PORC_HONORARIOS      NUMBER(5,2),
    MONTO_HONORARIOS     NUMBER(12,0),
    BONO_MOVILIZACION    NUMBER(12,0),
    TOTAL_A_PAGAR        NUMBER(12,0)
);


/* 2.2 Población de CARTOLA_PROFESIONALES
   Uso de:
   - Funciones de una fila (NVL, ROUND, concatenación, CASE)
   - Joins
   - Ordenamiento por:
     PROFESION, SUELDO_BASE DESC, PORCENTAJE_COMISION, RUT
   Suposiciones:
   - PROFESIONAL(RUT, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO,
                 PROFESION, ID_ISAPRE, ID_PROFESIONAL)
   - ISAPRE(ID_ISAPRE, NOMBRE_ISAPRE)
   - CONTRATO(ID_CONTRATO, ID_PROFESIONAL,
              ID_TIPO_CONTRATO, SUELDO_BASE, PORC_COMISION)
   - TIPO_CONTRATO(ID_TIPO_CONTRATO, NOMBRE_TIPO_CONTRATO)
   - HONORARIO_TRAMO(SUELDO_MIN, SUELDO_MAX, PORCENTAJE)
*/

INSERT INTO CARTOLA_PROFESIONALES (
    RUT_PROFESIONAL,
    NOMBRE_COMPLETO,
    PROFESION,
    SUELDO_BASE,
    NOMBRE_ISAPRE,
    VALOR_COMISION,
    PORC_HONORARIOS,
    MONTO_HONORARIOS,
    BONO_MOVILIZACION,
    TOTAL_A_PAGAR
)
SELECT
    p.RUT                                                    AS RUT_PROFESIONAL,
    p.NOMBRE || ' ' || p.APELLIDO_PATERNO || ' ' ||
    p.APELLIDO_MATERNO                                      AS NOMBRE_COMPLETO,
    p.PROFESION                                              AS PROFESION,
    c.SUELDO_BASE                                            AS SUELDO_BASE,
    i.NOMBRE_ISAPRE                                          AS NOMBRE_ISAPRE,
    NVL(ROUND(c.SUELDO_BASE * NVL(c.PORC_COMISION, 0) / 100),
        0)                                                   AS VALOR_COMISION,
    NVL(ht.PORCENTAJE, 0)                                    AS PORC_HONORARIOS,
    ROUND(c.SUELDO_BASE * NVL(ht.PORCENTAJE, 0) / 100)       AS MONTO_HONORARIOS,
    CASE
        WHEN tc.NOMBRE_TIPO_CONTRATO = 'INDEFINIDO JORNADA COMPLETA' THEN 150000
        WHEN tc.NOMBRE_TIPO_CONTRATO = 'INDEFINIDO JORNADA PARCIAL'  THEN 120000
        WHEN tc.NOMBRE_TIPO_CONTRATO = 'PLAZO FIJO'                  THEN  60000
        WHEN tc.NOMBRE_TIPO_CONTRATO = 'HONORARIOS'                  THEN  50000
        ELSE 0
    END                                                      AS BONO_MOVILIZACION,
    c.SUELDO_BASE
    + NVL(ROUND(c.SUELDO_BASE * NVL(c.PORC_COMISION, 0) / 100), 0)
    + ROUND(c.SUELDO_BASE * NVL(ht.PORCENTAJE, 0) / 100)
    + CASE
          WHEN tc.NOMBRE_TIPO_CONTRATO = 'INDEFINIDO JORNADA COMPLETA' THEN 150000
          WHEN tc.NOMBRE_TIPO_CONTRATO = 'INDEFINIDO JORNADA PARCIAL'  THEN 120000
          WHEN tc.NOMBRE_TIPO_CONTRATO = 'PLAZO FIJO'                  THEN  60000
          WHEN tc.NOMBRE_TIPO_CONTRATO = 'HONORARIOS'                  THEN  50000
          ELSE 0
      END                                                  AS TOTAL_A_PAGAR
FROM
    PROFESIONAL p
    JOIN CONTRATO c
        ON c.ID_PROFESIONAL = p.ID_PROFESIONAL
    JOIN ISAPRE i
        ON i.ID_ISAPRE = p.ID_ISAPRE
    JOIN TIPO_CONTRATO tc
        ON tc.ID_TIPO_CONTRATO = c.ID_TIPO_CONTRATO
    LEFT JOIN HONORARIO_TRAMO ht
        ON c.SUELDO_BASE BETWEEN ht.SUELDO_MIN AND ht.SUELDO_MAX
ORDER BY
    p.PROFESION,
    c.SUELDO_BASE DESC,
    NVL(c.PORC_COMISION, 0),
    p.RUT;


-- Dar permiso al usuario de consumo para ver la CARTOLA
GRANT SELECT ON CARTOLA_PROFESIONALES TO PRY2205_EFT_CON;



/* =========================================================
   BLOQUE 3: USUARIO PRY2205_EFT_CON (CONSUMIDOR)
   Validación de accesos (CASO 2 y CASO 3)
   ========================================================= */

-- Conectarse como: PRY2205_EFT_CON
SHOW USER;
-- En el video: USER is "PRY2205_EFT_CON"

-- CASO 2: Validar acceso a la tabla de informe de remuneraciones
SELECT *
FROM CARTOLA_PROFESIONALES
ORDER BY
    PROFESION,
    SUELDO_BASE DESC,
    VALOR_COMISION,
    RUT_PROFESIONAL;

-- CASO 3.1: Validar acceso a la vista, ordenando por nombre de empresa
SELECT *
FROM VW_EMPRESAS_ASESORADAS
ORDER BY NOMBRE_EMPRESA;