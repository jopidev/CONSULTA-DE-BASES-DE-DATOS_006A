# Semana 4 – JOINS en SQL  
**Asignatura:** Consulta de Bases de Datos  
**Experiencia 2**  

Este folder contiene el desarrollo de los tres casos solicitados para la Semana 4, utilizando el esquema de Conciertos Chile S.A. El trabajo se realizó sobre Oracle SQL Developer con el usuario **PRY2205_S4** y las tablas creadas desde los scripts oficiales entregados por la institución.

---

## Contenido del archivo

### `PRY2205_Exp2_S4_Solucion_Jorge.sql`
Script que incluye las consultas para:

### ✔ Caso 1: Listado de trabajadores  
- Filtrado por rango de sueldo base.  
- Uso de funciones de caracteres, nulos y concatenación.  
- JOIN entre las tablas de trabajador, comuna, categoría, escolaridad, AFP e ISAPRE.  
- Orden según las reglas solicitadas.  

### ✔ Caso 2: Listado de cajeros  
- Conteo de tickets vendidos.  
- Suma total de montos y comisiones.  
- Funciones de grupo, agrupaciones y restricción con HAVING.  
- JOIN con las tablas de tickets y comisiones.  

### ✔ Caso 3: Listado de bonificaciones  
- Cálculo de años trabajados.  
- Bonos por antigüedad y bono adicional por FONASA.  
- Conteo de cargas familiares.  
- Validación de estado civil vigente.  
- JOIN con tablas de salud, estado civil y cargas.

---

## Requisitos para ejecutar el script

1. Conectarse como SYS/ADMIN y ejecutar el script de creación de usuario.  
2. Conectarse como **PRY2205_S4**.  
3. Ejecutar el script de creación y poblamiento del esquema.  
4. Ejecutar el archivo incluído en este repositorio.  

---

## Notas
- Todas las consultas respetan el formato indicado en el enunciado (alias, orden, y manejo de datos).  
- No se utiliza la cláusula `WITH`, tal como se solicita.  
- El código está formateado para facilitar su lectura en SQL Developer.

---
