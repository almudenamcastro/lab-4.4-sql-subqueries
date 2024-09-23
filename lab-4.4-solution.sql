-- ## Challenge

-- Write SQL queries to perform the following tasks using the Sakila database:
USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT COUNT(*) AS 'copies_of_Hunchback_Impossible'
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT *
FROM film f
WHERE f.length > (
    SELECT AVG(f.length) 
	FROM film f);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT fa.actor_id, a.first_name, a.last_name
FROM film_actor fa
LEFT JOIN actor a ON fa.actor_id = a.actor_id 
WHERE fa.film_id = (
	SELECT f.film_id
	FROM film f
	WHERE f.title = 'Alone trip');

-- **Bonus**:

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films. 
SELECT *
FROM film f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    WHERE fc.category_id = (
        SELECT c.category_id
        FROM category c
        WHERE c.name = 'Family'
    )
);

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT c.first_name, c.last_name, c.email
FROM customer c 
LEFT JOIN address a ON c.address_id = a.address_id
LEFT JOIN city ci ON a.city_id = ci.city_id
LEFT JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- Solution without joins (more efficient, using subqueries):
SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (
    SELECT address_id
    FROM address 
    WHERE city_id IN (
        SELECT city_id 
        FROM city
        WHERE country_id IN (
            SELECT country_id
            FROM country
            WHERE country = 'Canada'
        )
    )
);

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
-- A prolific actor is defined as the actor who has acted in the most number of films. 
-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.ORDER BY total_films DESC

SELECT g.actor_id, g.first_name, g.last_name, f.title
FROM (
	SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS total_films
	FROM film_actor fa
	LEFT JOIN actor a ON fa.actor_id = a.actor_id
	GROUP BY a.actor_id
	ORDER BY total_films DESC
	LIMIT 1) as g
LEFT JOIN film_actor fa ON g.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id;

-- Another solution: 
SELECT f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(film_id) DESC
    LIMIT 1
);



-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.


-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
