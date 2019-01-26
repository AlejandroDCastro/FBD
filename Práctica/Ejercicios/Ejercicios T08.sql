USE tiendaonline;

-- Dificultad A
-- T08.001- Obtener el importe total por línea para el pedido 1, en la salida
-- aparecerá los campos numlinea, articulo y el campo calculado total.
SELECT linea, articulo, (importe*cantidad) importeTotal
FROM linped
WHERE numpedido=1;

-- T08.002- Obtener la cantidad de provincias distintas de las que tenemos
-- conocimiento de algún usuario.
SELECT COUNT(DISTINCT provincia) proDist
FROM usuario;

-- T08.003- Cantidad de usuarios de nuestra BD.
SELECT COUNT(*) usuarios
FROM usuario;

-- T08.004- Número de articulos con precio de venta al público mayor de 200 euros.
SELECT COUNT(*)
FROM articulo
WHERE pvp > 200;

-- T08.005- Total en euros de la cesta del usuario "bmm@agwab.com".
SELECT SUM(pvp) euros
FROM articulo a
JOIN cesta c ON (a.cod=c.articulo)
WHERE usuario='bmm@agwab.com';

-- T08.006- Tamaño máximo de pantalla para las televisiones.
SELECT MAX(pantalla) laMasGrande
FROM tv;

-- T08.007- Media de precios de venta al público distintos de los articulos,
-- redondeada a dos decimales.
SELECT ROUND(AVG(DISTINCT pvp),2) media
FROM articulo;

-- T08.010- Máximo, mínimo y media de importe de los artículos.
SELECT MAX(pvp) máximo, MIN(pvp) mínimo, AVG(pvp) media
FROM articulo;

-- T08.012- Cantidad de artículos que están descatalogados.
SELECT COUNT(*) articulos
FROM stock
WHERE entrega='Descatalogado';

-- T08.013- Precio máximo del artículo en stock que será entregado próximamente.
SELECT MAX(pvp) precioMáximo
FROM stock s
JOIN articulo a ON (articulo=cod)
WHERE entrega='Próximamente';

-- T08.015- Importe máximo, mínimo y medio de las líneas de pedido que
-- incluyen el artículo “Bravia KDL-32EX402”
SELECT MAX(importe) importeMax, MIN(importe) importeMin, AVG(importe) importeMin
FROM linped l
JOIN articulo a ON (articulo=cod)
WHERE nombre='Bravia KDL-32EX402';

-- T08.016- Cantidad total que se ha pedido de los artículos cuyo nombre
-- empieza por "UE22".
SELECT SUM(cantidad) cantidadTotal
FROM articulo a
JOIN linped l ON (articulo=cod)
WHERE nombre LIKE 'UE22%';

-- T08.017- Importe medio de los artículos incluidos en la línea de
-- pedido número 4, redondeado a 3 decimales.
SELECT ROUND(AVG(importe),3) importeMedio
FROM linped
WHERE linea=4;

-- T08.019- Diferencia entre el importe máximo y el importe mínimo del 
-- pedido número 30.
SELECT (MAX(importe)- MIN(importe)) diferenciaImporte
FROM linped
WHERE numpedido=30;

-- T08.021- Fecha de nacimiento del usuario más viejo.
SELECT MIN(nacido) viejales
FROM usuario;

-- T08.022- Obtener en una única consulta, cuántas filas tiene la tabla artículo,
-- cuántas de ellas tienen valor en la columna marca y cuántas marcas
-- distintas hay almacenadas en la tabla.
SELECT COUNT(*) filas, COUNT(marca) marcas, COUNT(DISTINCT marca) mascasDistintas
FROM articulo;

-- Dificultad B
-- T08.008- Nombre y precio de los articulos con el mínimo stock disponible.
SELECT nombre, pvp
FROM articulo
JOIN stock ON (articulo=cod)
WHERE disponible = (
SELECT MIN(disponible)
FROM stock);

-- T08.009- Número de pedido, fecha y nombre y apellidos del usuario de las
-- lineas de pedido cuyo total en euros es el más alto.
SELECT l.numpedido, fecha, nombre, apellidos
FROM usuario
JOIN pedido p ON (usuario=email)
JOIN linped l ON (l.numpedido=p.numpedido)
WHERE (importe*cantidad) = (
SELECT MAX(importe*cantidad)
FROM linped);

-- T08.011- Código, nombre, pvp y fecha de incorporación del artículo a la 
-- cesta más reciente.
SELECT cod, nombre, pvp, fecha
FROM articulo
JOIN cesta ON (articulo=cod)
WHERE fecha = (
SELECT MAX(fecha)
FROM cesta);

-- T08.014- Nombre, código y disponible en stock para todos los artículos
-- cuyo código acabe en 3, siendo ese disponible el mínimo de toda la tabla.
SELECT nombre, cod, disponible
FROM stock
JOIN articulo ON (articulo=cod)
WHERE cod LIKE '%3' AND disponible = (
SELECT MIN(disponible)
FROM stock);
	
-- T08.018- Número de pedido, nombre, teléfono y email de usuario del 
-- pedido (o los pedidos) que contiene líneas de pedido cuyo importe
-- unitario por artículo sea igual al importe más alto de entre todas
-- las segundas líneas de todos los pedidos.
SELECT l.numpedido, nombre, telefono, email
FROM usuario u
JOIN pedido p ON (email=usuario)
JOIN linped l ON (l.numpedido=p.numpedido)
WHERE importe = (
SELECT MAX(importe)
FROM linped
WHERE linea=2);

-- T08.020- Código, nombre, importe del artículo que más hay en stock.
SELECT cod, nombre, pvp
FROM articulo a
JOIN stock s ON (articulo=cod)
WHERE disponible = (
SELECT MAX(disponible)
FROM stock);