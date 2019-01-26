use tiendaonline;

-- Marcas de los televisores y cámaras, siempre que esos artículos no tengan pvp,
-- y ordenado por marca.
select marca
from articulo
where cod in (select cod from tv)
	and cod in (select cod from camara)
	and pvp is null
order by marca;

select marca
from articulo a, tv
where a.cod=tv.cod and pvp is null
union
select marca
from articulo a, camara c
where a.cod=c.cod and pvp is null
order by 1;


-- Crea una vista con nombre de los artículos que aparecen en cestas
-- de la semana 44 de cualquier año.

create or replace view Tcesta as
select nombre
from tiendaonline.articulo a, tiendaonline.cesta c
where a.cod=c.articulo
	and week(fecha)='44';
	
select * from Tcesta;

select nombre
from tiendaonline.articulo a, tiendaonline.cesta c
where a.cod=c.articulo
	and week(fecha)='44';


-- Calculamos, en primer lugar (lo vamos a utilizar como tabla temporal 
-- dentro de otra consulta), la suma de las cantidades de articulos pedidos
-- por cada marca, mostrando este dato solo para las marcas que hayan
-- sido pedidas en más de 20 líneas de pedido; una vez obtenido este resultado,
-- calcula la suma total de esas cantidades.
select marca, sum(cantidad) cantidades
from articulo a
join linped l on (l.articulo=a.cod)
group by 1
having count(*)>20;

select sum(cantidad) from linped;

select sum(cantidades)
from (select marca, sum(cantidad) cantidades
from articulo a
join linped l on (l.articulo=a.cod)
group by 1
having count(*)>20) as pp;


-- Sabiendo que el IVA está incluido en los importes de los artículos pedidos,
-- número de pedido e IVA (21 %) repercutido en cada pedido, para los pedidos
-- de agosto de 2010, ordenado por número de pedido. El IVA calculado debe
-- truncarse a 2 decimales.
select p.numpedido, round(sum(cantidad*importe)*0.21,2) IVA
from pedido p
join linped l on (p.numPedido=l.numPedido)
where year(p.fecha)='2010' and month(p.fecha)='08'
group by 1
order by 1;