use tiendaonline;

-- Dificultad A
-- T11.002- Utilizando operadores de conjuntos obtener los
-- nombres de los artículos que sean cámaras compactas con
-- visor electrónico o televisores CRT.
SELECT nombre
FROM articulo a, camara c
WHERE a.cod=c.cod AND tipo LIKE '%compacta%visor%electrónico%'
UNION
SELECT nombre
FROM articulo a, tv
WHERE a.cod=tv.cod AND panel LIKE '%televisor%CRT%';

-- T11.004- Nombre y email de los usuarios de Asturias que
-- tengan la misma dirección de envío que de residencia
-- (que no tengan dirección de envío).
select u.nombre, email
from usuario u
join provincia p on (p.codp=u.provincia)
where p.nombre='Asturias'
	and email not in (select email from direnvio);
	
-- T11.007- Utilizando operadores de conjuntos, muestra 
-- los nombres de los artículos que estén en un pack.
select nombre
from articulo
where cod in (select articulo from ptienea);

-- T11.009- Los códigos de los artículos que están en stock,
-- en la cesta y han sido pedidos.
select articulo
from stock
where articulo in (select articulo from cesta)
	and articulo in (select articulo from linped);
	
select distinct s.articulo
from stock s
join cesta c on (c.articulo=s.articulo)
join linped l on (l.articulo=s.articulo);

-- T11.011- Códigos de artículos que están en alguna cesta
-- o en alguna línea de pedido.
select articulo from cesta
union
select articulo from linped;

select cod
from articulo
where cod in (select articulo from cesta)
	or cod in (select articulo from linped);
	
-- T11.013- Apellidos que se repitan en más de un usuario
-- (sin utilizar group by).
select distinct u1.apellidos
from usuario u1, usuario u2
where u1.apellidos=u2.apellidos
	and u1.email<>u2.email;
	
select apellidos
from usuario
group by 1
having count(*)>1;

-- T11.014- Parejas de nombres de provincia que tienen algún
-- pueblo que se llama igual, junto con el nombre del pueblo.
select p1.nombre, p2.nombre, l1.pueblo
from provincia p1, provincia p2, localidad l1, localidad l2
where l1.pueblo=l2.pueblo and l1.provincia<>l2.provincia
	and p1.codp=l1.provincia and p2.codp=l2.provincia;
	
-- T11.028- Concatenación natural de artículos y memorias.
select * from articulo natural join memoria;

-- T11.029- Código de artículo, nombre, pvp, marca y tipo de la
-- concatenación natural de artículos y memorias.
select cod, nombre, pvp, marca, tipo
from articulo
natural join memoria;

-- T11.030- Código de artículo, nombre, pvp, marca y tipo de
-- la concatenación natural de artículos y memorias, si el tipo
-- es "Compact Flash".
select cod, nombre, pvp, marca, tipo
from articulo
natural join memoria
where tipo='Compact Flash';

select a.cod, nombre, pvp, marca, tipo
from articulo a, memoria m
where a.cod=m.cod and tipo='Compact Flash';

-- T11.031- Concatenación natural de pedido y linped,
-- ordenado por fecha de pedido.
select * from pedido
natural join linped
order by fecha;

select p.*, l.linea, l.articulo, l.importe, l.cantidad
from pedido p, linped l
where p.numPedido=l.numPedido
order by fecha;

-- T11.032- Comprueba que la concatenación natural de cesta y
-- pack produce un producto cartesiano.
select * from cesta
natural join pack;

-- Dificultad B
-- T11.020- Email y nombre de los usuarios que no han pedido
-- ninguna cámara.
select email, nombre
from usuario u
where email not in (
	select usuario
	from pedido p, linped l
	where p.numpedido=l.numPedido
		and l.articulo in (select cod from camara));
		
-- T11.021- Email y nombre de los usuarios que, habiendo realizado
-- algún pedido, no han pedido ninguna cámara.
select email, nombre
from usuario u, pedido p
where u.email=p.usuario 
	and p.usuario not in(
		select usuario
		from pedido p, linped l
		where p.numPedido=l.numPedido
			and l.articulo in (select cod from camara));
			
-- T11.026- Pedidos (sin duplicados) que incluyen cámaras y
-- televisiones.
select p.*
from pedido p
where numpedido in (
	select numpedido from linped
	where articulo in (select cod from camara))
	and numpedido in (select numpedido from linped
	where articulo in (select cod from tv));
	
-- T11.027- Pedidos (sin duplicados) que incluyen cámaras
-- y objetivos.
select p.*
from pedido p
where numpedido in (
	select numpedido from linped
	where articulo in (select cod from camara))
	and numpedido in (
	select numpedido from linped
	where articulo in (select cod from objetivo));
	
-- T11.001- Listado de los códigos de los artículos Samsung
-- que han sido pedidos.
select distinct articulo
from linped l
where articulo in (select cod from articulo
	where marca like '%Samsung%');

select distinct cod
from articulo a, linped l
where a.cod=l.articulo and marca='Samsung';

-- T11.003- Utilizando operadores de conjuntos obtener el
-- nombre de los usuarios, la localidad y la provincia de los 
-- usuarios que sean de un pueblo que contenga 'San Vicente' o
-- que sean de la provincia de 'Valencia'.
select u.nombre, l.pueblo, p.nombre
from usuario u, provincia p, localidad l
where u.provincia=l.provincia and u.pueblo=l.codm
	and l.provincia=p.codp and l.pueblo like '%San%Vicente%'
union
select u.nombre, l.pueblo, p.nombre
from usuario u, provincia p, localidad l
where u.provincia=l.provincia and u.pueblo=l.codm
	and l.provincia=p.codp and p.nombre like 'Valencia%';
	
-- T11.005- Código, nombre y marca de los objetivos con focales
-- de 500 o 600 mm para las marcas de las que no se ha solicitó
-- ningún artículo en el mes de noviembre de 2010.
select a.cod, nombre, marca
from articulo a
join objetivo o on (a.cod=o.cod)
where (focal='500 mm' or focal='600 mm') 
	and marca not in (
		select marca
		from articulo a, pedido p, linped l
		where a.cod=l.articulo and p.numPedido=l.numPedido
			and year(fecha)=2010 and month(fecha)=11);
			
-- T11.006- Código y pvp de los artículos 'Samsung' que tengan
-- pvp y que no tengan pedidos.
select cod, pvp
from articulo
where marca='Samsung' and pvp is not null
	and cod not in (select articulo from linped);
	
-- T11.008- Utilizando el producto cartesiano, obtener los
-- nombres de las localidades con 2 o más usuarios (sin usar
-- group by).
select distinct l.pueblo
from localidad l, usuario u1, usuario u2
where u1.email<>u2.email
	and l.codm=u1.pueblo and l.codm=u2.pueblo
	and l.provincia=u1.provincia and l.provincia=u2.provincia;
	
select l.pueblo
from usuario u
join localidad l on (l.codm=u.pueblo and l.provincia=u.provincia)
group by l.codm, l.provincia, l.pueblo
having count(*)>1;

-- T11.010- Código y nombre de los artículos, aunque estén
-- repetidos, que aparezcan en un pack o en una cesta.
select cod, nombre
from articulo a, ptienea p
where a.cod=p.articulo
union all
select cod, nombre
from articulo a, cesta c
where a.cod=c.articulo;

-- T11.015- Código y nombre de los artículos que en stock
-- están "Descatalogado" o que no se han solicitado en ningún
-- pedido.
select cod, nombre
from articulo a, stock s
where a.cod=s.articulo and entrega='Descatalogado'
union
select cod, nombre
from articulo
where cod not in (select articulo from linped);

-- T11.016- Email, nombre y apellidos de los usuarios que
-- han solicitado televisores pero nunca han solicitado cámaras.
select email, nombre, apellidos
from usuario u
where email in (
		select usuario
		from pedido p, linped l, tv
		where p.numPedido=l.numPedido and tv.cod=l.articulo)
	and email not in (
		select usuario
		from pedido p, linped l, camara c
		where p.numPedido=l.numPedido and c.cod=l.articulo);
		
-- T11.034- ¿Por qué la concatenación natural de usuario y
-- direnvio resulta en una tabla vacía?
select * from usuario natural join direnvio;