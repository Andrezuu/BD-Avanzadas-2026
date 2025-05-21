#  Funciones 

## Duración promedio de las películas
```
CREATE OR REPLACE FUNCTION fn_avg_duracion()
RETURNS NUMERIC AS $$
DECLARE
  avg_ NUMERIC;
BEGIN
  SELECT avg(f.length) INTO avg_
  FROM film f;
  RETURN COALESCE(avg_, 0);
END;
$$ LANGUAGE plpgsql;

select fn_avg_duracion();	
```

## Categoría favorita de un cliente
Devuelve la categoria mas alquilada por un customer_id
```
create or replace function fn_favorite_category(customer_id_ int)
returns text as $$
declare
	category_ text;
begin
	select cat."name" into category_
	from customer c
	inner join rental r on r.customer_id = c.customer_id
	inner join inventory i on i.inventory_id = r.inventory_id
	inner join film f on i.film_id = f.film_id
	inner join film_category fc on fc.film_id = f.film_id
	inner join category cat on cat.category_id = fc.category_id
	where c.customer_id = customer_id_
	group by cat.name
	order by count(*) desc
	limit 1;

	return coalesce(category_, '');
end;
$$ language plpgsql;

select fn_favorite_category(1)
```

## Pagos por cliente y mes
Funcion que reciba un customer_id y devuelva una tabla con mes y total pagado.
```
create or replace function fn_monthly_payments_by_customer_id(customer_id_ int)
returns table(month timestamp, amount numeric) as $$
begin
	return query
	select date_trunc('month',p.payment_date) as month, sum(p.amount) as total
	from payment p 
	where p.customer_id = customer_id_
	group by month;
end;
$$ language plpgsql;

select * from fn_monthly_payments_by_customer_id(1)
```

## Clientes sin alquiler en los últimos 3 meses
Funcion sin parametros que retorne customer_id nombre de los inactivos.
```
create or replace function fn_get_inactive()
returns table(customer_id int, full_name text) as $$
begin
	return query
	select c.customer_id, concat(c.first_name, ' ', c.last_name) as fullname
	from customer c
	left join rental r on r.customer_id = c.customer_id
	where r.rental_date < now() - interval '3 months';
end;
$$ language plpgsql;

select * from fn_get_inactive()
```

# Triggers 

## Auditoría de actualización
Crear un trigger que registre cada vez que se actualice un cliente.
Use RAISE NOTICE
Imprima el nombre completo del cliente y su nuevo correo electrónico (NEW.email)
```
create or replace function fn_update_client_log()
returns trigger as $$
begin
	raise notice '% con nuevo email: %', concat(new.first_name, ' ', new.last_name), new.email;
	return new;
end;
$$ language plpgsql;


create trigger trg_update_client_log
before update on customer
for each row 
execute function fn_update_client_log();

update customer 
set email = 'a@a.com'
where c.customer_id = 1

```

## Log de inserciones de películas
Mostrar mensaje cuando se registre una nueva película.
AFTER INSERT
"Nueva película: [title] fue registrada con rating [rating]"
```
create or replace function fn_create_film_log()
returns trigger as $$
begin
	raise notice 'Nueva película: % fue registrada con rating %', new.title, new.rating;
	return new;
end;
$$ language plpgsql;

create trigger trg_create_film_log
after insert on film
for each row 
execute function fn_create_film_log();

INSERT INTO film (
    title,
    description,
    release_year,
    language_id,
    rental_duration,
    rental_rate,
    length,
    replacement_cost,
    rating,
    special_features,
    fulltext
)
VALUES (
    'The Matrix',
    'A computer hacker learns about the true nature of reality and his role in the war against its controllers.',
    2000,
    1,                   
    5,
    3.99,
    136,
    14.99,
    'R',
    ARRAY['Deleted Scenes', 'Behind the Scenes'],
    to_tsvector('english', 'The Matrix computer hacker reality war controllers')
);
```

## Historial de eliminaciones
Al eliminar un staff, insertar una fila en una tabla staff_deleted_log.

Crea una tabla staff_deleted_log con los campos:

staff_id, first_name, last_name, deleted_at

Crea un trigger AFTER DELETE que:

Inserte en staff_deleted_log

Use los valores de OLD


```
create table staff_deleted_log(
	staff_id int,
	first_name text,
	last_name text,
	deleted_at timestamp default now()
	)

	
create or replace function fn_staff_deleted_log()
returns trigger as $$ 
begin
	insert into staff_deleted_log
	values (old.staff_id, old.first_name, old.last_name, now());
	raise notice 'Staff % agregado al deleted log', old.staff_id;
	return null;
end;
$$ language plpgsql;


create trigger trg_staff_deleted_log
after delete on staff
for each row
execute function fn_staff_deleted_log();
```
