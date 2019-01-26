use tiendaonline;

-- Dificultad A
-- T09.004- Número de cámaras que tienen sensor CMOS
select count(*) camaras
from camara
where sensor LIKE '%CMOS%';

-- T09.016- Cantidad de artículos con stock 0
select count(*) articulos
from stock
where disponible=0;

-- Dificultad B
-- T09.001- ¿Cuántos artículos de cada marca hay?
select marca, count(*) articulos
from articulo
group by 1;

-- T09.012- Ha habido un error en Tiendaonline y se han colado varios
-- artículos sin stock, con cero unidades disponibles, en la cesta.
-- Averigua el código de esos artículos y las veces que aparece cada uno en cesta.
select s.articulo, count(*) vecesQueAparece
from stock s
join cesta c on (c.articulo=s.articulo)
where disponible=0
group by 1;

-- T09.014- ¿Cuántas veces se ha pedido cada artículo? Si hubiese artículos
-- que no se han incluido en pedido alguno también se mostrarán. Mostrar el
-- código y nombre del artículo junto con las veces que ha sido incluido
-- en un pedido (solo si ha sido incluido, no se trata de la "cantidad").
select cod, nombre, count(numpedido)
from articulo a
left join linped l on (articulo=cod)
group by 1,2;
-- El "truco" consiste en contar los números de pedido asociados a algunos artículos.
-- El left join hace que ciertos artículos aparezcan una vez junto con NULL como numpedido.
-- El resto de artículos aparecen tantas veces como líneas tengan en LINPED. Como
-- count(numpedido) solo cuenta los valores distintos de NULL, por eso conseguimos
-- que la cuenta sea 0 en los artículos no pedidos nunca.

-- T09.017- Cantidad de artículos que no son ni memoria, ni tv, 
-- ni objetivo, ni cámara ni pack.
select count(*) cantidad
from articulo
where cod not in (select cod from memoria)
	and cod not in (select cod from tv)
	and cod not in (select cod from objetivo)
	and cod not in (select cod from camara)
	and cod not in (select cod from pack);