/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */

SELECT rank,
       title,
       revenue,
       total_revenue AS "total revenue",
       to_char(((total_revenue * 100.0) / overall_total), 'FM9900.00') AS "percent revenue"
FROM (
  SELECT rank,
         title,
         revenue,
         SUM(revenue) OVER (ORDER BY rank) AS total_revenue,
         SUM(revenue) OVER () AS overall_total
  FROM (
    SELECT f.title,
           COALESCE(SUM(p.amount), 0)::numeric(10,2) AS revenue,
           RANK() OVER (ORDER BY COALESCE(SUM(p.amount), 0)::numeric(10,2) DESC) AS rank
    FROM film f
    LEFT JOIN inventory i ON f.film_id = i.film_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id
    LEFT JOIN payment p ON r.rental_id = p.rental_id
    GROUP BY f.title
  ) AS film_revenue
) AS revenue_report
ORDER BY rank,title;
