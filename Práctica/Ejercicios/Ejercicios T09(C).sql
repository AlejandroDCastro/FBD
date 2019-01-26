USE tiendaonline;

-- T09.002- ¿Cuáles son las marcas (en la tabla ARTICULO) que tienen
-- menos de 150 artículos?
select marca, count(*) articulos
from articulo
group by 1
having count(*)<150;

-- T09.003- ¿Cuáles son las marcas (en la tabla ARTICULO) que tienen
-- menos de 150 artículos (eliminar las marcas que sean null)?
select marca, count(*) articulos
from articulo
where marca is not null
group by 1
having count(*)<150;

-- T09.005- Dni, nombre, apellidos y email de los usuarios que
-- han realizado más de un pedido.
select dni, nombre, apellidos, email
from usuario u
join pedido p on (u.email=p.usuario)
group by 1, 2, 3, 4
having count(*)>1;

-- T09.006- Pedidos (número de pedido y usuario) de importe mayor a 4000 euros.
select p.numpedido, usuario
from pedido p
join linped l on (l.numPedido=p.numPedido)
group by 1, 2
having sum(importe*cantidad)>4000;

-- T09.007- Pedidos (número de pedido y usuario) con más de 10 artículos,
-- mostrando esta cantidad.
select p.numpedido, usuario, sum(cantidad) artsPorPed
from pedido p
join linped l on (p.numPedido=l.numPedido)
group by 1, 2
having sum(cantidad)>10;

-- T09.008- Pedidos (número de pedido y usuario) que contengan más
-- de cuatro artículos distintos.
select p.numpedido, usuario, count(distinct articulo) articulos
from pedido p
join linped l on (p.numPedido=l.numPedido)
group by 1, 2
having count(distinct articulo)>4;

-- T09.009- ¿Hay dos provincias que se llamen igual (con nombre repetido)?
select nombre, count(*)
from provincia
group by nombre
having count(*)>1;

-- T09.010- ¿Hay algún pueblo con nombre repetido?
select pueblo, count(*)
from localidad
group by 1
having count(*)>1;

-- T09.011- Obtener el código y nombre de las provincias que tengan más de 100 pueblos.
select codp, nombre, count(*)
from provincia p
join localidad l on (p.codp=l.provincia)
group by 1, 2
having count(*)>100;

-- T09.013- Clientes que hayan adquirido (pedido) más de 2 tv
select usuario, sum(cantidad)
from pedido p
join linped l on (p.numPedido=l.numPedido)
join tv on (tv.cod=l.articulo)
group by 1
having sum(cantidad)>2;

-- T09.015- Código y nombre de las provincias que tienen más de 50 usuarios
-- (provincia del usuario, no de la dirección de envío).
select codp, p.nombre
from provincia p
join usuario u on (p.codp=u.provincia)
group by 1, 2
having count(dni)>50;

-- T09.018- Número de artículos pedidos por provincia (provincia del usuario
-- no de la dirección de envío). Mostrar el código de la provincia, su nombre
-- y la cantidad de veces que se ha pedido el artículo; si la provincia no
-- tiene asociada esta cantidad, mostrar "0" en esa columna.
select codp, pr.nombre, ifnull(sum(cantidad),0) pedidos
from provincia pr
left join usuario u on (pr.codp=u.provincia)
left join pedido pe on (u.email=pe.usuario)
left join linped l on (l.numPedido=pe.numPedido)
group by 1, 2;

-- T09.019- Código y nombre de los artículos que han sido solicitados en
-- todos los pedidos del usuario acm@colegas.com.
select cod, nombre
from articulo a
where cod in
	(select articulo
	from linped l
	join pedido p on (l.numPedido=p.numPedido)
	where usuario='acm@colegas.com'
	group by 1
	having count(distinct p.numpedido) = (
		select count(*)
		from pedido
		where usuario='acm@colegas.com')
	);
	
-- T09.20- ¿Cuáles son las marcas que tienen menos de 150 artículos?
select marca, count(*)
from articulo
where marca is not null
group by 1
having count(*)<150;

select m.marca, count(cod)
from marca m
left join articulo a on (m.marca=a.marca)
group by 1
having count(cod)<150;