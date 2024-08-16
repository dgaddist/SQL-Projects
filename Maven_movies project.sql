use Maven_movies


/*Client needs a list of all staff members, including first name, email address, 
and  the store id where they work. */

select first_name, last_name, email, store_id from staff;

/* Client need seperate count of inventory items held at each of your two stores */

 SELECT
store_id,
COUNT(inventory_id) AS store_inventory
from inventory
GROUP BY
store_id;

-- client needs a count of active customers for each of your stores. Separately. --

SELECT store_id,
COUNT(customer_id) as customers
from customer
where active = 1
GROUP BY store_id;


-- Client needs to assess liability data breach, provide a count of all customers email addresses stored in database --
SELECT COUNT(email) as customer_email
from customer;

/* Client needs a count of unique film titles in inventory at each store. Then provide a 
count of the unique categories f films your provide */

 SELECT store_id,
 COUNT(DISTINCT film_id) as unique_titles_inventory
 FROM inventory
  GROUP BY store_id;
 
 SELECT
 COUNT(DISTINCT name) AS film_categories
 FROM category 
 
 /* Please provide replacement cost for the film that is lease expensive to replace,
 most expensive to replace, and aerage of all films your carry */
 
 SELECT title, replacement_cost
 FROM FILM
 order by replacement_cost ASC
 
  SELECT title, replacement_cost
 FROM FILM
 order by replacement_cost DESC
 
SELECT AVG(replacement_cost)
 FROM FILM
 
 /*Please provide the average payment you process, as well as the maximum payment you have processed */
 
 SELECT AVG(amount) as average_payment
 FROM payment
 
SELECT MAX(amount) as max_amount
 FROM payment
 
 /* Client wants to better understand client base. List of all customer if, count of rentals,
 highest volume customers at the top of the list */
 
 SELECT customer_id,
 COUNT(rental_id) AS number_of_rentals
 FROM rental
 GROUP BY
 customer_id
 ORDER BY
 COUNT(rental_id) DESC;
 
 /*
1. My partner and I want to come by each of the stores in person and meet the managers.
   Please send over the managers' names at each store, with the full address of each property
   (street address, district, city, and country please).
*/
 
 SELECT
 staff.first_name as first_name,
 staff.last_name as last_name,
 staff.store_id as store,
 address.address as address,
 address.district as district,
 city.city as city,
 country.country as country
 FROM staff
 LEFT JOIN store
 ON store.store_id = staff.store_id
 LEFT JOIN address
 ON address.address_id = store.store_id
 LEFT JOIN city
 ON city.city_id = address.city_id
 LEFT JOIN country
 ON country.country_id = city.country_id
 
 /* Client would like a list of each inventory that we have stocked, store id, inventory id
 name of the film, films rating, and its rental rate and replacement cost. */
 
 Select
 inventory.inventory_id,
 inventory.store_id,
 inventory.film_id,
 film.title as film_name,
 film.rating as rating,
 film.rental_rate as rental_rate,
 film.replacement_cost as replacement_cost
 from inventory
LEFT JOIN film
ON inventory.film_id = film.film_id

 
 /* Client would like a summary level overview of inventory. How many inventory items
 you have with each rating at each store. */
 
  Select
 COUNT(inventory_id) AS inventory,
 inventory.store_id,
 film.rating as rating
 from inventory
LEFT JOIN film
ON inventory.film_id = film.film_id
 GROUP BY
 inventory.store_id,
 film.rating
 
 /*Client wants to know how diVersified inventory is. Provide number of films 
 as well as the average replacement cost and total replacement cost, sliced by sotre and film category. */
 
 Select
 COUNT(film.film_id),
 AVG(film.replacement_cost),
 SUM(film.replacement_cost) as total_replacement,
 inventory.store_id as store,
 film_category.category_id
 from film
 LEFT JOIN inventory 
 ON inventory.film_id = film.film_id
 LEFT JOIN film_category
 ON film_category.film_id = inventory.film_id
 GROUP BY inventory.store_id,
 film_category.category_id
 
/*  5. We want to make sure you folks have a good handle on who your customers are.
   Please provide a list of all customer names, which store they go to, whether or not they are currently active,
   and their full addresses – street address, city, and country.
*/

Select customer.first_name, 
customer.last_name,
customer.store_id as store,
customer.active as active,
address.address as address,
city.city as city,
country.country as country
FROM customer
LEFT JOIN address
ON customer.address_id = address.address_id
LEFT JOIN city
ON city.city_id = address.city_id
LEFT JOIN country
ON country.country_id = city.country_id
ORDER BY customer.store_id;


/*
6. We would like to understand how much your customers are spending with you, and also to know who your most valuable customers are.
   Please pull together a list of customer names, their total lifetime rentals, and the sum of all payments you have collected from them.
   It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list.
*/

Select customer.first_name,
customer.last_name,
COUNT(rental.rental_id) as lifetime_rentals,
SUM(payment.amount) as all_payments
FROM customer
LEFT JOIN rental
ON rental.customer_id = customer.customer_id
LEFT JOIN payment 
ON payment.rental_id = rental.rental_id
GROUP BY customer.first_name,
customer.last_name
ORDER BY SUM(payment.amount) DESC;



/*
7. My partner and I would like to get to know your board of advisors and any current investors.
   Could you please provide a list of advisor and investor names in one table?
   Could you please note whether they are an investor or an advisor, and for the investors,
   it would be good to include which company they work with.
*/

select
'investor' as type,
 first_name,
last_name,
company_name
from investor
UNION
SELECT 
'advisor' as type,
first_name,
last_name,
null as company_name
from advisor

/*
8. We're interested in how well you have covered the most-awarded actors.
   Of all the actors with three types of awards, for what % of them do we carry a film?
   And how about for actors with two types of awards? Same questions.
   Finally, how about actors with just one award? */
   

SELECT
	CASE
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
		WHEN actor_award.awards IN ('Emmy, Oscar', 'Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards,
 AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS ONE_FILM_PERCENT
 FROM actor_award
 GROUP BY number_of_awards;
