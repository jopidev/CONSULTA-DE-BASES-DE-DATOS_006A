# PRY2205 - Experiencia 1 Semana 2  
## Creando consultas utilizando funciones SQL

### 🧩 Contexto
La empresa **ShiverSale**, dedicada a la venta de calzado, busca optimizar su base de datos para generar reportes útiles que apoyen su gestión comercial y financiera.  
En esta actividad se aplican funciones SQL de una fila, conversión de tipos de datos, manejo de valores nulos y expresiones condicionales, para resolver requerimientos de tres módulos distintos.

---

## ⚙️ Configuración inicial
1. Conectarse a Oracle SQL Developer como usuario `SYS` o `SYSTEM`.
2. Ejecutar el script `script_crea_usuario_PRY2205_S2.sql`.
3. Crear la conexión `PRY2205_ACTIVIDAD_S2`.
4. Ejecutar el script `PRY2205_Exp1_S2_CreaEsquemaPoblado.sql` para crear y poblar las tablas necesarias.

---

## 🧾 Casos desarrollados

### **Caso 1: Análisis de Facturas**
**Objetivo:** clasificar facturas por monto y forma de pago, mostrando los datos del año anterior.  
**Características principales:**
- Clasificación de ventas:  
  - 0–50000 → **Bajo**  
  - 50001–100000 → **Medio**  
  - >100000 → **Alto**
- Clasificación por forma de pago (`CASE` + `DECODE`).
- Formato de RUT a 10 caracteres (`LPAD`).
- Fechas formateadas con `TO_CHAR` y año calculado dinámicamente.
- Orden descendente por fecha y monto neto.

---

### **Caso 2: Clasificación de Clientes**
**Objetivo:** validar datos de clientes, identificar su categoría de crédito y tratar valores nulos.  
**Características principales:**
- RUT invertido y completado con `*` (`REVERSE`, `RPAD`, `LPAD`).
- Manejo de nulos (`NVL`) en teléfono, comuna y correo.
- Extracción de dominio de correo (`SUBSTR`, `INSTR`).
- Clasificación del crédito según relación `saldo / crédito`:  
  - <50% → **Bueno**  
  - 50–80% → **Regular**  
  - >80% → **Crítico**
- Orden ascendente por nombre de cliente.

---

### **Caso 3: Stock de Productos**
**Objetivo:** generar alertas de stock y cálculos de conversión de precios.  
**Características principales:**
- Conversión del valor de compra en dólares a CLP (`TO_CHAR`, `ROUND`, `NVL`).
- Variables de sustitución:
  - `:TIPOCAMBIO_DOLAR`
  - `:UMBRAL_BAJO`
  - `:UMBRAL_ALTO`
- Alertas:
  - `NULL` → “Sin datos”  
  - `< UMBRAL_BAJO` → “¡ALERTA stock muy bajo!”  
  - `BETWEEN` → “¡Reabastecer pronto!”  
  - `> UMBRAL_ALTO` → “OK”
- Descuento del 10% para productos con stock > 80.
- Filtro de productos cuya descripción contenga “zapato” y procedencia = `i`.
- Orden descendente por ID de producto.

---

## 🧠 Funciones SQL aplicadas
- **De caracteres:** `UPPER`, `LOWER`, `SUBSTR`, `CONCAT`, `LENGTH`, `LPAD`, `RPAD`, `REPLACE`, `INSTR`.
- **Numéricas:** `ROUND`, `TRUNC`, `MOD`.
- **De fecha:** `SYSDATE`, `ADD_MONTHS`, `TO_DATE`, `TO_CHAR`, `EXTRACT`.
- **De conversión:** `TO_CHAR`, `TO_NUMBER`, `TO_DATE`.
- **De nulos:** `NVL`, `NVL2`, `COALESCE`, `NULLIF`.
- **Condicionales:** `CASE`, `DECODE`.

---

## 💾 Entrega
- Archivo: `PRY2205_S2_JorgePinto.sql`
- Subir al **repositorio GitHub**.
- Enviar el enlace del repositorio y el archivo `.sql` al **AVA**.

---

## ✍️ Autor
**Jorge Pinto**  
Estudiante de Ingeniería Informática – mención Ciencia de Datos  
Duoc UC, 2025
