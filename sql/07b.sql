/*
 * This problem is the same as 07.sql,
 * but instead of using the NOT IN operator, you are to use a LEFT JOIN.
 */

SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN (
  SELECT r.inventory_id
  FROM rental r
  JOIN customer c ON r.customer_id = c.customer_id
  JOIN address a ON c.address_id = a.address_id
  JOIN city ci ON a.city_id = ci.city_id
  JOIN country co ON ci.country_id = co.country_id
  WHERE co.country = 'United States'
) us ON i.inventory_id = us.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(us.inventory_id) = 0
ORDER BY f.title;

