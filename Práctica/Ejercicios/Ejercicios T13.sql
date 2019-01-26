use yacv52;

-- T13.001- Crea una vista (VusuAli) de la delegación de Alicante que
-- permite ver los usuarios de la provincia de Alicante (de código '03').
create or replace view VusuAli as
select * from tiendaonline.usuario where provincia='03';
-- solo hay permisos de lectura

-- T13.002- Con la vista anterior, lista a todos los usuarios de la
-- provincia de Alicante ordenados por apellidos y nombre.
select * from VusuAli
order by apellidos, nombre;

-- T13.003- Con la vista anterior, lista a todos los usuarios de la
-- provincia de Alicante que se llamen Carolina o Iloveny, ordenados
-- por apellidos y nombre.
select * from VusuAli
where nombre in ('Carolina','Iloveny')
order by apellidos, nombre;

-- T13.004- Usando la vista anterior elimina a los usuarios de la
-- provincia de Alicante que se llamen Carolina o Iloveny.
-- ¿Qué ha pasado? ¿Por qué?
delete from VusuAli where nombre in ('Carolina','Iloveny');
-- esta orden falla porque la vista es de la tabla tiendaonline.articulo
-- donde solo tenemos permisos de lectura

-- T13.005- Intenta insertar mediante VusuAli (email,dni,apellidos
-- nombre,provincia,pueblo) 
-- ('rff20@gmial.es','11222333R','FERNANDEZ FERNANDEZ','ROSA','03',
-- '1225')
-- ¿Qué ha pasado? ¿Por qué?
insert into VusuAli (email,dni,apellidos,nombre,provincia,pueblo)
values ('rff20@gmial.es','11222333R','FERNANDEZ FERNANDEZ','ROSA','03','1225');
-- esta orden falla porque no tenemos permisos para insertar, solo consultar

-- T13.006- Crea una vista que nos informe del total del importe a
-- pagar por cada pedido en TIENDAONLINE y su fecha. Comprueba que nos
-- da los datos correctos.
create or replace view Tpedidos as
select p.numPedido, sum(l.importe*l.cantidad) importeTotal,date(fecha)
from tiendaonline.pedido p
join tiendaonline.linped l on (p.numpedido=l.numpedido)
group by 1,3;
select * from Tpedidos;

select p.numPedido, sum(l.importe*l.cantidad) importeTotal,date(fecha)
from tiendaonline.pedido p
join tiendaonline.linped l on (p.numpedido=l.numpedido)
group by 1,3;

-- T13.007- Usando las vistas previas, lista todos los email, nombre y
-- apellidos de usuario de Alicante, y si tienen pedidos también el
-- total pagado por el usuario.
select v.email,v.nombre,v.apellidos, num.total
from VusuAli v
left join (
	select usuario, sum(importeTotal) total
	from tiendaonline.pedido p
	join Tpedidos t on (p.numPedido=t.numPedido)
	group by 1) num
on (v.email=num.usuario);

-- T13.008- Crea otra vista que nos informe del total del importe a
-- pagar por cada pedido hecho por usuarios de Alicante y su fecha
-- (solo fecha).
create or replace view Timportes as
select usuario, p.numpedido, date(fecha), sum(importe*cantidad) importeTotal
from tiendaonline.usuario u
join tiendaonline.pedido p on (p.usuario=u.email)
join tiendaonline.linped l on (l.numPedido=p.numPedido)
where u.provincia='03'
group by 1, 2, 3;
select * from Timportes;

-- T13.009- Usando la nueva vista previa, modifica tu solución anterior
-- y lista todos los email, nombre y apellidos de usuario, y si tienen
-- pedidos también el total pagado por el usuario.
select email, nombre, apellidos, sum(t.importeTotal) pagado
from VusuAli u
left join Timportes t on (t.usuario=u.email)
group by 1, 2, 3;

-- T13.010- Crea en tu base de datos una tabla con la misma estructura
-- que ""TIENDAONLINE.USUARIO"". Tu tabla se llamará ""usuAlm"".
-- CREATE TABLE nombretabla LIKE otratabla crea una nueva tabla
-- (nombretabla) con las columnas de otratabla. Lo único que no se
-- crea en nombretabla son las claves ajenas. 
-- Crea una vista ""VusuAlm"" que permita gestionar (altas, bajas,
-- modificaciones y consultas) a los usuarios de Almería (código '04')
-- y de ninguna otra.
drop table if exists usuAlm;
drop view VusuAlm;
create table usuAlm like tiendaonline.usuario;
create view VusuAlm as
select * from usuAlm where provincia='04' with check option;

-- T13.011- Intenta insertar mediante VusuAlm (email,dni,apellidos,
-- nombre,provincia,pueblo) 
-- ('rgg2@gmial.es','11222333R','GOMEZ GOMEZ','ROSA','04','1002')
-- ¿Qué ha pasado? ¿Por qué?
insert into VusuAlm (email,dni,apellidos,nombre,provincia,pueblo)
values ('rgg2@gmial.es','11222333R','GOMEZ GOMEZ','ROSA','04','1002');
select * from VusuAlm; -- se ha insertado la fila porque la provincia es de Almería
select * from usuAlm; -- se refleja en la tabla creada

-- T13.012- Utilizando VusuAlm elimina todas las posibles filas de
-- usuarios que tengas e inserta en tu tabla USUARIO a estos 2
-- usuarios (email,dni,apellidos,nombre,provincia,pueblo):
-- ('rff20@gmial.es','11222333R','FERNANDEZ FERNANDEZ','ROSA','04','0530')
-- ('jmm119@gmial.es','22333444T','MARTINEZ MARTINEZ','JULIA','04','1002')
delete from VusuAlm;
insert into usuAlm (email,dni,apellidos,nombre,provincia,pueblo) values
('rff20@gmial.es','11222333R','FERNANDEZ FERNANDEZ','ROSA','04','0530');
insert into usuAlm (email,dni,apellidos,nombre,provincia,pueblo) values
('jmm119@gmial.es','22333444T','MARTINEZ MARTINEZ','JULIA','04','1002');
select * from usuAlm;
select * from VusuAlm;

-- T13.013- Intenta insertar mediante VusuAlm
-- (email,dni,apellidos,nombre,provincia,pueblo) 
-- ('rff20@gmial.es','11222333R','FERNANDEZ FERNANDEZ','ROSA','03','1225')
-- ¿Qué ha pasado? ¿Por qué?
insert into VusuAlm (email,dni,apellidos,nombre,provincia,pueblo) values
('rff20@gmial.es','11222333R','FERNANDEZ FERNANDEZ','ROSA','03','1225');
select * from usuAlm; -- el modificador CHECK WITH OPTION no me deja insertar
select * from VusuAlm;-- usuarios que no son de Almería, para esta vista.

-- T13.014- Vas a montar la delegación de Almería. En TIENDAONLINE
-- no hay ningún usuario de esa provincia. La tabla usuarios ya la
-- tienes aunque sin clave ajena a localidad.
-- ALTER TABLE usuario ADD FOREIGN KEY (pueblo, provincia)
-- REFERENCES tiendaonline.localidad (codm,provincia);
-- La orden anterior añade dicha clave ajena. Fíjate que hace
-- referencia la tabla LOCALIDAD en TIENDAONLINE. Eso quiere decir
-- que no necesitas esta tabla en tu base de datos, la vas a manejar mediante vistas.
-- Debes decidir qué tablas necesitas en tu base de datos y cuáles solo vas a
-- utilizar como referencia desde TIENDAONLINE —y no necesitas recrearlas—.
-- Las tablas que necesitas son todas aquellas que necesitas para añadir
-- información de qué compran tus usuarios.
-- Ya tienes 2 usuarios, monta algunos pedidos y cestas para alguno de ellos.
ALTER TABLE usuario ADD FOREIGN KEY (pueblo, provincia)
REFERENCES tiendaonline.localidad (codm,provincia);

-- T13.015- Tienes a tus usuarios de Almería y acceso al resto de usuarios
-- de TIENDAONLINE. Lista el email de todos los usuarios, los de Almería y
-- todos los demás, apellidos, nombre, y nombres de la localidad y provincia
-- en la que viven.
select email, apellidos, u.nombre, codm
from tiendaonline.usuario u
join tiendaonline.localidad l on (u.pueblo=l.codm and u.provincia=l.provincia)
join tiendaonline.provincia p on (p.codp=u.provincia)
union
select email, apellidos, u.nombre, codm
from VusuAlm u
join tiendaonline.localidad l on (u.pueblo=l.codm and u.provincia=l.provincia)
join tiendaonline.provincia p on (p.codp=u.provincia);

-- T13.016- Sobre tu base de datos, redefine TApedidos y muestra todos los
-- email, nombre y apellidos de usuario —en tu caso de Almería— y si tienen
-- pedidos también el total pagado por el usuario.
create or replace view Timportes as
select p.numpedido,sum(importe*cantidad) total,date(fecha),usuario  
from pedido p join linped l on p.numpedido=l.numpedido 
where usuario in (select email from VusuAlm)
group by p.numpedido,date(fecha),usuario;
select * from Timportes;