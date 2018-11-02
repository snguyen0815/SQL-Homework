############################
User: Stanley Nguyen
############################

Use sakila;
--------------------------------------------------------
--1a.
SELECT first_name, last_name
FROM actor;
--------------------------------------------------------
--1b.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;
--------------------------------------------------------
--2a.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";
--------------------------------------------------------
--2b.
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like '%GEN%';
--------------------------------------------------------
--2c.
SELECT first_name, last_name
FROM actor
Where last_name LIKE "%LI%"
ORDER BY last_name, first_name;
--------------------------------------------------------
--2d.
SELECT country_id, country
FROM country 
WHERE country IN 
('Afghanistan', 'Bangladesh', 'China');
--------------------------------------------------------
--3a.
ALTER TABLE actor ADD COLUMN description BLOB; 
--------------------------------------------------------
--3b.
ALTER TABLE actor DROP COLUMN description;
--------------------------------------------------------
--4a.
SELECT last_name, COUNT(*) AS 'Number of Actors(last_name)' 
FROM actor GROUP BY last_name;
--------------------------------------------------------
--4b.
SELECT COUNT(last_name), last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >=2;
--------------------------------------------------------
--4c.
UPDATE actor
SET first_name = "Harpo"
WHERE actor_id = 172;
--------------------------------------------------------
--4d.
UPDATE actor
SET first_name = "GROUCHO"
WHERE actor_id = 172;
--------------------------------------------------------
--5a.
SHOW CREATE TABLE address;
--------------------------------------------------------
--6a
SELECT first_name, last_name, address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;
--------------------------------------------------------
--6b.
SELECT first_name, last_name, SUM(amount)
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE "2005-08%"
GROUP BY payment.staff_id;
--------------------------------------------------------
--6c.
SELECT film.title, COUNT(film_actor.actor_id)
FROM film_actor 
INNER JOIN film 
ON film_actor.film_id= film.film_id
GROUP BY title;
--------------------------------------------------------
--6d.
SELECT film.title AS "TITLE", COUNT(inventory.film_id) AS "COPY COUNT"
FROM Inventory 
JOIN film ON film.film_id = inventory.film_id
Where inventory.film_id = 439;
--------------------------------------------------------
--6e.
select customer.first_name, customer.last_name, sum(payment.amount) as Total_Amount_Paid
from customer
inner join payment on customer.customer_id = payment.customer_id
group by customer.first_name, customer.last_name
order by last_name;
--------------------------------------------------------
--7a.
SELECT title
FROM film
WHERE title IN (SELECT title
				FROM film
				WHERE language_id = "1") AND title LIKE "K%" OR title LIKE "Q%";
--------------------------------------------------------
--7b.
SELECT first_name, last_name
FROM actor		
WHERE actor.actor_id IN (SELECT film_actor.actor_id
						 FROM film_actor
						 JOIN film ON film.film_id = film_actor.film_id
						 WHERE film.film_id IN (SELECT film.film_id
												FROM film
												WHERE title="ALONE TRIP")
						 );
--------------------------------------------------------
--7c.
SELECT first_name, last_name, email
FROM customer
JOIN address ON address.address_id = customer.address_id
WHERE address.address_id IN (Select city_id
					         FROM city
					         JOIN country ON country.country_id = city.country_id 
					         WHERE country.country_id IN (SELECT country_id
										                  FROM country
										                  WHERE country = "Canada")
					 ); 
--------------------------------------------------------
--7d.
SELECT title 
FROM film
WHERE film.film_id IN (SELECT film_category.film_id
					   FROM film_category
					   JOIN film ON film_category.film_id = film.film_id
					   WHERE film_category.category_id IN (SELECT category_id
														   FROM category
														   WHERE name="Family")
						);
--------------------------------------------------------
--7e
SELECT film.title,
COUNT(rental_id) AS 'Number of Rentals'
FROM rental 
JOIN inventory 
ON (rental.inventory_id = inventory.inventory_id)
JOIN film 
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY `Number of Rentals` DESC;
--------------------------------------------------------
--7f
SELECT store.store_id, 
SUM(amount) AS 'Revenue'
FROM payment 
JOIN rental 
ON (payment.rental_id = rental.rental_id)
JOIN inventory 
ON (inventory.inventory_id = rental.inventory_id)
JOIN store store
ON (store.store_id = inventory.store_id)
GROUP BY store.store_id; 
--------------------------------------------------------
--7g
SELECT store.store_id, city.city, country.country 
FROM store 
JOIN address 
ON (store.address_id = address.address_id)
JOIN city 
ON (city.city_id = address.city_id)
JOIN country
ON (country.country_id = city.country_id);
--------------------------------------------------------
--7h
SELECT category.name, 
SUM(payment.amount)
FROM category 
JOIN film_category  
ON (category.category_id=film_category.category_id)
JOIN inventory 
ON (film_category.film_id=inventory.film_id)
JOIN rental 
ON (inventory.inventory_id=rental.inventory_id)
JOIN payment  
ON (rental.rental_id=payment.rental_id)
GROUP BY category.name ORDER BY payment.amount  LIMIT 5;
--------------------------------------------------------
--8a
CREATE VIEW genre_revenue AS
SELECT category.name, 
SUM(payment.amount)
FROM category 
JOIN film_category  
ON (category.category_id=film_category.category_id)
JOIN inventory 
ON (film_category.film_id=inventory.film_id)
JOIN rental 
ON (inventory.inventory_id=rental.inventory_id)
JOIN payment  
ON (rental.rental_id=payment.rental_id)
GROUP BY category.name ORDER BY payment.amount  LIMIT 5;      

--8b
SELECT * FROM genre_revenue;
--------------------------------------------------------
--8c
DROP VIEW genre_revenue;
--------------------------------------------------------
