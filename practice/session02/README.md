 Ejercicios Propuestos

## Contar películas por categoría
Crea un procedimiento que reciba el nombre de una categoría (IN) y devuelva la cantidad de películas (OUT).
```
CREATE OR REPLACE PROCEDURE (
    category IN text
    amount OUT int
)
LANGUAGE plpgsql AS $$
BEGIN
  select c."name" , count(*), AVG(f.length)
from film f
inner join film_category fc  on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id 
where c.name = category
group by c.category_id
END;
$$;

```

## Listar películas por actor
Crea un SP que reciba el actor_id y muestre los títulos de las películas donde participó (usando RAISE NOTICE o PERFORM).
```
create or replace procedure EJ2 (
	id in int
)
language plpgsql as $$
declare
 row record;
begin 
	select concat(a.first_name, ' ', a.last_name) as name, json_agg(f.title) as movies
	from actor as a
	inner join film_actor as fa on fa.actor_id = a.actor_id
	inner join film as f on f.film_id = fa.film_id
	where a.actor_id = id
	group by a.actor_id 
	into row;
	raise notice '% participa en', row.name;
	raise notice '%', row.movies;
end;
$$;

call EJ2(2)
```

## Total de pagos de un cliente
Crea un SP que reciba el customer_id y devuelva el total que ha pagado (OUT).
```
create or replace procedure EJ3 (
	id in int,
	total out numeric
)
language plpgsql as $$
declare
 row record;
begin
	select sum(p.amount) into total
	from payment p
	where p.customer_id = id;
end;
$$;

call EJ3(6, 0)
```

## Activar clientes con pagos
Dado un store_id (IN), activa todos los clientes que hayan hecho al menos un pago.
```
create or replace procedure ej4(
	storeId in int
)
language plpgsql as $$
declare 
	row record;
begin
 for row in
	select concat(c.first_name, ' ', c.last_name) as name, c.customer_id, s.store_id, count(*) as payments
	from customer c
	inner join store s on s.store_id = c.store_id
	inner join payment p on p.customer_id = c.customer_id
	where s.store_id = storeId
	group by c.customer_id, s.store_id
 loop
	if row.payments > 0 then

		update customer c 
		set active = 0
		where c.customer_id = row.customer_id;
	else
		update customer c 
		set active = 0
		where c.customer_id = row.customer_id;
	end if;
 end loop;
end;
$$;

call ej4(2)
```

## Reactivar clientes inactivos
SP que toma un cliente por customer_id, lo activa y registra un mensaje de auditoría usando RAISE NOTICE.
```
create or replace procedure ej5(
	customerId in int
)
language plpgsql as $$
begin
	update customer c
	set active = 1
	where c.customer_id = customerId;
	raise notice 'Activando customer %', customerId;
	
end;
$$;

call ej5(5)
```

