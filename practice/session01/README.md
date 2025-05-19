# Monto total pagado por cada cliente
```
select c.first_name, sum(p.amount)
from payment p
inner join customer c on p.customer_id = c.customer_id
group by c.customer_id
order by sum(p.amount) desc
```

# Clientes que han pagado más de $200

```
select c.first_name,  sum(p.amount)
from payment p
inner join customer c on p.customer_id = c.customer_id
group by c.customer_id
having sum(p.amount ) >=200
```
# Cantidad de películas por categoría y promedio de duración
```
select c."name" , count(*), AVG(f.length)
from film f
inner join film_category fc  on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id 
group by c.category_id
```
# JSON de películas por categoría
```
select c."name" , json_agg(f.title)
from film f
inner join film_category fc  on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id 
group by c.category_id
```

