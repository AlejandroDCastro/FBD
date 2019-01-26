use tiendaonline;

-- Dificultad 0
-- T02.001- Obtén toda la información de los usuarios
select * from usuarios;

-- T02.011- Marcas
select * from marca;

-- Dificultad 1
-- T02.002- Lista los email y nombre y apellidos de los usuarios
select email, nombre, apellidos
from usuario;

-- T02.003- Lista los email y nombre y apellidos de los usuarios ordenados por email
select email, nombre, apellidos
from usuario
order by email;

-- T02.004- Lista los email y nombre y apellidos de los usuarios ordenados por apellidos y nombre
select email, nombre, apellidos
from usuario
order by apellidos, nombre;

-- T02.005- Lista los email y nombre y apellidos de los usuarios ordenados ascendentemente por apellidos y descendentemente por nombre
select email, nombre, apellidos
from usuario
order by apellidos, nombre DESC;

-- T02.006- Lista los email y nombre y apellidos de los usuarios en orden descendente de apellidos y nombre
select email, nombre, apellidos
from usuario
order by apellidos DESC, nombre DESC;

-- T02.013- Código de los artículos que pertenecen a algún pack.
select articulo from ptienea;

-- T02.016- Código e importe de los artículos solicitados en el pedido número 1.
select articulo, importe
from linped
where numPedido = 1;

-- T02.023- Panel de los televisores de 21 pulgadas o menos de pantalla, eliminando duplicados.
select distinct panel
from tv
where pantalla <= 21;

-- T02.024- Código, nombre, marca y pvp de los artículos que tienen ese precio entre 350 y 450.
select cod, nombre, marca, pvp
from articulo
where pvp >= 350 and pvp <= 450;

-- Dificultad A
-- T02.025- Código, nombre y precio de venta al público de los artículos que no tienen marca.
select cod, nombre, pvp
from articulo
where marca is NULL;

-- T02.026- Código, nombre y precio de venta al público de los artículos que no tienen precio de venta al público y son de marca Sigma.
select cod, nombre, pvp
from articulo
where pvp is NULL and marca = 'Sigma';

-- T02.027- Email, nombre, apellidos y teléfono de los usuarios que se llaman Santiago, Wenceslao o Sergio.
select email, nombre, apellidos, telefono
from usuario
where nombre = 'Santiago' or nombre = 'Wenceslao' or nombre = 'Sergio';

-- T02.028- Email, nombre, apellidos y teléfono de los usuarios que se llaman Santiago, Wenceslao o Sergio y que sí tienen teléfono.
select email, nombre, apellidos, telefono
from usuario
where (nombre = 'Santiago' or nombre = 'Wenceslao' or nombre = 'Sergio')
	and telefono is not NULL;