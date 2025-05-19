****# Total de películas por categoría

select c."name" , count(*)
from category c 
inner join film_category fc on c.category_id  = fc.category_id
inner join film f on f.film_id  = fc.film_id
group by c."name"

# Total de películas por actor

```
select concat(a.first_name,' ', a.last_name), count(*)
from actor a 
inner join film_actor fc on a.actor_id= fc.actor_id 
inner join film f on f.film_id  = fc.film_id
group by concat(a.first_name, ' ', a.last_name)
```

# Total de pagos por cliente

```
select concat(c.first_name,' ', c.last_name), count(*) from payment p 
join customer c on p.customer_id = c.customer_id
group by concat(c.first_name,' ', c.last_name)
```

# Total recaudado por tienda

```
select * from sales_by_store sbs
```

# Mostrar cada actor con JSON de sus películas
```
select a.first_name, json_agg(f.title ) as movies
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on f.film_id  = fa.film_id
group by a.actor_id
```

