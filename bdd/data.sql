--3 requête de base 
SELECT * FROM customers ORDER BY account_creation_date;

SELECT name, price FROM products ORDER BY price DESC;

SELECT * FROM orders WHERE DATE(DATE_TIME) BETWEEN '2024-01-03' AND '2024-03-15';

SELECT * FROM products WHERE price > 50;

SELECT * FROM products WHERE id_categorie = 1;

--4 jointure 5
SELECT p.name, c.libelle FROM products p
INNER JOIN categories c ON p.id_categorie = c.id_categorie;

SELECT o.id_order, c.last_name, c.first_name FROM orders o
INNER JOIN customers c ON o.id_customer = c.id_customer;

SELECT c.first_name, c.last_name, p.name, oi.quantity, oi.unit_price
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products;

SELECT * FROM orders 
WHERE status = 'PAID' OR status = 'SHIPPED';

--5 jointures avancées
SELECT o.date_time, c.first_name, c.last_name, p.name, oi.quantity, oi.unit_price, ROUND((oi.quantity * oi.unit_price)::numeric, 2) as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products;


SELECT o.id_order, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2)  as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY o.id_order, c.first_name, c.last_name;

SELECT o.id_order, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY o.id_order, c.first_name, c.last_name
HAVING ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) > 100;

SELECT ca.libelle, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
JOIN categories ca ON p.id_categorie = ca.id_categorie
GROUP BY ca.libelle;

--6 sous requêtes
SELECT * FROM products 
WHERE id_products IN (SELECT id_products FROM order_items WHERE quantity > 0);

SELECT * FROM products 
WHERE id_products NOT IN (SELECT id_products FROM order_items WHERE quantity > 0);

-- ajout jeu de données
 INSERT INTO orders(id_customer, date_time, status) VALUES
  (1,    '2024-03-01 10:20', 'PAID');

INSERT INTO order_items(id_products, id_order, quantity, unit_price) VALUES
  (9,11,5,12.99);

SELECT c.id_customer, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2)  as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY c.first_name, c.last_name, c.id_customer
ORDER BY total_amount DESC
LIMIT 1;

SELECT p.name, oi.quantity
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
ORDER BY quantity DESC
LIMIT 3;

SELECT o.id_order, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2)  as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY o.id_order, c.first_name, c.last_name
HAVING (SELECT ROUND(AVG(oi.quantity * oi.unit_price)::numeric, 2)  as avg_amount
		FROM orders o
		JOIN order_items oi ON oi.id_order = o.id_order) 
	< ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) ;

--7 Statistiques et agrégats

SELECT ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
JOIN categories ca ON p.id_categorie = ca.id_categorie;

SELECT ROUND(AVG(oi.quantity * oi.unit_price)::numeric, 2)  as avg_amount
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order;

SELECT ca.libelle, ROUND(SUM(oi.quantity)::numeric, 2) as total_quantity_by_categorie
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
JOIN categories ca ON p.id_categorie = ca.id_categorie
GROUP BY ca.libelle;

SELECT
    TO_CHAR(DATE_TRUNC('month', o.date_time), 'Month') AS mois,
    SUM(oi.quantity * oi.unit_price) AS amount
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY DATE_TRUNC('month', o.date_time)
ORDER BY DATE_TRUNC('month', o.date_time);

--8 logique conditionnelle
SELECT o.id_order, c.first_name, c.last_name,
CASE
	WHEN status = 'PAID' THEN 'Payée'
	WHEN status = 'SHIPPED' THEN 'Expédiée'
	WHEN status = 'PENDING' THEN 'En attente'
	WHEN status = 'CANCELLED' THEN 'Annulée'
	END AS status_in_la_france
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer;

SELECT c.id_customer, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2)  as total_amount,
	CASE 
		WHEN ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) < 100 THEN 'Bronze'
		WHEN ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) < 300 THEN 'Argent'
		ELSE 'Gold'
	END AS segment

FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY c.first_name, c.last_name, c.id_customer
ORDER BY total_amount DESC;

--9 Challenge final

SELECT c.id_customer, c.first_name, c.last_name, COUNT(o.id_order)  as nb_commandes
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
GROUP BY c.id_customer, c.first_name, c.last_name
ORDER BY COUNT(o.id_order) DESC
LIMIT 5;

SELECT c.id_customer, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2)  as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
GROUP BY c.first_name, c.last_name, c.id_customer
ORDER BY total_amount DESC
LIMIT 5;

SELECT ca.libelle, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
JOIN categories ca ON p.id_categorie = ca.id_categorie
GROUP BY ca.libelle
ORDER BY ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) DESC
LIMIT 3;

SELECT p.name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
GROUP BY p.name
HAVING ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) < 30
ORDER BY total_amount DESC;

SELECT c.id_customer, c.first_name, c.last_name, COUNT(o.id_order)  as nb_commandes
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
GROUP BY c.id_customer, c.first_name, c.last_name
HAVING COUNT(o.id_order) = 1;

SELECT o.id_order, p.name, ROUND((oi.quantity * oi.unit_price)::numeric, 2) as lost_amount
FROM orders o
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products
WHERE o.status = 'CANCELLED';
