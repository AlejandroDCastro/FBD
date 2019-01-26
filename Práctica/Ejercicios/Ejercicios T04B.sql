USE tiendaonline;

-- Dificultad C
-- T04B.014- Códigos de articulos solicitados en pedidos de septiembre de 2010,
-- y semana del año (la semana comienza en lunes) y año del pedido, ordenado por semana.
SELECT articulo, WEEK(fecha) semana, MONTH(fecha) mes
FROM linped l
JOIN pedido p ON (p.numPedido=l.numPedido)
WHERE YEAR(fecha)=2010 AND MONTH(fecha)=09
ORDER BY 2;

-- T04B.018- Número de pedido, usuario y fecha (dd/mm/aaaa) al que se le solicitó para los
-- pedidos que se realizaron durante la semana del 7 de noviembre de 2010.
SELECT numpedido, usuario, DATE_FORMAT(fecha, '%d/%m/%y') fecha
FROM pedido
WHERE DATE_FORMAT(fecha,'%u') = DATE_FORMAT('2010-11-07','%u');

-- T04B.019- Código, nombre, panel y pantalla de los televisores que no se hayan solicitado
-- ni en lo que va de año, ni en los últimos seis meses del año pasado.
SELECT a.cod, nombre, panel, pantalla
FROM articulo a, tv
WHERE a.cod=tv.cod AND a.cod NOT IN (
SELECT articulo
FROM linped l, pedido p
WHERE l.numpedido=p.numpedido AND (
 (YEAR(fecha)= YEAR(NOW())-1 AND MONTH(fecha) BETWEEN 7 AND 12)
) OR YEAR(fecha)= YEAR(NOW())
);
 
-- T04B.020- Email y cantidad de días que han pasado desde los pedidos
-- realizados por cada usuario hasta la fecha de cada artículo que
-- ahora mismo hay en su cesta. Eliminad duplicados.
SELECT DISTINCT p.usuario, DATEDIFF(c.fecha,p.fecha) dias
FROM cesta c, pedido p, linped l
WHERE c.usuario=p.usuario AND l.numPedido=p.numPedido AND c.articulo=l.articulo;
	
-- Dificultad C
-- T04B.007- 21 de febrero de 2011 en formato dd/mm/aaaa
SELECT DATE_FORMAT('2011-02-21','%d/%m/%Y') fecha;

-- T04B.008- 31 de febrero de 2011 en formato dd/mm/aaaa
SELECT DATE_FORMAT('2011-02-31','%d/%m/%Y') fecha;

-- T04B.009- Pedidos realizados el 13.9.2010 (este formato, obligatorio en la comparación).
SELECT *
FROM pedido
WHERE fecha = STR_TO_DATE('13.9.2010','%d.%m.%Y');

-- T04B.010- Numero y fecha de los pedidos realizados el 13.9.2010 (este formato,
-- obligatorio tanto en la comparación como en la salida).
SELECT numpedido, DATE_FORMAT(fecha,'%d.%c.%Y') lafecha
FROM pedido
WHERE fecha = STR_TO_DATE('13.9.2010','%d.%c.%Y');

-- T04B.011- Numero, fecha, y email de cliente de los pedidos (formato dd.mm.aa)
-- ordenado descendentemente por fecha y ascendentemente por cliente.
SELECT numpedido, DATE_FORMAT(fecha,'%d.%m.%y') lafecha, usuario
FROM pedido
ORDER BY fecha DESC, usuario;

-- T04B.015- Nombre, apellidos y edad (aproximada) de los usuarios del dominio
-- "dlsi.ua.es", ordenado descendentemente por edad.
SELECT nombre, apellidos, YEAR(NOW())- YEAR(nacido) edad
FROM usuario
WHERE email LIKE '%@dlsi.ua.es'
ORDER BY edad DESC;

-- T04B.016- Email y cantidad de días que han pasado desde los pedidos realizados 
-- por cada usuario hasta la fecha de cada cesta que también sea suya. Eliminad duplicados.
SELECT DISTINCT p.usuario, DATEDIFF(c.fecha,p.fecha) dias
FROM pedido p, cesta c
WHERE p.usuario=c.usuario;

-- T04B.017- Información sobre los usuarios menores de 25 años.
SELECT *
FROM usuario
WHERE YEAR(NOW())- YEAR(nacido) < 25;