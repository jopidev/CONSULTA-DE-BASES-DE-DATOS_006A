# PRY2205 – Experiencia 3 | Semana 8  
## Aplicando control de acceso a Bases de Datos

Este repositorio contiene la solución correspondiente a la **Actividad Sumativa – Semana 8** de la asignatura **Consulta de Bases de Datos (PRY2205)**, cuyo objetivo es implementar una solución integral de base de datos considerando **seguridad, control de accesos, generación de informes y optimización de consultas SQL**.

---

## 📌 Objetivo de la actividad

Implementar una estrategia completa de administración de bases de datos que incluya:

- Creación y administración de **usuarios, roles y privilegios**
- Uso de **sinónimos públicos y privados**
- Construcción de **informes SQL** mediante consultas avanzadas
- Creación de **vistas de lectura**
- **Optimización de consultas** mediante análisis de planes de ejecución e índices
- Organización del código en un **script SQL único y ordenado por usuario**

---

## 🗂️ Estructura de la entrega

La solución se entrega en un único archivo SQL:

```
PRY2205_S8_Entrega_FINAL_100.sql
```

El script se encuentra organizado por bloques, según el usuario que ejecuta cada conjunto de sentencias:

1. **SYS / SYSTEM (o ADMIN)**  
   - Eliminación segura de usuarios y roles  
   - Creación de usuarios  
   - Creación de roles  
   - Asignación de privilegios y roles  

2. **PRY2205_USER1**  
   - Ejecución del script de creación y poblado del modelo relacional  
   - Creación de sinónimos públicos y privados  
   - Creación de la vista `VW_DETALLE_MULTAS`  
   - Análisis del plan de ejecución  
   - Creación de índices  

3. **PRY2205_USER2**  
   - Creación de la secuencia `SEQ_CONTROL_STOCK`  
   - Creación de la tabla `CONTROL_STOCK_LIBROS`  

---

## 🔐 Caso 1 – Estrategia de seguridad

- Implementación de roles específicos por perfil.
- Asignación de privilegios siguiendo el principio de **menor privilegio**.
- Uso de sinónimos para evitar el acceso directo a los nombres reales de las tablas.

---

## 📊 Caso 2 – Informe Control Stock Bibliográfico

El informe permite analizar el flujo de préstamos de libros, considerando:

- Total de ejemplares
- Ejemplares en préstamo
- Ejemplares disponibles
- Porcentaje de ejemplares en préstamo
- Indicador de stock crítico

El informe se genera mediante una consulta SQL avanzada que incluye joins, subconsultas, funciones de grupo y filtros temporales paramétricos.

---

## ⚙️ Caso 3 – Optimización de sentencias SQL

### Vista `VW_DETALLE_MULTAS`

La vista permite visualizar los préstamos con entrega atrasada, calculando automáticamente:

- Días de atraso
- Multa base (3% del valor del libro por día)
- Rebajas según carrera
- Multa final

### Índices

Se analizan planes de ejecución antes y después de la creación de índices, con el objetivo de mejorar el rendimiento de las consultas asociadas a la vista.

---

## 🛠️ Herramientas utilizadas

- Oracle SQL Developer  
- Oracle Database (XE / Cloud)  
- Git y GitHub  

---

## 📎 Consideraciones finales

- El script es re-ejecutable.
- El código se encuentra organizado y es legible.
- La solución cumple con todos los criterios de la pauta de evaluación.

---

**Autor**  
Jorge Pinto  
Ingeniería Informática – mención Ciencia de Datos  
DUOC UC
