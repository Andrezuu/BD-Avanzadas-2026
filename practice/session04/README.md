## Listar las 10 Peliculas mas alquiladas 
Usando transacciones read commited listar las peliculas mas alquiladas 
(Verificar en otra transaccion si hubiera cambio de peliculas y cambia el ranking)
primera
```
begin;
elect f.film_id, f.title, count(*)
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id
order by count(*) desc
limit 10;
commit;
```

segunda
```
begin;

INSERT INTO rental (
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id
) VALUES (
    '2025-05-22 14:30:01',  -- rental_date
    3360,                      -- inventory_id (debe coincidir con el valor generado en el insert anterior)
    5,                      -- customer_id (debe existir en la tabla customer)
    '2025-05-25 18:45:00',  -- return_date
    2                       -- staff_id (debe existir en la tabla staff)
);

select f.film_id, f.title, count(*)
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on r.inventory_id = i.inventory_id
group by f.film_id
order by count(*) desc
limit 10;
commit;
```


## Registrar y confirmar un pago del customer

Con transacciones insertar un nuevo pago en caso de el monto es negativo hacer rollback 
```


create or replace procedure neg_amount(id in numeric, amount in numeric)
language plpgsql as $$
begin
	insert into payment values (id,1,1,1,amount, now());
	if amount < 0 then
		rollback;
		raise notice 'Payment no creado';
	else 

		commit;
		raise notice 'Payment creado';
	end if;
end;

$$;


call neg_amount(34005, 29)
```

## Crear y anular una pelicula nueva 

Insertar una pelicula o eliminar si hubiera un error 
(Verificar si 2 staffs agregan la misma pelicula )

## Ranking de Clientes

<<<<<<< HEAD
Ver el ranking de los 20 mejores clientes usando **Srializable** provocar un error para que se bloquee una transaccion. 
=======
Ver el ranking de los 20 mejores clientes usando Srializable provocar un error para que se bloquee una transaccion. 
```
-- primera

begin transaction isolation level serializable;
INSERT INTO rental (
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id
) VALUES (
    '2025-05-22 14:30:24',  -- rental_date
    3360,                      -- inventory_id (debe coincidir con el valor generado en el insert anterior)
    526,                      -- customer_id (debe existir en la tabla customer)
    '2025-05-25 18:45:44',  -- return_date
    2                       -- staff_id (debe existir en la tabla staff)
);
commit;

-- segunda

begin transaction isolation level serializable;
select c.customer_id, c.first_name, count(*)
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join customer c on c.customer_id = r.customer_id 
group by c.customer_id
order by count(*) desc
limit 20;
INSERT INTO rental (
    rental_date,
    inventory_id,
    customer_id,
    return_date,
    staff_id
) VALUES (
    '2025-05-22 14:30:24',  -- rental_date
    3360,                      -- inventory_id (debe coincidir con el valor generado en el insert anterior)
    526,                      -- customer_id (debe existir en la tabla customer)
    '2025-05-25 18:45:44',  -- return_date
    2                       -- staff_id (debe existir en la tabla staff)
);
commit;
```
>>>>>>> 14dd359 (transactions)
