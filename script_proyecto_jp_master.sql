--1. Crea el esquema de la BBDD.

--Hecho


-- Los primeros ejercicios no funcionan porque en ejercicios posteriores
-- se pedía cambiar de nombre ciertas columnas, con las siguientes consultas
-- se pone correctamente para que funcionen estos primeros ejercicios
select * from actor;
alter table actor rename column Nombre to first_name;
alter table actor rename column Apellido to last_name;


--2. Muestra los nombres de todas las películas con una clasificación por
--edades de ‘R’.

select title,rating from "film"
where "rating" = 'R';

--3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30
--y 40.

select actor_id,first_name from actor
where actor_id between 30 and 40;


--4. Obtén las películas cuyo idioma coincide con el idioma original.

select original_language_id from film
where original_language_id is not null;

select title
from film f
where f.language_id = f.original_language_id


--5. Ordena las películas por duración de forma ascendente.

select * from film
order by length asc;

--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su
--apellido.

select first_name,last_name from actor
where last_name like '%ALLEN%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla
--“film” y muestra la clasificación junto con el recuento.

select f.rating,COUNT(f.film_id) from film f
inner join film_category fc
on f.film_id = fc.film_id
group by f.rating
;

--8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
--duración mayor a 3 horas en la tabla film.

select title,length,rating from film
where length >= 180
or rating = 'PG-13';


--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select variance(replacement_cost) 
as "variabilidad_reemplazo"
from film;

--10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select MAX(length) as "mayor_duración", MIN(length) as "menor_duración"
from film;

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

select title,last_update from film
order by last_update asc limit 1 offset 2;

--12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC17’ ni ‘G’ en cuanto a su clasificación.

select * from "film"
where rating != 'NC-17'
and rating != 'G';

--13. Encuentra el promedio de duración de las películas para cada
--clasificación de la tabla film y muestra la clasificación junto con el
--promedio de duración.

select rating,avg(length) as "promedio_duracion" 
from film f 
group by rating;

--14. Encuentra el título de todas las películas que tengan una duración mayor
--a 180 minutos.

select title,length from film
where length >= 180;

--15. ¿Cuánto dinero ha generado en total la empresa?

select SUM(amount) as "ingresos_empresa" from payment;

--16. Muestra los 10 clientes con mayor valor de id.

select * from customer
order by customer_id desc
limit 10;

--17. Encuentra el nombre y apellido de los actores que aparecen en la
--película con título ‘Egg Igby’.

select a.first_name, a.last_name, f.title from actor a 
inner join film_actor fa 
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id = f.film_id
where f.title like 'EGG IGBY';


--18. Selecciona todos los nombres de las películas únicos.

select distinct(f.title) from film f;

--19. Encuentra el título de las películas que son comedias y tienen una
--duración mayor a 180 minutos en la tabla “film”.

select f.title,c.name from film f 
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on c.category_id  = fc.category_id
where c.name like 'Comedy';

--20. Encuentra las categorías de películas que tienen un promedio de
--duración superior a 110 minutos y muestra el nombre de la categoría
--junto con el promedio de duración.

select c.name, AVG(f.length)
from film f 
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on c.category_id  = fc.category_id
group by c."name"
having AVG(f.length) >=110;


--21. ¿Cuál es la media de duración del alquiler de las películas?

select AVG(return_date - rental_date) as "duración_alquiler_promedio" from rental;


--22. Crea una columna con el nombre y apellidos de todos los actores y
--actrices.

select CONCAT(first_name, ' ', last_name) as nombre_completo from actor;


--23. Números de alquiler por día, ordenados por cantidad de alquiler de
--forma descendente.

select DATE(rental_date) as dia, COUNT(*) as cantidad
from rental
group by DATE(rental_date)
order by dia;

--24. Encuentra las películas con una duración superior al promedio.

select f.title, f.length from film f
where f.length > (
	select AVG(f.length)from film f
);


--25. Averigua el número de alquileres registrados por mes.

select 
	date_trunc('month', rental_date) AS mes,
	COUNT(*) as cantidad_alquileres
from rental
group by mes;


--26. Encuentra el promedio, la desviación estándar y varianza del total
--pagado.

select 
	AVG(amount) as "promedio", 
	stddev(amount) as "desviacion_estandar", 
	VARIANCE(amount) as "varianza" 
from payment;

--27. ¿Qué películas se alquilan por encima del precio medio?

select f.title, p.amount from film f
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on r.inventory_id = i.inventory_id
inner join payment p
on p.rental_id = r.rental_id;

--28. Muestra el id de los actores que hayan participado en más de 40
--películas.

select a.first_name , COUNT(a.actor_id) from actor a
inner join film_actor fa
on a.actor_id = fa.actor_id
group by a.actor_id 
having COUNT(a.actor_id) >= 40;


--29. Obtener todas las películas y, si están disponibles en el inventario,
--mostrar la cantidad disponible.


select f.title, COUNT(f.film_id ) from inventory i
inner join film f
on i.film_id = f.film_id
group by f.film_id
order by COUNT(f.film_id ) DESC
;

--30. Obtener los actores y el número de películas en las que ha actuado.

select 
	a.first_name,
	a.last_name,
	COUNT(f.film_id) as "cantidad_peliculas"
from actor a
inner join film_actor f on a.actor_id = f.actor_id
group by a.actor_id, a.first_name, a.last_name
order by cantidad_peliculas DESC;


--31. Obtener todas las películas y mostrar los actores que han actuado en
--ellas, incluso si algunas películas no tienen actores asociados.

select f.*, a.first_name, a.last_name from film f
left join film_actor fa 
on f.film_id = fa.film_id
left join actor a 
on a.actor_id = fa.actor_id
order by f.film_id;


--32. Obtener todos los actores y mostrar las películas en las que han
--actuado, incluso si algunos actores no han actuado en ninguna película.

select a.first_name, a.last_name, f.title from actor a
left join film_actor fa 
on a.actor_id = fa.actor_id
left join film f
on fa.film_id  = f.film_id;


--33. Obtener todas las películas que tenemos y todos los registros de
--alquiler.

select f.*, r.* from film f, rental r;

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

select c.first_name ,c.last_name ,SUM(p.amount) from payment p
inner join customer c
on p.customer_id = c.customer_id
group by c.customer_id
order by SUM(p.amount) desc
limit 5;

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

select a.* from actor a
where a.first_name like 'JOHNNY';

--36. Renombra la columna “first_name” como Nombre y “last_name” como
--Apellido.
 
alter table actor rename column first_name to Nombre;
alter table actor rename column last_name to Apellido;

-- Para devolverlo a su estado original y que funcionen el resto de ejercicios
select * from actor;
alter table actor rename column Nombre to first_name;
alter table actor rename column Apellido to last_name;
 

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select MIN(a.actor_id), MAX(a.actor_id) from actor a;

--38. Cuenta cuántos actores hay en la tabla “actor”.

select COUNT(*) from actor;

--39. Selecciona todos los actores y ordénalos por apellido en orden
--ascendente.

select a.* from actor a
order by a.apellido asc;

--40. Selecciona las primeras 5 películas de la tabla “film”.

select * from film f 
limit 5;

--41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
--mismo nombre. ¿Cuál es el nombre más repetido?

select a.nombre ,COUNT(*) from actor a
group by a.nombre
order by COUNT(*) DESC
;

--42. Encuentra todos los alquileres y los nombres de los clientes que los
--realizaron.

select c.first_name, c.last_name, r.* from rental r
inner join customer c 
on r.customer_id = c.customer_id
;

--43. Muestra todos los clientes y sus alquileres si existen, incluyendo
--aquellos que no tienen alquileres.

select c.first_name, c.last_name, r.* from customer c
left join rental r 
on c.customer_id = r.customer_id
;

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
--esta consulta? ¿Por qué? Deja después de la consulta la contestación.

select f.title, c."name" from film f 
cross join category c;
--No tiene sentido esta consulta, nos devuelve todas las posibles combinaciones
--entre películas y géneros, no nos dice a qué género pertenece cada película


--45. Encuentra los actores que han participado en películas de la categoría
--'Action'.

select a.nombre, a.apellido, c.name from actor a
inner join film_actor fa 
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id = f.film_id
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on fc.category_id = c.category_id
where c."name" like 'Action'
;


--46. Encuentra todos los actores que no han participado en películas.

select a.* from actor a
where a.actor_id not in (
select fa.actor_id from film_actor fa 
);


--47. Selecciona el nombre de los actores y la cantidad de películas en las
--que han participado.

select a.nombre,a.apellido, COUNT(*) from actor a
inner join film_actor fa 
on a.actor_id = fa.actor_id
group by a.nombre, a.apellido;


--48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres
--de los actores y el número de películas en las que han participado.
create view "actor_num_peliculas" as
select a.nombre, a.apellido, f.title from actor a
inner join film_actor fa 
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id  = f.film_id;

--49. Calcula el número total de alquileres realizados por cada cliente.

select c.first_name , c.last_name ,COUNT(r.rental_id) from rental r
inner join customer c
on r.customer_id = c.customer_id
group by c.customer_id
order by COUNT(r.rental_id ) DESC
;

--50. Calcula la duración total de las películas en la categoría 'Action'.

select SUM(f.length ) as "duración_total" from film f
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on fc.category_id = c.category_id
where c."name" = 'Action'
;

--51. Crea una tabla temporal llamada “cliente_rentas_temporal” para
--almacenar el total de alquileres por cliente.

create temporary table "cliente_rentas_temporal" as
select c.first_name , c.last_name , COUNT(r.rental_id) from rental r
inner join customer c
on r.customer_id = c.customer_id 
group by c.customer_id;

--52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las
--películas que han sido alquiladas al menos 10 veces.

create temporary table "peliculas_alquiladas" as
select f.title, COUNT(f.film_id) from film f
inner join inventory i
on f.film_id = i.inventory_id
inner join rental r
on i.inventory_id = r.inventory_id
group by f.film_id
having COUNT(f.film_id) >= 2 -- Lo pongo a 2 para que salgan más resultados
;

--53. Encuentra el título de las películas que han sido alquiladas por el cliente
--con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
--los resultados alfabéticamente por título de película.

select title,c.first_name,c.last_name, r.rental_id, r.rental_date, r.return_date from film f
inner join inventory i 
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
inner join customer c
on r.customer_id = c.customer_id
where c.first_name  like 'TAMMY'
and c.last_name like 'SANDERS'
order by f.title
;
-- No veo algún campo de devuelto o alguna fecha que restar como 
-- return_date - last_update, ya que last_update es de 2006 y 
-- return_date es de 2005, no lo pueden devolver un año después



--54. Encuentra los nombres de los actores que han actuado en al menos una
--película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
--alfabéticamente por apellido.

select a.nombre, a.apellido , c."name" from actor a
inner join film_actor fa
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id = f.film_id
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on fc.category_id = c.category_id
where c."name" like 'Sci-Fi'
order by a.nombre, a.apellido
;


--55. Encuentra el nombre y apellido de los actores que han actuado en
--películas que se alquilaron después de que la película ‘Spartacus
--Cheaper’ se alquilara por primera vez. Ordena los resultados
--alfabéticamente por apellido.

select distinct a.nombre, a.apellido from actor a
inner join film_actor fa 
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id = f.film_id
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on r.inventory_id = i.inventory_id
where r.rental_date > (
 	select MIN(r2.rental_date)
 	from film f2
 	inner join inventory i2 on f2.film_id = i2.film_id
 	inner join rental r2 on i2.inventory_id = r2.inventory_id
 	where f2.title = 'SPARTACUS CHEAPER'
)
order by a.apellido
;

--56. Encuentra el nombre y apellido de los actores que no han actuado en
--ninguna película de la categoría ‘Music’.

select distinct a.nombre, a.apellido from actor a
inner join film_actor fa
on a.actor_id = fa.actor_id
inner join film f
on fa.film_id = f.film_id
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c
on fc.category_id = c.category_id
where c."name" != 'Music'
;

--57. Encuentra el título de todas las películas que fueron alquiladas por más
--de 8 días.

select f.title, r.rental_date, r.return_date from film f
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
where return_date - rental_date >= INTERVAL '8 days';


--58. Encuentra el título de todas las películas que son de la misma categoría
--que ‘Animation’.

select f.title, c."name" from film f
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on fc.category_id = c.category_id
where c."name" = 'Animation';

--59. Encuentra los nombres de las películas que tienen la misma duración
--que la película con el título ‘Dancing Fever’. Ordena los resultados
--alfabéticamente por título de película.

select f.title, f.length from film f
where f.length = (
	select f.length from film f
	where f.title = 'DANCING FEVER'
);

--60. Encuentra los nombres de los clientes que han alquilado al menos 7
--películas distintas. Ordena los resultados alfabéticamente por apellido.

select c.first_name, c.last_name, COUNT(r.customer_id) from customer c
inner join rental r
on c.customer_id = r.customer_id
group by c.first_name, c.last_name
having COUNT(r.customer_id) >= 7
order by COUNT(r.customer_id) ASC
;


--61. Encuentra la cantidad total de películas alquiladas por categoría y
--muestra el nombre de la categoría junto con el recuento de alquileres.

select c."name" ,count(r.rental_id) from film f
inner join inventory i
on f.film_id = i.film_id
inner join rental r 
on i.inventory_id = r.inventory_id
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on fc.category_id = c.category_id
group by c."name"
order by count(r.rental_id) DESC
;


--62. Encuentra el número de películas por categoría estrenadas en 2006.

select c."name" ,COUNT(f.*) from film f
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c 
on fc.category_id = c.category_id
where f.release_year = 2006
group by c."name";


--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
--que tenemos.


select * from staff
cross join store
;

--64. Encuentra la cantidad total de películas alquiladas por cada cliente y
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de
--películas alquiladas.

select c.customer_id , c.first_name , c.last_name , COUNT(r.rental_id) from rental r
inner join customer c 
on r.customer_id = c.customer_id 
group by c.customer_id, c.first_name, c.last_name
order by COUNT(r.rental_id) DESC
;


