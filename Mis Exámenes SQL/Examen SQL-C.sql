use tiendaonline;

-- Por cada pedido, número de pedido y máximo, mínimo y promedio de importe
-- unitario de pedido, siempre y cuando el promedio sea menor que 400 ordenado
-- de mayor a menor valor promedio.
select numpedido, max(importe), min(importe), avg(importe)
from linped
group by 1
having avg(importe) < 400
order by avg(importe) desc;

-- De los pedidos con líneas de pedido, año, cantidad de pedidos por año e,
-- igualmente, importe total de todos esos pedidos en ese año, ordenado
-- descendentemente por ese importe total.
select year(fecha), count(distinct l.numPedido) pedidos, sum(importe*cantidad) importeTotal
from pedido p
join linped l on (l.numPedido=p.numPedido)
group by 1
order by sum(importe*cantidad) desc;