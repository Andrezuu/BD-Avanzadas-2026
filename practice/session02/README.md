# Ejercicios Propuestos

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

## Total de pagos de un cliente
Crea un SP que reciba el customer_id y devuelva el total que ha pagado (OUT).

## Activar clientes con pagos
Dado un store_id (IN), activa todos los clientes que hayan hecho al menos un pago.

## Reactivar clientes inactivos
SP que toma un cliente por customer_id, lo activa y registra un mensaje de auditoría usando RAISE NOTICE.

