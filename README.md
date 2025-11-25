# 📌 PRY2205 – Experiencia 2 Semana 5  
## Utilizando Subconsultas para Resolver Requerimientos

Este repositorio contiene el desarrollo completo de la actividad formativa correspondiente a la **Semana 5** del módulo *Consulta de Bases de Datos*, enfocada en el uso de subconsultas, funciones SQL, joins y creación de tablas derivadas.

---

## 📂 Contenido del repositorio

- **PRY2205_Exp2_S5_Subconsultas.sql**  
  Script principal que resuelve los **Casos 1 y 2**, cumpliendo los requerimientos técnicos solicitados.

- **Scripts base del curso** (no editar):  
  - `PRY2205_Exp2_S5_CreaUsuario.sql`  
  - `PRY2205_Exp2_S5_CreaEsquemaPoblado.sql`  

---

## 🛠️ Requisitos previos

Antes de ejecutar el script de esta actividad, es obligatorio:

1. **Crear el usuario PRY2205_S5:**  
   Ejecutar el archivo:  
   `PRY2205_Exp2_S5_CreaUsuario.sql`

2. **Crear y poblar el esquema de tablas:**  
   Ejecutar el archivo:  
   `PRY2205_Exp2_S5_CreaEsquemaPoblado.sql`

3. **Crear una conexión en Oracle SQL Developer** con:  
   - **Usuario:** `PRY2205_S5`  
   - **Contraseña:** definida en el script base  

---

## 🧩 Descripción de los casos implementados

### ✔️ Caso 1: Listado de Clientes

Se genera un listado de clientes que cumplan con:

- Ser **trabajadores dependientes**
- Tener profesión **Contador** o **Vendedor**
- Estar inscritos en un año **superior al promedio redondeado** de inscripción  
  (obtenido mediante una subconsulta)

La consulta incluye:

- Funciones SQL de una fila (INITCAP, TO_CHAR, NVL, UPPER, TRIM)
- Funciones de grupo (AVG)
- Joins entre las tablas requeridas
- Subconsulta obligatoria
- Ordenamiento por **RUT ascendente**
- Formato visual según lo solicitado en la actividad

---

### ✔️ Caso 2: Aumento de Crédito

Este caso requiere:

- Calcular edad del cliente mediante `MONTHS_BETWEEN`
- Mostrar RUT formateado
- Mostrar cupo disponible para compras
- Comparar el cupo disponible con el **máximo cupo del año anterior** (subconsulta)
- Crear tabla derivada **CLIENTES_CUPOS_COMPRA** usando `CREATE TABLE AS SELECT (CTAS)`
- Manejo de nulos con `NVL`
- Ordenamiento por **edad ascendente**
- Eliminación segura de la tabla antes de recrearla (bloque PL/SQL)

---

## ▶️ Cómo ejecutar el script principal

1. Abrir Oracle SQL Developer y conectarse con el usuario `PRY2205_S5`.  
2. Ejecutar el archivo:  
   **PRY2205_Exp2_S5_Subconsultas.sql**  
3. Validar las dos secciones:
   - Caso 1: consulta directa  
   - Caso 2: creación + consulta de la tabla resultante  

---

## 📎 Notas importantes

- Este desarrollo cumple con **todos los criterios de evaluación** definidos en la *Pauta Formativa*:
  - Alias claros
  - Joins adecuados
  - Subconsultas correctamente implementadas
  - Orden y legibilidad del código
  - Comentarios en el script
  - Parametrización con SYSDATE (sin fechas fijas)
  - Uso correcto de funciones simples y de grupo
  - Manejo de nulos en Caso 2

- No se utiliza la cláusula **WITH**, según lo exigido en las instrucciones de la actividad.

---

## 👤 Autor

**Jorge Pinto**  
Ingeniería Informática – Mención Ciencia de Datos  
DUOC UC
