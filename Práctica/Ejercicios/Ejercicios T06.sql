use yacv52;
 
-- Dificultad A
-- T06.001- Crea una tabla de nombre "xx" con 2 columnas, col1 de tipo integer,
--  y col2 de tipo char(3), con col1 como clave primaria.
create table xx (
	col1 integer,
	col2 char(3),
	primary key (col1)) engine = InnoDB;

-- T06.002- Consulta la tabla
select * from xx;

-- T06.003- Inserta en la tabla la fila (1,’AA’)
insert into xx values (1,'AA');

-- T06.004- inserta en la tabla la fila ('BB',2)
insert into xx (col2,col1) values ('BB',2);

-- T06.005- Inserta en la tabla la fila (2,'BB')
insert into xx values (2,'BB'); -- falla

-- T06.006- Consulta la tabla XX
select * from xx;

-- T06.008- Borra la tabla XX
drop table xx;

-- T06.009- Crea una tabla YY con 3 columnas
create table YY (
	col1 integer,
	col2 char(2),
	col3 varchar(10),
	primary key (col1,col2));
	
-- Inserta los siguientes datos y consulta la tabla para ver los datos almacenados
insert into YY values (1,'AA','primera');
insert into YY values (2,'AA','segunda');
insert into YY values (2,'BB','tercera');
insert into YY values (1,'AA','cuarta'); -- falla
insert into YY values (NULL,NULL,'quinta'); -- falla, MariaDB si que deja
insert into YY values (NULL,'CC','sexta'); -- falla
insert into YY values (3,NULL,'séptima'); -- falla
insert into YY values (0,'','octaba');
insert into YY values (3,'AA',NULL);
select * from YY;

-- T06.011- Ejecuta lo siguiente: 
create table T1(a int,b int,c int, 
primary key(a)) engine=innodb; 
create table T2(a int,d int,e int, 
primary key(d),foreign key(a) references T1(a)) engine=innodb;
-- y comprueba, buscando el porqué en caso de fallo, el resultado de
-- cada una de las órdenes de la siguiente secuencia:
insert into T1 values (1,10,100);
insert into T1 values (null,20,null); -- falla porque hay nulos en CP
insert into T1 values (2,20,null);
insert into T1 values (3,null,300);
insert into T2 values (2,null,null); -- falla porque hay null en CP
insert into T2 values (2,20,NULL);
insert into T1 values (1,20,200); -- falla porque se repite valor de CP
insert into T2 values (4,10,100); -- falla porque se mantiene la integridad referencial
insert into T2 values (2,30,230);
SELECT * from T1;
SELECT * from T2;

-- T06.012- Continúa el anterior
update T1 set a=2 where a=1; -- falla porque se repite CP
update T1 set a=5 where a=1;
update T2 set e=220 where d=20;
update T2 set a=5 where d=20;
update T2 set a=2,d=10,e=100 where d=20;
update T1 set a=6,b=60,c=600 where a=2; -- falla porque se mantiene la integridad referencial
update T1 set a=7,b=70,c=700 where a=3;
update T2 set a=7 where d=10;
update T2 set a=7 where d=30;
update T1 set a=6,b=60,c=600 where a=2;

-- T06.013- Continúa el anterior
delete from T2 where d=30;
delete from T1 where a=7; -- falla porque 7 de t2 apunta a t1 integridad referencial
delete from T1 where a=5;
delete from T2 where d=10;
delete from T1 where a=7;
delete from T1 where a=6;
SELECT * from T1;
SELECT * from T2;