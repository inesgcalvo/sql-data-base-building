-- Q01: Janis Joplin wants to rent an Horror Soviet Film in the store of Valladolid

SELECT DISTINCT
    f.title AS `Title`,
    f.description AS `Description`
FROM film AS f
    INNER JOIN category AS c
    ON f.category_category_id = c.category_id
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
WHERE 
    c.category_id = 11 
    AND i.store_store_id = 4 
    AND f.description LIKE '%soviet%'
ORDER BY f.title



-- Q02: Stevie Nicks wants to rent a Drama film with Julia McQueen and Alec Wayne in the store of Iruña

SELECT DISTINCT
    f.title AS `Title`,
    CONCAT(a.first_name, ' ', a.last_name) AS `Actor`,
    f.description AS `Description`
FROM film AS f
    INNER JOIN category AS c
    ON f.category_category_id = c.category_id
    INNER JOIN filmactor AS fa
    ON f.film_id = fa.film_film_id
    INNER JOIN actor AS a
    ON fa.actor_actor_id = a.actor_id
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
WHERE 
    c.category_id = 7 
    AND i.store_store_id = 7 
    AND fa.actor_actor_id IN (27, 29) 
GROUP BY title, actor, description 
HAVING COUNT(title) > 2 



-- Q03: Patti Smith, who is affraid of cats, wants to rent a classic feminist film in the store of Grao

SELECT DISTINCT
    f.title AS `Title`,
    f.description AS `Description`
FROM film AS f
    INNER JOIN category AS c
    ON f.category_category_id = c.category_id
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
WHERE 
    i.store_store_id = 6 
    AND f.description LIKE '%feminist%' 
    AND f.description NOT LIKE '%cat%' 
    AND c.category_id = 4
ORDER BY f.title



-- Q04: Nina Simone wants to rent a film about Paris in the store of Carabanchel

SELECT DISTINCT
    f.title AS `Title`,
    f.description AS `Description`
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
WHERE 
    f.title LIKE '%paris%'
    AND i.store_store_id = 1
ORDER BY f.title



-- Q05: Joan Jett wants to rent the documentary with the cheapest replacement cost in the store of Dos Hermanas

SELECT DISTINCT
    f.title AS `Title`,
    f.replacement_cost
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
    INNER JOIN category AS c
    ON f.category_category_id = c.category_id
WHERE 
    i.store_store_id = 3
    AND f.category_category_id = 6
ORDER BY f.replacement_cost ASC LIMIT 1



-- Q06: Amy Winehouse wants to know where to rent 'Affair Prejudice' if she does not want to cross Pot Pol

SELECT DISTINCT
    f.title AS `Title`,
    s.name AS `Store`
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
    INNER JOIN staff
    ON s.store_id = staff.store_store_id
WHERE 
    staff.first_name != 'Pol'
    AND staff.first_name != 'Pot'
    AND f.title = 'Affair Prejudice'
ORDER BY f.title



-- Q07: Bjork wants to rent a film in Hervás which is about a Shark and a Crocodile in Berlin but she does not remember the title... 

SELECT DISTINCT
    f.title AS `Title`,
    f.description AS `Description`
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
WHERE 
    f.description LIKE '%shark%'
    AND f.description LIKE '%crocodile%' 
    AND f.description LIKE '%berlin%'
    AND i.store_store_id = 2
ORDER BY f.title



-- Q08: Beyoncé is visiting Suances, she wants to choose between five new films with the higest rate

SELECT DISTINCT
    f.title AS `Title`,
    f.description,
    f.rental_rate AS `Rate`
FROM film AS f
    INNER JOIN inventory AS i
    ON f.film_id = i.film_film_id
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
    INNER JOIN category AS c
    ON f.category_category_id = c.category_id
WHERE 
    i.store_store_id = 5
    AND f.category_category_id = 13
ORDER BY f.rental_rate DESC LIMIT 5



-- Q09: Lzzy Hale is completely lost, she is located somewhere in Spain, and she wants to know the closest store to ask a taxi to bring her there... She only knows the coordenates of her location, because a strange bug in her navigator:  Latitude: 42.4798902 & Longitude: -2.0943004 

SELECT 
    s.name AS 'Store', 
    s.latitude AS `Latitude`, 
    s.longitude AS `Longitude`, 
    
-- Here is the Haversine formula for calculating the distance in Kilometters between two points on the Earth's surface:
-- hav(d/r) = hav(lat2 - lat1) + cos(lat1) * cos(lat2) * hav(long2 - long1)

    6371 * 2 * ASIN(SQRT( POWER(SIN((42.4798902 - abs(Latitude)) * pi()/180 / 2),2) + COS(42.4798902 * pi()/180 ) * COS(abs(Latitude) *  pi()/180) * POWER(SIN((-2.0943004 - Longitude) *  pi()/180 / 2), 2) )) as `distance`
    
FROM store AS s
ORDER BY distance LIMIT 1



-- Q10: Taylor Momsen wants to rent a Sci-Fi film following the MPA rating 'Adults Only' in the store of Suances

SELECT DISTINCT
    step.title AS `Title`,
    step.description AS `Description`,
    step.rating AS `MPA rate`
FROM
(SELECT DISTINCT
    f.title,
    f.description,
    f.rating
FROM film AS f
    INNER JOIN category AS c
    ON f.category_category_id = c.category_id
WHERE 
    c.name = 'Sci-Fi'
    AND f.rating = 'NC-17') 
AS step
    INNER JOIN inventory AS i
    INNER JOIN store AS s
    ON i.store_store_id = s.store_id
WHERE 
    s.name = 'Suances'
ORDER BY title