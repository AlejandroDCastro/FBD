use tiendaonline;

-- Dificultad A
-- T12.001- Días que han pasado entre el primer y último pedido.
select datediff(max(fecha),min(fecha)) dias
from pedido;

select datediff(u,p) dias
from
	(select min(date(fecha)) p from pedido) as primer,
	(select max(date(fecha)) u from pedido) as ulti;

select datediff (
	(select max(date(fecha)) u from pedido),
	(select min(date(fecha)) u from pedido)
) dias;

-- T12.002- Calcula y muestra la cantidad de televisores, cámaras y objetivos
-- almacenados en la base de datos.
select
	(select count(*) from tv) as televisores,
	(select count(*) from camara) as camaras,
	(select count(*) from objetivo) as objetivos;
	
-- T12.003- Calcula y muestra el porcentaje de televisores, cámaras y
-- objetivos sobre el total de artículos almacenados en la base de datos.
select (tel/tot*100) televisoresP, (cam/tot*100) camarasP, (obj/tot*100) objetivosP
from
	(select count(*) tot from articulo) as total,
	(select count(*) tel from tv) as teles,
	(select count(*) cam from camara) as camaras,
	(select count(*) obj from objetivo) as objetivos;
	
select
	(select count(*) from tv)/(select count(*) from articulo)*100 teles,
	(select count(*) from camara)/(select count(*) from articulo)*100 camaras,
	(select count(*) from objetivo)/(select count(*) from articulo)*100 objetivos;

-- Dificultad B
-- T12.007- Provincias y cantidad de pedidos servidos en ellas, para aquellas
-- provincias con un promedio de importe total de sus pedidos por encima de 2500 €.
select provincia,count(*) pedidos
from usuario u, 
 (select usuario,p.numpedido,sum(importe*cantidad) total
  from pedido p join linped l on (p.numpedido=l.numpedido)
  group by usuario,numpedido) pd
where u.email=pd.usuario 
group by provincia
having avg(total)>2500;

-- T12.008- Nombre de las localidades de los usuarios que han hecho 2 pedidos
-- o más. Elimina duplicados.
select distinct l.pueblo
from localidad l, usuario u,
	(select usuario
	from pedido p
	group by 1
	having count(distinct p.numpedido)>1) as pediguenos
where u.provincia=l.provincia and l.codm=u.pueblo
	and u.email=pediguenos.usuario;
	
select distinct l.pueblo 
from usuario u, localidad l 
where u.pueblo = l.codm and u.provincia=l.provincia
  and email in (select usuario
                from pedido p
                group by usuario
                having count(*)>=2);
                
-- T12.004- Email, nombre y apellidos de los usuarios de la provincia 03, y si
-- tienen un pedido cuyo importe total sea mayor que 10000€, mostrar también
-- el número de pedido y ese importe; ordena la salida descendentemente por el
-- valor del pedido.
-- Comienza resolviendo número de pedido, usuario e importe total de los pedidos
-- valorados en más de 10000€ y utiliza el resultado como tabla temporal.
select email, nombre, apellidos, numpedido, total
from usuario u
left join (
	select l.numpedido, usuario, sum(importe*cantidad) total
	from pedido p join linped l on (l.numPedido=p.numPedido)
	group by 1, 2
	having sum(importe*cantidad) > 10000) as ricos
on (u.email=ricos.usuario)
where provincia='03'
order by total desc;

-- T12.005- De los usuarios que tengan algún pedido sin líneas de pedido y
-- artículos pendientes de solicitud en alguna cesta, mostrar su email, nombre,
-- apellidos, número del pedido sin líneas, y valor total de su cesta. 
-- Comienza resolviendo pedidos sin líneas y valor de la cesta por usuario y
-- utiliza los resultados como tablas temporales.
select email,nombre, apellidos,numpedido, pendiente
from usuario u,
  (select numpedido,usuario
   from pedido  
   where numpedido not in (select numpedido from linped)
  ) pedidos,
  (select usuario,sum(pvp) pendiente
   from cesta c, articulo a
   where c.articulo=a.cod
   group by usuario
  ) cestas
where email=pedidos.usuario and email=cestas.usuario;

-- T12.006- Para aquellos usuarios que tengan más de un pedido en 2010, obtener
-- una tabla donde cada columna se corresponda con un mes del año y muestre la
-- cantidad de pedidos realizada por ese usuario en ese mes. Cada fila empieza
-- por el email, nombre y apellidos del usuario.
select email, nombre, apellidos,
	(select count(*) from pedido where month(fecha)=01 and year(fecha)=2010 and usuario=email) enero,
	(select count(*) from pedido where month(fecha)=02 and year(fecha)=2010 and usuario=email) febrero,
	(select count(*) from pedido where month(fecha)=03 and year(fecha)=2010 and usuario=email) marzo,
	(select count(*) from pedido where month(fecha)=04 and year(fecha)=2010 and usuario=email) abril,
	(select count(*) from pedido where month(fecha)=05 and year(fecha)=2010 and usuario=email) mayo,
	(select count(*) from pedido where month(fecha)=06 and year(fecha)=2010 and usuario=email) junio,
	(select count(*) from pedido where month(fecha)=07 and year(fecha)=2010 and usuario=email) julio,
	(select count(*) from pedido where month(fecha)=08 and year(fecha)=2010 and usuario=email) agosto,
	(select count(*) from pedido where month(fecha)=09 and year(fecha)=2010 and usuario=email) septiembre,
	(select count(*) from pedido where month(fecha)=10 and year(fecha)=2010 and usuario=email) octubre,
	(select count(*) from pedido where month(fecha)=11 and year(fecha)=2010 and usuario=email) noviembre,
	(select count(*) from pedido where month(fecha)=12 and year(fecha)=2010 and usuario=email) diciembre
from usuario
where email in (select usuario from pedido where year(fecha)=2010 group by 1 having count(*)>1);