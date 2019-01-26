USE tiendaonline;

-- Dificultad A
-- T03.001- Código y nombre de los articulos con un precio entre 400 y 500 euros.
SELECT cod, nombre
FROM articulo
WHERE pvp BETWEEN 400 AND 500;

-- T03.002- Código y nombre de los articulos con precio 415, 129, 1259 o 3995.
SELECT cod, nombre
FROM articulo
WHERE pvp IN (415,129,1259,3995);

-- T03.003- Código y nombre de las provincias que no son Huelva, Sevilla, Asturias ni Barcelona.
SELECT codp, nombre
FROM provincia
WHERE nombre NOT IN ('Huelva','Sevilla','Asturias','Barcelona');

-- T03.004- Código de la provincia Alicante.
SELECT codp
FROM provincia
WHERE nombre LIKE 'Alicante%';

-- T03.005- Obtener el código, nombre y pvp de los articulos cuya marca comience por S.
SELECT cod, nombre, pvp
FROM articulo
WHERE marca LIKE 'S%';

-- T03.006- Información sobre los usuarios cuyo email es de la eps.
SELECT *
FROM usuario
WHERE email LIKE '%@eps.%';

-- T03.009- Email de los usuarios cuyo código postal no sea 02012, 02018 o 02032.
SELECT email
FROM usuario
WHERE codpos NOT IN ('02012','02018','02032');

-- T03.021- Nombre de los artículos cuyo nombre contenga la palabra EOS.
SELECT nombre
FROM articulo
WHERE nombre LIKE '%EOS%';

-- T03.022- Tipo y focal de los objetivos que se monten en una cámara Canon sea cual sea el modelo.
SELECT DISTINCT tipo, focal
FROM objetivo
WHERE montura LIKE 'Canon%';

-- T03.023- Nombre de los artículos cuyo precio sea mayor de 100 pero menor o igual que 200.
SELECT DISTINCT nombre
FROM articulo
WHERE pvp>100 && pvp<=200;

-- T03.024- Nombre de los artículos cuyo precio sea mayor o igual que 100 pero menor o igual que 300.
SELECT nombre
FROM articulo
WHERE pvp BETWEEN 100 AND 300;

-- T03.025- Nombre de las cámaras cuya marca no comience por la letra S.
SELECT a.nombre
FROM camara c, articulo a
WHERE marca NOT LIKE 'S%' AND c.cod=a.cod;

-- T03.027- Código de los televisores que tengan un panel LCD o LED.
SELECT cod
FROM tv
WHERE panel LIKE '%LCD%' OR panel LIKE '%LED%';

-- Dificultad B
-- T03.007- Código, nombre y resolución de los televisores cuya pantalla no esté entre 22 y 42.
SELECT tv.cod, a.nombre, resolucion
FROM tv, articulo a
WHERE pantalla NOT BETWEEN 22 AND 42 AND a.cod=tv.cod;

-- T03.008- Código y nombre de los televisores cuyo panel sea tipo LED y su precio no supere los 1000 euros.
SELECT a.cod, nombre
FROM tv, articulo a
WHERE tv.cod=a.cod AND panel LIKE '%LED%' AND pvp<=1000;

-- T03.010- Código y nombre de los packs de los que se conoce qué articulos los componen, eliminando duplicados.
SELECT DISTINCT cod, nombre
FROM articulo a, ptienea p
WHERE a.cod=p.pack AND articulo IS NOT NULL;

-- T03.011- ¿Hay algún artículo en cesta que esté descatalogado?
SELECT c.articulo,c.usuario,c.fecha,s.articulo stock,s.disponible,s.entrega
FROM stock s, cesta c
WHERE s.articulo=c.articulo AND entrega='Descatalogado';

-- T03.012- Código, nombre y pvp de las cámaras de tipo compacta.
SELECT a.cod, nombre, pvp
FROM articulo a, camara c
WHERE a.cod=c.cod AND tipo LIKE '%compacta%';

-- T03.013- Código, nombre y diferencia entre pvp e importe de los articulos que hayan sido solicitados en algún pedido a un importe distinto de su precio de venta al público.
SELECT cod, nombre, ABS(pvp-importe) cantidad
FROM articulo a, linped l
WHERE a.cod=l.articulo AND pvp!=importe;

-- T03.014- Número de pedido,fecha y nombre y apellidos del usuario que solicita el pedido, para aquellos pedidos solicitados por algún usuario de apellido MARTINEZ.
SELECT numPedido, fecha, nombre, apellidos
FROM pedido p, usuario u
WHERE p.usuario=u.email AND apellidos LIKE '%MARTINEZ%';

-- T03.019- Marcas de las que no existe ningún televisor en nuestra base de datos.
SELECT marca
FROM marca m
WHERE NOT EXISTS (
SELECT marca
FROM articulo a, tv
WHERE tv.cod=a.cod AND a.marca=m.marca);
SELECT marca
FROM marca
WHERE marca NOT IN (
SELECT DISTINCT marca
FROM articulo a, tv
WHERE tv.cod=a.cod);

-- T03.026- Dirección de correo de los usuarios cuyo dni termine en B, L o P.
SELECT email
FROM usuario
WHERE dni LIKE '%B' OR dni LIKE '%L' OR dni LIKE '%P';

-- T03.034- Nombre de las provincias en las que viven usuarios que hayan realizado algún pedido, eliminando duplicados.
SELECT DISTINCT pr.nombre
FROM provincia pr, usuario u, pedido pd
WHERE pr.codp=u.provincia AND pd.usuario=u.email;

-- T03.035- Nombre de los artículos que hayan sido seleccionados en alguna cesta con fecha entre 01.11.2010 y 31.12.2010
SELECT DISTINCT nombre
FROM articulo a, cesta c
WHERE a.cod=c.articulo AND fecha BETWEEN '2010-11-01' AND '2010-12-31';

-- T03.037- Número identificador de los pedidos en los que se han incluido artículos a un importe menor que su pvp, eliminando duplicados.
SELECT DISTINCT numPedido
FROM linped l, articulo a
WHERE l.articulo=a.cod AND importe<pvp;

-- Dificultad C
-- T03.015- Código, nombre y marca del artículo más caro.
SELECT cod, nombre, marca
FROM articulo
WHERE pvp = (
SELECT MAX(pvp)
FROM articulo);
SELECT cod, nombre, marca
FROM articulo
WHERE pvp >= ALL (
SELECT pvp
FROM articulo);

-- T03.016- Nombre, marca y resolucion de las cámaras que nunca se han solicitado.
SELECT nombre, marca, resolucion
FROM articulo a, camara c
WHERE a.cod=c.cod AND a.cod NOT IN (
SELECT DISTINCT articulo
FROM linped);

-- T03.017- Código, nombre, tipo y marca de las cámaras de marca Nikon, LG o Sigma.
SELECT c.cod, nombre, tipo, marca
FROM camara c, articulo a
WHERE c.cod=a.cod AND marca IN ('Nikon','LG','Sigma');

-- T03.018- Código, nombre y pvp de la cámara más cara de entre las de tipo réflex.
SELECT c.cod, nombre, pvp
FROM camara c, articulo a
WHERE c.cod=a.cod AND pvp =(
SELECT MAX(pvp)
FROM camara c, articulo a
WHERE c.cod=a.cod AND tipo LIKE '%réflex%');

-- T03.020- Código, nombre y disponibilidad de los artículos con menor disponibilidad de entre los que pueden estar disponibles en 24 horas.
SELECT cod, nombre, disponible
FROM articulo a, stock s
WHERE a.cod=s.articulo AND disponible = (
SELECT MIN(disponible)
FROM stock
WHERE entrega='24 horas');

-- T03.028- Número de pedido y artículo con la línea de pedido de menor importe.
SELECT numPedido, articulo
FROM linped
WHERE importe = (
SELECT MIN(importe)
FROM linped);

-- T03.029- Nombre de los televisores que tengan una pantalla mayor que el televisor de código A0686.
SELECT nombre
FROM articulo a, tv
WHERE tv.cod=a.cod AND pantalla > (
SELECT pantalla
FROM tv
WHERE cod='A0686');

-- T03.030- Líneas de pedido y número de pedido al que correspondan dichas líneas, y que incluyan más cantidad de artículos que las demás.
SELECT linea, numpedido
FROM linped
WHERE cantidad = (
SELECT MAX(cantidad)
FROM linped);

-- T03.031- Líneas de pedido y nombre de los artículos que aparecen en esas líneas, si el importe de esas líneas no es el menor de todas las líneas conocidas.
SELECT DISTINCT linea, nombre
FROM articulo a, linped l
WHERE a.cod=l.articulo AND importe > (
SELECT MIN(importe)
FROM linped);

-- T03.032- Nombre, precio y marca de los artículos con mayor disponibilidad de stock.
SELECT nombre, pvp, marca
FROM articulo a, stock s
WHERE a.cod=s.articulo AND disponible = (
SELECT MAX(disponible)
FROM stock);

-- T03.033- Nombre, precio y marca de los artículos que no tengan la mayor disponibilidad de stock.
SELECT nombre, pvp, marca
FROM articulo a, stock s
WHERE a.cod=s.articulo AND disponible < (
SELECT MAX(disponible)
FROM stock);

-- T03.036- Nombre de los artículos que hayan sido seleccionados en alguna cesta por usuarios de las provincias de Valencia o Alicante.
SELECT DISTINCT nombre
FROM articulo a, cesta c
WHERE a.cod=c.articulo AND usuario IN
	(
SELECT email
FROM usuario u, provincia p
WHERE u.provincia=p.codp AND (p.nombre LIKE 'Valencia%' OR p.nombre LIKE 'Alicante%'));
