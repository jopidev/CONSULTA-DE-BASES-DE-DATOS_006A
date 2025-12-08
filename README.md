# PRY2205 – Experiencia 3 – Semana 7  
## Optimización de Consultas SQL

Actividad formativa correspondiente a la Experiencia 3 – Semana 7 de la asignatura **Consulta de Bases de Datos**.

El objetivo del trabajo es aplicar técnicas de optimización en Oracle SQL mediante el uso de:

- Vistas simples y complejas.
- Subconsultas.
- Sinónimos privados.
- Secuencias.
- Índices B-Tree y Function-Based.
- Análisis básico de planes de ejecución.

---

## Contenido del script

Archivo principal:

- `PRY2205_Exp3_S7_Actividad.sql`

El script incluye:

### Caso 1 – Bonificación de trabajadores

- Creación de sinónimos privados para:
  - `TRABAJADOR`
  - `BONO_ANTIGUEDAD`
  - `TICKETS_CONCIERTO`
- Consulta con joins, funciones y subconsulta para:
  - Simulación de bonificación por tickets.
  - Cálculo de antigüedad usando `MONTHS_BETWEEN` y NonEquiJoin.
  - Filtros por plan de salud y edad.
- Inserción de resultados en la tabla:
  - `DETALLE_BONIFICACIONES_TRABAJADOR`
- Uso de la secuencia:
  - `SEQ_DET_BONIF`

---

### Caso 2 – Vista de aumentos por estudios

- Creación de sinónimos privados:
  - `BONO_ESCOLAR`
  - `ASIGNACION_FAMILIAR`
- Creación de la vista de solo lectura:
  - `V_AUMENTOS_ESTUDIOS`
- Uso de:
  - Subconsulta para conteo de cargas familiares.
  - Filtro de trabajadores tipo **CAJERO**.
  - Cálculos de aumento salarial por nivel de estudios.

---

### Caso 2 – Optimización de consultas

- Creación de índices para mejorar búsquedas por apellido materno:

```sql
CREATE INDEX idx_trabajador_apmaterno ON trabajador(apmaterno);
CREATE INDEX idx_trabajador_upper_apmaterno ON trabajador(UPPER(apmaterno));
```

Estos índices permiten evitar Full Table Scan al ejecutar consultas con filtros directos y mediante función `UPPER()`.

---

## Requisitos de ejecución

1. Ejecutar previamente los scripts base:
   - `PRY2205_Exp3_S7_script_crea_usuario.sql`
   - `PRY2205_Exp3_S7_CreaEsquemaPoblado.sql`

2. Conectarse como usuario:

   `PRY2205_S7`

3. Ejecutar el archivo:

   `PRY2205_Exp3_S7_Actividad.sql`

---

## Consultas de verificación

Consulta a la vista:

```sql
SELECT *
FROM v_aumentos_estudios
ORDER BY porcentaje_bono_estudio, nombre_trabajador;
```

Revisión de planes de ejecución:

```sql
EXPLAIN PLAN FOR
SELECT t.numrut, t.nombre
FROM trabajador t
WHERE t.apmaterno = 'CASTILLO';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

---

## Autor

Jorge Pinto  
Estudiante Ingeniería en Informática – mención Ciencia de Datos  
DUOC UC
