USE tiendaonline;

-- Dificultad A
-- T05.011- Código y nombre de los artículos que no tienen marca.
SELECT cod, nombre
FROM articulo
WHERE marca IS NULL;

-- T05.012- Código, nombre y marca de todos los artículos, tengan o no marca.
SELECT cod, nombre, marca
FROM articulo;

-- T05.001- Número de pedido e identificador, apellidos y nombre del usuario que realiza el pedido (usando join).
SELECT numPedido, usuario, apellidos, nombre
FROM usuario u
JOIN pedido p ON (u.email=p.usuario);

-- T05.005- Apellidos y nombre de los usuarios y, si tienen, pedido que han realizado.
SELECT apellidos, nombre, numPedido
FROM usuario
LEFT JOIN pedido ON (email=usuario);

-- T05.006- Código y nombre de los artículos, si además es una cámara, mostrar también la resolución y el sensor.
SELECT a.cod, nombre, resolucion, sensor
FROM articulo a
LEFT JOIN camara c ON (c.cod=a.cod);

-- T05.007- Código, nombre y pvp de los artículos, si además se trata de un objetivo mostrar todos sus datos.
SELECT a.cod, nombre, pvp, o.*
FROM articulo a
LEFT JOIN objetivo o ON (a.cod=o.cod);

-- T05.008- Muestra las cestas del año 2010 junto con el nombre del artículo al que referencia y su precio de venta al público.
SELECT c.*, nombre, pvp
FROM cesta c
JOIN articulo a ON (a.cod=c.articulo);
WHERE YEAR(fecha)=2010;

-- T05.010- Disponibilidad en el stock de cada cámara junto con la resolución de todas las cámaras.
SELECT s.*, resolucion
FROM stock s
RIGHT JOIN camara c ON (c.cod=s.articulo);

-- T05.015- Código y nombre de los artículos, y código de pack en el caso de que pertenezca a alguno.
SELECT cod, nombre, pack
FROM articulo a
LEFT JOIN ptienea p ON (p.articulo=a.cod);

-- Dificultad B
-- T05.016- Usuarios y pedidos que han realizado.
SELECT *
FROM usuario u
JOIN pedido p ON (email=usuario);

-- T05.002- Número de pedido e identificador, apellidos y nombre del usuario que realiza
-- el pedido, y nombre de la localidad del usuario (usando join).
SELECT numpedido, usuario, apellidos, u.nombre, l.pueblo
FROM pedido p
JOIN usuario u ON (p.usuario=u.email)
JOIN localidad l ON (l.codm=u.pueblo AND l.provincia=u.provincia);

-- T05.003- Número de pedido e identificador, apellidos y nombre del usuario que realiza
-- el pedido, nombre de la localidad y nombre de la provincia del usuario (usando join).
SELECT numpedido, usuario, apellidos, u.nombre nusuario, l.pueblo, pr.nombre nprovincia
FROM pedido p
JOIN usuario u ON (p.usuario=u.email)
JOIN localidad l ON (l.codm=u.pueblo AND l.provincia=u.provincia)
JOIN provincia pr ON (pr.codp=l.provincia);

-- T05.004- Nombre de provincia y nombre de localidad ordenados por provincia y localidad (usando join)
-- de las provincias de Aragón y de localidades cuyo nombre comience por "B".
SELECT p.nombre pnombre, l.pueblo lnombre
FROM provincia p
JOIN localidad l ON (l.provincia=p.codp)
WHERE p.nombre IN ('Huesca','Teruel','Zaragoza') AND l.pueblo LIKE 'B%'
ORDER BY 1, 2;

-- T05.009- Muestra toda la información de los artículos. Si alguno aparece en una
-- cesta del año 2010 muestra esta información.
SELECT *
FROM articulo a
LEFT JOIN cesta ON (cod=articulo AND YEAR(fecha)=2010);

-- T05.013- Código, nombre, marca y empresa responsable de la misma de todos los
-- artículos. Si algún artículo no tiene marca debe aparecer en el listado
-- con esta información vacía.
SELECT cod, nombre, a.marca, empresa
FROM articulo a
LEFT JOIN marca m ON (m.marca=a.marca);

-- T05.014- Información de todos los usuarios de la comunidad valenciana cuyo nombre
-- empiece por 'P' incluyendo la dirección de envío en caso de que la tenga.
SELECT u.*, d.*
FROM usuario u
JOIN provincia p ON (p.codp=u.provincia)
LEFT JOIN direnvio d ON (d.email=u.email)
WHERE u.nombre LIKE 'P%' AND
	(p.nombre LIKE 'Valencia%' OR
	p.nombre LIKE 'Castellón%' OR
	p.nombre LIKE 'Alicante%');
	
SELECT u.*, d.calle, d.calle2, d.codpos, d.pueblo, d.provincia
FROM usuario u
LEFT JOIN direnvio d ON (u.email=d.email)
WHERE u.provincia IN ('03','12','46') AND u.nombre LIKE 'P%';

-- Dificultad C
-- T05.017- Información de aquellos usuarios de la comunidad valenciana
-- (códigos 03, 12 y 46) cuyo nombre empiece por 'P' que tienen
-- dirección de envío pero mostrando, a la derecha, todas las direcciones
-- de envío de la base de datos.
SELECT u.*, d.calle, d.calle2, d.codpos, d.pueblo, d.provincia
FROM usuario u
RIGHT JOIN direnvio d ON (d.email=u.email AND u.provincia IN ('03','12','46') AND u.nombre LIKE 'P%');
SELECT u.*, d.calle, d.calle2, d.codpos, d.pueblo, d.provincia
FROM direnvio d
LEFT JOIN usuario u ON (d.email=u.email AND u.provincia IN ('03','12','46') AND u.nombre LIKE 'P%');