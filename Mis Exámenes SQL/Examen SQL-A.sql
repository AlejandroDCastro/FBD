USE tiendaonline;

-- Nombre de los artículos cuyo nombre empieza por "UE" o por "LE".
SELECT nombre
FROM articulo
WHERE nombre LIKE 'UE%' OR nombre LIKE 'LE%';

-- Montura y focal de los objetivos de la marca Sigma
-- que tiene precio de venta al público entre 200 y 300€, eliminando duplicados.

SELECT DISTINCT montura, focal
FROM objetivo o, articulo a
WHERE o.cod=a.cod AND marca='Sigma' AND pvp BETWEEN 200 AND 300;