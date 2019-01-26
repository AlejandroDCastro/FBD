-- Código y sensor de las cámaras de cualquier tipo de "compacta", 
-- y si tienen información de stock mostrar también la cantidad disponible.
select cod, sensor, s.disponible
from camara c
left join stock s on (c.cod=s.articulo)
where tipo like '%compacta%';


-- a) Crea una tabla: TA(a int, b int, c int) CP(a)
-- b) Crea una tabla: TB(d int, e int) CP(d) CAj(e)>>TA, borrados propagar, modificaciones anular
-- c) Inserta en TA las filas: (a=3,c=10), (a=2,c=20);
-- d) Inserta en TB el contenido de TA, almacenando en TB.d los valores de la columna TA.c, y en TB.e lo que haya en la columna TA.a, con una única instrucción a partir de una consulta sobre TA.
-- e) Eliminar las dos tablas.
create table TA (
	a int,
	b int,
	c int,
	primary key(a)) engine=innodb;
	
create table TB (
	d int,
	e int,
	primary key (d),
	foreign key (e) references TA (a) on delete cascade
		on update set null) engine=innodb;
		
insert into TA (a,c) values (3,10);
insert into TA (a,c) values (2,20);

insert into TB (d,e) select c,a from TA;

drop table TB;
drop table TA;