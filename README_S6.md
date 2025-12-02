# Evaluación Sumativa Semana 6 – Consulta de Bases de Datos  
## “Insertando, eliminando y manipulando datos”

Repositorio correspondiente al desarrollo de la **Actividad Sumativa – Semana 6** de la asignatura **Consulta de Bases de Datos (PRY2205)** de DUOC UC.

El presente trabajo da cumplimiento íntegro a los requerimientos indicados en:

- Guía de aprendizaje Semana 6  
- Instrucciones específicas de la actividad  
- Pauta de evaluación sumativa  

La solución implementa consultas **SQL completas** utilizando:

- **JOIN**
- **Subconsultas**
- **Operadores SET**
- Funciones de una fila
- Funciones de grupo
- Restricciones de datos
- Cláusulas de ordenamiento
- Sentencias **DML**
- Sentencias **DDL**
- Reportes solicitados

Todo el código ha sido desarrollado y ejecutado mediante **Oracle SQL Developer**.

---

## 📁 Rama de desarrollo

Todo el trabajo se encuentra desarrollado en la rama:

```
s6
```

---

## 📄 Archivos contenidos

### 🔹 Script de creación y carga de datos
```
PRY2205_Exp2_S6_CreaEsquemaPoblado.sql
```

---

### 🔹 Script de resolución
```
Evaluacion_S6_Resolucion.sql
```

Incluye la solución completa de los tres casos con:
JOIN, Subconsultas, Operadores SET, Funciones SQL, DML, DDL, ORDER BY, GROUP BY y manejo de fechas paramétricas.

---

## ✅ Casos desarrollados

### Caso 1 – Reportería de Asesorías
Identificación de profesionales con asesorías en sectores **Banca (3)** y **Retail (4)** mediante **SET + Subconsultas**, mostrando totales por sector y generales.

### Caso 2 – Resumen de Honorarios
Generación del reporte de **abril del año anterior** usando:
- Creación de tabla `REPORTE_MES`
- Inserción por `INSERT INTO ... SELECT`
- Agregaciones: SUM, AVG, MIN, MAX, COUNT
- JOIN de tablas Profesión, Comuna y Asesorías.
- Redondeo de valores.

### Caso 3 – Modificación de Honorarios
Proceso de incremento automático de sueldos:

- < $1.000.000 → +10%
- ≥ $1.000.000 → +15%

Incluye:
- Reporte previo
- UPDATE con CASE
- Reporte posterior de validación.

---

## 📊 Cumplimiento de la pauta

| Criterio | Nivel |
|---|---|
| Soluciones SQL | ✅ 100% |
| JOIN | ✅ 100% |
| Subconsultas | ✅ 100% |
| Operadores SET | ✅ 100% |
| DML | ✅ 100% |
| Organización del código | ✅ 100% |

---

## 🛠️ Herramientas

- Oracle SQL Developer  
- Oracle Database  
- GitHub  

---

## 👤 Autor

**Jorge Pinto**  
Ingeniería Informática – Mención Ciencia de Datos  
DUOC UC
