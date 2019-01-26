USE tiendaonline;

-- Dificultad A
-- T04.001- Toda la información de los pedidos anteriores a octubre de 2010.
SELECT *
FROM pedido
WHERE fecha < '2010-10-01';

-- T04.002- Toda la información de los pedidos posteriores a agosto de 2010.
SELECT *
FROM pedido
WHERE fecha > '2010-08-31';

-- T04.003- Toda la información de los pedidos realizados entre agosto y octubre de 2010.
SELECT *
FROM pedido
WHERE fecha BETWEEN '2010-08-01' AND '2010-10-31';

-- T04.004- Toda la información de los pedidos realizados el 3 de marzo o el 27 de octubre de 2010.
SELECT *
FROM pedido
WHERE fecha IN ('2010-03-03','2010-10-27');

-- T04.005- Toda la información de los pedidos realizados el 3 de marzo o el 27 de octubre de 2010, y que han sido realizados por usuarios del dominio "cazurren"
SELECT *
FROM pedido
WHERE usuario LIKE '%@cazurren.%' AND fecha IN ('2010-03-03','2010-10-27');

-- Dificultad D
-- T04.006- ¿En qué día y hora vivimos?
SELECT NOW();

-- T04.012- Códigos de articulos solicitados en 2010, eliminando duplicados y ordenado ascendentemente.
SELECT DISTINCT l.articulo
FROM linped l, pedido p
WHERE l.numPedido=p.numPedido AND YEAR(fecha)=2010
ORDER BY 1;

-- T04.013- Códigos de articulos solicitados en pedidos de marzo de 2010, eliminando duplicados y ordenado ascendentemente.
SELECT DISTINCT l.articulo
FROM linped l, pedido p
WHERE l.numPedido=p.numPedido AND MONTH(fecha)=03 AND YEAR(fecha)=2010
ORDER BY 1;