USE tiendaonline;

-- Dificultad 1
-- T02B.006- Código, nombre y pvp de los artículos de menos de 100€; la salida ha de ser código, nombre, "tiene el precio de", pvp.
SELECT cod, nombre, 'tiene el precio de', pvp
FROM articulo
WHERE pvp < 100;

-- Dificultad A
-- T02B.007- DNI,email,nombre y apellidos de los usuarios de la provincia de Asturias (código 33).
SELECT dni, email, nombre, apellidos
FROM usuario
WHERE provincia LIKE '33';

SELECT dni, email, u.nombre, apellidos
FROM usuario u, provincia p
WHERE u.provincia=p.codp AND p.nombre='Asturias';

-- T02B.008- Toda la información (código y nombre) de las provincias de las que se tienen usuarios
SELECT DISTINCT p.*
FROM provincia p, usuario u
WHERE p.codp=u.provincia;

SELECT *
FROM provincia
WHERE codp IN (
SELECT DISTINCT provincia
FROM usuario);

-- T02B.009- Toda la información (código y nombre) de las provincias de las que se tienen usuarios, eliminando duplicados y ordenando por nombre
SELECT DISTINCT p.*
FROM provincia p, usuario u
WHERE p.codp=u.provincia
ORDER BY p.nombre;

SELECT DISTINCT p.*
FROM provincia p, usuario u
WHERE p.codp=u.provincia
ORDER BY 2;

-- T02B.010- Email de los usuarios de la provincia de Murcia que no tienen teléfono, acompañado en la salida por un mensaje que diga "No tiene teléfono"
SELECT email, 'No tiene teléfono'
FROM usuario u, provincia p
WHERE u.provincia=p.codp AND p.nombre='Murcia' AND u.telefono IS NULL;

-- T02B.012- Artículos que no tienen marca
SELECT *
FROM articulo
WHERE marca IS NULL;

-- T02B.014- Número de pack, nombre y precio del mismo.
SELECT p.cod, a.nombre, a.pvp
FROM articulo a, pack p
WHERE a.cod=p.cod;

-- T02B.015- Código, nombre y marca de los articulos que pertenecen a algún pack.
SELECT DISTINCT a.cod, nombre, marca
FROM articulo a, ptienea pt
WHERE a.cod=pt.articulo;

-- T02B.017- Código, nombre, marca, pvp e importe de los artículos solicitados en el pedido número 1.
SELECT cod, nombre, marca, pvp, importe
FROM articulo a, linped l
WHERE a.cod=l.articulo AND numPedido=1;

-- T02B.022- Código, sensor y pantalla de las cámaras, si es que "pantalla" tiene valor, ordenado por código descendentemente
SELECT cod, sensor, pantalla
FROM camara
WHERE pantalla IS NOT NULL
ORDER BY cod DESC;

-- Dificultad B
-- T02B.018- Código, nombre, marca, pvp e importe de los artículos solicitados en el pedido número 1 que sean televisores.
SELECT a.cod, nombre, marca, pvp, importe
FROM articulo a, tv, linped l
WHERE a.cod=l.articulo AND l.articulo=tv.cod AND numpedido=1;

-- Fecha y usuario del pedido, código, nombre, marca, pvp e importe de los artículos solicitados en el pedido número 1 que sean televisores.
SELECT fecha, usuario, a.cod, nombre, marca, pvp, importe
FROM articulo a, pedido p, linped l, tv
WHERE a.cod=l.articulo AND p.numPedido=l.numPedido AND tv.cod=a.cod AND l.numpedido=1;

-- Dificultad C
-- T02B.025- Número de pack, nombre y precio del mismo, y código, nombre y pvp de los artículos que pertenezcan a ellos.
SELECT p.pack, a1.nombre, a1.pvp, a2.cod, a2.nombre, a2.pvp
FROM ptienea p, articulo a1, articulo a2
WHERE p.pack=a1.cod AND a2.cod=p.articulo;