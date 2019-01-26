USE tiendaonline;


-- Dificultad B
-- T10.004- Cantidad de pedidos de usuarios con direcciones de envío alternativas
SELECT COUNT(*) pedidos
FROM pedido p
JOIN direnvio d ON (d.email=p.usuario);

-- T10.011- Fechas de pedido y cantidad de pedidos efectuados en ellas, sin tener en
-- cuenta las líneas de pedido con importes superiores a 1000 €.
SELECT fecha, COUNT(DISTINCT l.numpedido) pedidos
FROM pedido p
JOIN linped l ON (p.numpedido=l.numpedido)
WHERE importe<=1000
GROUP BY 1;

-- T10.012- Fechas de pedido (solo fecha) e importe total pagado en sus pedidos, ordenado por ese importe total.
SELECT DATE(fecha), SUM(importe*cantidad) importeTotal
FROM pedido p
JOIN linped l ON (p.numpedido=l.numpedido)
GROUP BY 1
ORDER BY 2;

-- T10.013- Número de pedido y cantidad de líneas de pedido por cada uno, ordenado de mayor a menor por esa cantidad.
SELECT numpedido, COUNT(*) lineas
FROM linped l
GROUP BY 1
ORDER BY 2 DESC;
-- el resultado no es el mismo
SELECT numpedido, COUNT(*) lineas
FROM linped
GROUP BY numpedido
ORDER BY COUNT(*) DESC;

-- T10.017- Cantidad de artículos sin PVP.
SELECT COUNT(*) articulos
FROM articulo
WHERE pvp IS NULL;

-- T10.018- Cantidad de artículos sin PVP y descatalogados.
SELECT COUNT(*) noPVPDescatalogado
FROM articulo a
JOIN stock s ON (a.cod=s.articulo)
WHERE pvp IS NULL AND entrega='Descatalogado';

-- T10.019- Marca y cantidad de artículos cuyo nombre indique que son objetivos con focales
-- "18-200 mm" o "28-200 mm", ordenado de mayor a menor por esa cantidad.
SELECT marca, COUNT(*) cantidades
FROM articulo a
WHERE nombre LIKE '%18-200 mm%' OR nombre LIKE '%28-200 mm%'
GROUP BY 1
ORDER BY 2 DESC;

-- T10.020- Código y nombre de provincias, y media y desviación estandar de cantidad de artículos pedidos desde esas provincias.
SELECT codp, pr.nombre, AVG(cantidad) media, STD(cantidad) desviacion
FROM linped l
JOIN pedido pe ON (pe.numpedido=l.numpedido)
JOIN usuario u ON (u.email=pe.usuario)
JOIN provincia pr ON (pr.codp=u.provincia)
GROUP BY 1, 2;

-- T10.022- Número de pedido, fecha, email, apellidos y nombre de usuario, e IVA (21 %, incluido en los importes,
-- redondeado a 2 decimales) a repercutir en cada factura derivada de la hoja de pedido, ordenado por fecha y email.
SELECT l.numpedido, fecha, u.email, u.apellidos, u.nombre, ROUND(SUM(0.21*l.importe*cantidad),2) IVA
FROM usuario u
JOIN pedido p ON (p.usuario=u.email)
JOIN linped l ON (l.numpedido=p.numpedido)
GROUP BY 1, 2, 3, 4, 5				-- a repercutir en cada factura derivada de la hoja de pedido, que coño significa esta mierda
ORDER BY 2, 3;

-- T10.023- Número de pedido, fecha, email, apellidos y nombre de usuario, y base imponible (importe - 21 % IVA) de cada
-- factura derivada de la hoja de pedido, ordenado por fecha y email. Cálculos redondeados a 2 decimales.
SELECT l.numpedido, fecha, u.email, u.apellidos, u.nombre, ROUND(SUM(0.79*l.importe*cantidad),2) baseNoIVA
FROM usuario u
JOIN pedido p ON (p.usuario=u.email)
JOIN linped l ON (l.numpedido=p.numpedido)
GROUP BY 1, 2, 3, 4, 5
ORDER BY 2, 3;

-- T10.024- Año, mes y total de IVA (21 %, incluido en los importes) repercutido,
-- ordenado por año y mes. Cálculos redondeados a 2 decimales.
SELECT YEAR(fecha), MONTH(fecha), ROUND(SUM(0.21*importe*cantidad),2) 'total IVA'
FROM pedido p
JOIN linped l ON (p.numpedido=l.numpedido)
GROUP BY 1, 2
ORDER BY 1, 2;

-- T10.025- Año, mes y base imponible total (IVA 21 %, incluido en los importes) de sus pedidos,
-- ordenado por año y mes. Cálculos redondeados a 2 decimales.
SELECT YEAR(fecha), MONTH(fecha), ROUND(SUM(0.79*l.importe*cantidad),2) IVAincluded
FROM pedido p
JOIN linped l ON (p.numpedido=l.numpedido)
GROUP BY 1, 2
ORDER BY 1, 2;

-- T10.026- Por cada año y mes, base imponible, IVA (21 %, incluido en los
-- importes) repercutido e importe total de todos sus pedidos,
-- ordenado por año y mes. Cálculos redondeados a 2 decimales.
SELECT YEAR(fecha) año, MONTH(fecha) mes, ROUND(SUM(0.79*importe*cantidad),2) IVA, ROUND(SUM(0.21*importe*cantidad),2) base, ROUND(SUM(importe*cantidad),2) total
FROM pedido p
JOIN linped l ON (p.numPedido=l.numPedido)
GROUP BY 1, 2
ORDER BY 1, 2;

-- Dificultad C
-- T10.001- Email, nombre y apellidos de usuario, y nombre de provincia
-- y localidad donde vive, ordenado de mayor a menor total en euros
-- comprado en nuestra tienda
SELECT email, u.nombre, apellidos, pr.nombre, l.pueblo
FROM usuario u
JOIN localidad l ON (u.pueblo=l.codm AND u.provincia=l.provincia)
JOIN provincia pr ON (pr.codp=l.provincia)
JOIN pedido pe ON (u.email=pe.usuario)
JOIN linped li ON (li.numPedido=pe.numPedido)
GROUP BY 1, 2, 3, 4, 5
ORDER BY SUM(importe*cantidad) DESC;

-- T10.002- Email, nombre y apellidos de usuario, y nombre de provincia y
-- localidad donde vive, de los 5 primeros que más han pedido a nuestra
-- tienda en total de euros.
SELECT email, u.nombre, apellidos, pr.nombre provin, l.pueblo locali
FROM usuario u
JOIN localidad l ON (u.pueblo=l.codm AND u.provincia=l.provincia)
JOIN provincia pr ON (pr.codp=l.provincia)
JOIN pedido pe ON (u.email=pe.usuario)
JOIN linped li ON (li.numPedido=pe.numPedido)
GROUP BY 1, 2, 3, 4, 5
ORDER BY SUM(importe*cantidad) DESC
LIMIT 5;

-- T10.003- Email, nombre y apellidos de usuario, y nombre de provincia
-- y localidad donde vive, de los cinco que menos han pedido a nuestra
-- tienda en total de euros.
SELECT email, u.nombre, apellidos, pr.nombre provin, l.pueblo locali
FROM usuario u
JOIN localidad l ON (u.pueblo=l.codm AND u.provincia=l.provincia)
JOIN provincia pr ON (pr.codp=l.provincia)
JOIN pedido pe ON (u.email=pe.usuario)
JOIN linped li ON (li.numPedido=pe.numPedido)
GROUP BY 1, 2, 3, 4, 5
ORDER BY SUM(importe*cantidad)
LIMIT 5;

-- T10.005- Provincias y cantidad de pedidos servidos en ellas,
-- para aquellas provincias con un promedio de importe total de sus
-- líneas de pedidos por encima de los 1500 €.
SELECT provincia, COUNT(*) pedidos
FROM usuario u
JOIN pedido pe ON (pe.usuario=u.email)
JOIN linped l ON (l.numPedido=pe.numPedido)
GROUP BY 1
HAVING AVG(cantidad*importe)>=1500;

-- T10.006- Marcas y cantidad de cámaras con disponible superior a 0 unidades,
-- si esa cantidad es inferior a 20.
SELECT marca, COUNT(*) camaras
FROM articulo a
JOIN camara c ON (a.cod=c.cod)
JOIN stock s ON (s.articulo=a.cod)
WHERE disponible>0
GROUP BY 1
HAVING COUNT(*)<20;

-- T10.007- Códigos de provincia y localidad de los usuarios que han
-- hecho más de 1 pedido. Sin duplicados.
SELECT DISTINCT provincia, pueblo
FROM usuario u
JOIN pedido p ON (u.email=p.usuario)
GROUP BY email, 1, 2
HAVING COUNT(*)>1;

-- T10.008- Marcas y promedio de precios de venta al público de sus artículos,
-- exceptuando los packs, y teniendo esas marcas una cantidad de artículos
-- mayor que 100, ordenado descendentemente por promedio.
SELECT marca, AVG(pvp) promedio
FROM articulo
WHERE cod NOT IN (
SELECT cod
FROM pack)
GROUP BY 1
HAVING COUNT(*)>100
ORDER BY 2 DESC;

-- T10.009- Códigos de artículo y marca de los televisores cuyo promedio
-- de importe unitario en pedidos supera en un 10 % al precio de
-- venta al público actual.
SELECT a.cod, a.marca
FROM articulo a
JOIN tv ON (a.cod=tv.cod)
JOIN linped l ON (a.cod=l.articulo)
GROUP BY 1, 2
HAVING AVG(l.importe) > MAX(a.pvp)*1.10;

-- T10.010- Código de artículo, marca e importe medio de las cámaras que han
-- sido pedidos en más de dos líneas de pedido, ordenado por marca y código de artículo.
SELECT a.cod, marca, AVG(importe) importeMedio
FROM articulo a
JOIN camara c ON (a.cod=c.cod)
JOIN linped l ON (a.cod=l.articulo)
GROUP BY 1, 2
HAVING COUNT(*)>2
ORDER BY 2, 1;

-- T10.014- Apellidos de personas que están repetidos.
SELECT apellidos
FROM usuario
GROUP BY 1
HAVING COUNT(*)>1;

-- T10.015- Nombre y apellidos de usuarios que están repetidos.
SELECT nombre, apellidos
FROM usuario
GROUP BY 1, 2
HAVING COUNT(*)>1;

-- T10.016- Nombres de localidad y cantidad de provincias en las que se
-- encuentra un pueblo con ese nombre, para nombres con 2 o más provincias.
SELECT pueblo, COUNT(*) provincias
FROM localidad
GROUP BY 1
HAVING COUNT(*)>1;

-- T10.027- Por cada año y mes, base imponible, IVA (21 %, incluido
-- en los importes) repercutido e importe total de todos sus pedidos,
-- ordenado por año y mes. Solo los meses cuya cantidad de pedidos
-- sea mayor que 10. Cálculos redondeados a 2 decimales.
SELECT YEAR(fecha) año, MONTH(fecha) mes, ROUND(SUM(importe*cantidad*.79),2) base, ROUND(SUM(importe*cantidad*.21),2) base, ROUND(SUM(importe*cantidad),2) base
FROM pedido p
JOIN linped l ON (l.numPedido=p.numPedido)
GROUP BY 1, 2
HAVING COUNT(DISTINCT l.numpedido)>10
ORDER BY 1, 2;

-- T10.028- Por cada año y mes, base imponible, IVA (21 %, incluido en
-- los importes) repercutido e importe total de todos sus pedidos, ordenado
-- por año y mes. Eliminando pedidos de la provincia 33 y solo los meses
-- cuya cantidad de pedidos sea mayor que 10. Cálculos redondeados a 2 decimales.
SELECT YEAR(fecha) año, MONTH(fecha) mes, ROUND(SUM(importe*cantidad*.79),2) base, ROUND(SUM(importe*cantidad*.21),2) base, ROUND(SUM(importe*cantidad),2) base
FROM pedido p
JOIN linped l ON (l.numPedido=p.numPedido)
JOIN usuario u ON (u.email=p.usuario)
WHERE u.provincia != '33'
GROUP BY 1, 2
HAVING COUNT(DISTINCT l.numpedido)>10
ORDER BY 1, 2;

-- T10.029- Fechas de pedido y cantidad de pedidos efectuados en ellas,
-- exceptuando los pedidos que contengan líneas con importes inferiores a 1000 €.
SELECT fecha, COUNT(DISTINCT p.numpedido) pedidos
FROM pedido p
JOIN linped l ON (l.numPedido=p.numpedido)
WHERE p.numpedido NOT IN (
SELECT numpedido
FROM linped
WHERE importe<1000)
GROUP BY 1;