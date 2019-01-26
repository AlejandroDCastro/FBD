use yacv52;

-- Dificultad B
-- T07.001- Crea las siguientes tablas:
create table TA (
	a int,
	b int,
	primary key(a)) engine=innodb;
create table TB (
	c int,
	d int,
	primary key(c),
	foreign key(d) references TA(a) on delete cascade
	on update cascade) engine=innodb;
create table TC (
	e int,
	f int,
	primary key(e),
	foreign key (f) references TB(c) on delete cascade
	on update cascade) engine=innodb;
	
-- T07.002- Inserta los siguientes datos
insert into TA values (1,10);
insert into TA values (2,20);
insert into TA values (3,30);
insert into TB values (100,1);
insert into TB values (200,1);
insert into TB values (300,2);
insert into TB values (400,null);
insert into TC values (1000,100);
insert into TC values (2000,100);
insert into TC values (3000,null);

-- T07.003- Borra TA(2,20) y comprueba los cambios que se han producido en las 3 tablas
delete from TA where a=2; -- se borra la fila TB(300,2) por borrado/propagación
select * from TA;
select * from TB;
select * from TC;

-- T07.004- Modifica TA(1,10) a TA(15,10) y comprueba los cambios que se han producido en las 3 tablas.
update TA set a=15 where a=1; -- se actualizan las filas TB(100,1) y TB(200,1)
select * from TA;					-- por actualización/propagación
select * from TB;
select * from TC;

-- T07.005- Borra TC(2000,100) y comprueba los cambios que se han producido en las 3 tablas.
delete from TC where e=2000;
select * from TA;
select * from TB;
select * from TC;

-- T07.006- Borra TA(3,30) y comprueba los cambios que se han producido en las 3 tablas.
delete from TA where a=3;
select * from TA;
select * from TB;
select * from TC;

-- T07.007- Borra TB(100,15) y comprueba los cambios que se han producido en las 3 tablas.
delete from TB where c=100;
select * from TA;
select * from TB;
select * from TC;

-- T07.008- Borra TC(3000,NULL) y comprueba los cambios que se han producido en las 3 tablas.
delete from TC where e=3000;
select * from TA;
select * from TB;
select * from TC;

-- T07.009- Borra TB(400,NULL) y comprueba los cambios que se han producido en las 3 tablas.
delete from TB where c=400;
select * from TA;
select * from TB;
select * from TC;

-- T07.010- Borra TA(15,10) y comprueba los cambios que se han producido en las
-- 3 tablas: ¿ESTÁN LAS 3 TABLAS VACÍAS?
delete from TA where a=15;
select * from TA;
select * from TB;
select * from TC;

-- T07.011- Vuelve a crear las tablas:
drop table if exists TA;
drop table if exists TB;
drop table if exists TC;
create table TA (
	a int,
	b int,
	primary key(a)) engine=innodb;
create table TB (
	c int,
	d int,
	primary key(c),
	foreign key(d) references TA(a) on delete set null
	on update set null) engine=innodb;
create table TC (
	e int,
	f int,
	primary key(e),
	foreign key (f) references TB(c) on delete set null
	on update set null) engine=innodb;
	
-- T07.012- Vuelve a rellenar las tablas:
insert into TA values (1,10);
insert into TA values (2,20);
insert into TA values (3,30);
insert into TB values (100,1);
insert into TB values (200,1);
insert into TB values (300,2);
insert into TB values (400,null);
insert into TC values (1000,100);
insert into TC values (2000,100);
insert into TC values (3000,null);

-- T07.013- Ejecuta las siguientes órdenes:
delete from TA where a=2;
update TA set a=15 where a=1;
update TB set c=150 where c=100;
select * from TA;
select * from TB;
select * from TC; -- NO

-- T07.014- Vuelve a crear las tablas:
drop table if exists TC;
drop table if exists TB;
drop table if exists TA;
create table TA (
	a int,
	b int,
	primary key(a)) engine=innodb;
create table TB (
	c int,
	d int,
	primary key(c),
	foreign key(d) references TA(a) on delete cascade) engine=innodb;
create table TC (
	e int,
	f int,
	primary key(e),
	foreign key (f) references TB(c)	on update set null) engine=innodb;

insert into TA values (1,10);
insert into TA values (2,20);
insert into TA values (3,30);
insert into TB values (100,1);
insert into TB values (200,1);
insert into TB values (300,2);
insert into TB values (400,null);
insert into TC values (1000,100);
insert into TC values (2000,100);
insert into TC values (3000,null);

-- T07.015- Borra TA(1,10): ¿qué ha pasado?
delete from TA where a=1;
select * from TA;  -- no se puede realizar la operación porque por borrados/propagar
select * from TB;  -- se borrarían las filas de TB (100,1) y (200,1), y la condición
select * from TC;  -- de TB borrados/rechazar lo impediría, y no se haría ninguna acción

-- T07.016- Borra TA(2,20): ¿qué ha pasado?
delete from TA where a=2;
select * from TA;  -- se ha propagado el borrado a la fila (300,2) de TB
select * from TB;
select * from TC;

-- T07.017- Modifica TB(100,1) a TB(170,1): ¿qué ha pasado?
update TB set c=170 where c=100;
select * from TA;  -- se ha anulado las filas TC(1000,100) y TC(2000,100)
select * from TB;  -- al modificarse TB(100,1)
select * from TC;

-- T07.018- Vuelve a intentar borrar TA(1,10): ¿por qué ahora sí?
delete from TA where a=1;
select * from TA;  -- ahora sí porque ya no existía las filas en TC que mantenían
select * from TB;  -- la propiedad borrados/rechazar
select * from TC;