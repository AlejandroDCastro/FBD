use ejemplo;

-- ES01.01- Muestra toda la información de los profesores
select * from profesores;

-- ES01.02- Muestra toda la información de las asignaturas
select * from asignaturas;

-- ES01.03- Muestra toda la información de la tabla imparte
select * from imparte;

-- ES01.04- Obtén la categoria de los profesores
select categoria from profesores;

-- ES01.05- Lista el nombre y la categoría de los profesores
select nombre, categoria from profesores;

-- ES01.06- Obtén las categorías de los profesores sin duplicados
select distinct categoria from profesores;

-- ES01.07- Obtener el nombre de los profesores titulares (TEU)
select nombre from profesores where categoria = 'TEU';

-- ES01.08- Nombre de los profesores que son titulares (TEU) o asociados a 6 horas (ASO6)
select nombre from profesores where categoria = 'TEU' or categoria = 'ASO6';