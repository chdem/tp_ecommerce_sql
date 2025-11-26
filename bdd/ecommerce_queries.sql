CREATE TABLE categories(
   id_categorie INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   libelle VARCHAR(50) NOT NULL,
   description VARCHAR(255),
   UNIQUE(libelle)
);

CREATE TABLE products(
   id_products INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   price FLOAT NOT NULL CHECK("price" > 0),
   available_stock SMALLINT NOT NULL CHECK("available_stock" > 0),
   id_categorie INT NOT NULL,
   FOREIGN KEY(id_categorie) REFERENCES categories(id_categorie)
);

CREATE TABLE customers(
   id_customer INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   last_name VARCHAR(100) NOT NULL,
   first_name VARCHAR(100) NOT NULL,
   email VARCHAR(100) NOT NULL,
   account_creation_date DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
   UNIQUE(email)
);

CREATE TABLE orders(
   id_order INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   date_time DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
   status VARCHAR(50) NOT NULL CHECK ("status" IN ('PENDING', 'PAID', 'SHIPPED', 'CANCELLED')),
   id_customer INT NOT NULL,
   FOREIGN KEY(id_customer) REFERENCES customers(id_customer)
);

CREATE TABLE order_items(
   id_products INT,
   id_order INT,
   quantity SMALLINT NOT NULL,
   unit_price FLOAT NOT NULL,
   PRIMARY KEY(id_products, id_order),
   FOREIGN KEY(id_products) REFERENCES products(id_products),
   FOREIGN KEY(id_order) REFERENCES orders(id_order)
);

INSERT INTO categories (libelle, description) VALUES
  ('Électronique',       'Produits high-tech et accessoires'),
  ('Maison & Cuisine',   'Électroménager et ustensiles'),
  ('Sport & Loisirs',    'Articles de sport et plein air'),
  ('Beauté & Santé',     'Produits de beauté, hygiène, bien-être'),
  ('Jeux & Jouets',      'Jouets pour enfants et adultes');


 INSERT INTO products(name, price, available_stock, id_categorie) VALUES
  ('Casque Bluetooth X1000',        79.99,  50,  1),
  ('Souris Gamer Pro RGB',          49.90, 120,  1),
  ('Bouilloire Inox 1.7L',          29.99,  80,  2),
  ('Aspirateur Cyclonix 3000',     129.00,  40,  2),
  ('Tapis de Yoga Comfort+',        19.99, 150,  3),
  ('Haltères 5kg (paire)',          24.99,  70,  3),
  ('Crème hydratante BioSkin',      15.90, 200,  4),
  ('Gel douche FreshEnergy',         4.99, 300,  4),
  ('Puzzle 1000 pièces "Montagne"', 12.99,  95,  5),
  ('Jeu de société "Galaxy Quest"', 29.90,  60,  5);

 INSERT INTO customers(first_name, last_name, email, account_creation_date) VALUES
  ('Alice',  'Martin',    'alice.martin@mail.com',    '2024-01-10 14:32'),
  ('Bob',    'Dupont',    'bob.dupont@mail.com',      '2024-02-05 09:10'),
  ('Chloé',  'Bernard',   'chloe.bernard@mail.com',   '2024-03-12 17:22'),
  ('David',  'Robert',    'david.robert@mail.com',    '2024-01-29 11:45'),
  ('Emma',   'Leroy',     'emma.leroy@mail.com',      '2024-03-02 08:55'),
  ('Félix',  'Petit',     'felix.petit@mail.com',     '2024-02-18 16:40'),
  ('Hugo',   'Roussel',   'hugo.roussel@mail.com',    '2024-03-20 19:05'),
  ('Inès',   'Moreau',    'ines.moreau@mail.com',     '2024-01-17 10:15'),
  ('Julien', 'Fontaine',  'julien.fontaine@mail.com', '2024-01-23 13:55'),
  ('Katia',  'Garnier',   'katia.garnier@mail.com',   '2024-03-15 12:00');

 INSERT INTO orders(id_customer, date_time, status) VALUES
  (1,    '2024-03-01 10:20', 'PAID'),
  (2,      '2024-03-04 09:12', 'SHIPPED'),
  (3,   '2024-03-08 15:02', 'PAID'),
  (4,    '2024-03-09 11:45', 'CANCELLED'),
  (5,      '2024-03-10 08:10', 'PAID'),
  (6,     '2024-03-11 13:50', 'PENDING'),
  (7,    '2024-03-15 19:30', 'SHIPPED'),
  (8,     '2024-03-16 10:00', 'PAID'),
  (9, '2024-03-18 14:22', 'PAID'),
  (10,   '2024-03-20 18:00', 'PENDING');

INSERT INTO order_items(id_products, id_order, quantity, unit_price) VALUES
  (1,1,1,79.99),
  (9,1,2,12.99),
  (5,2,1,19.99),
  (3,3,1,29.99),
  (8,3,3,4.99),
  (6,4,1,24.99),
  (7,5,2,15.90),
  (10,9,1,29.90),
  (2,10,1,49.90),
  (8,10,2,4.99);

--1
SELECT * FROM customers ORDER BY account_creation_date;

SELECT name, price FROM products ORDER BY price DESC;

SELECT * FROM orders WHERE DATE(DATE_TIME) BETWEEN '2024-01-03' AND '2024-03-15';

SELECT * FROM products WHERE price > 50;

SELECT * FROM products WHERE id_categorie = 1;

--2
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

--3
SELECT o.date_time, c.first_name, c.last_name, p.name, oi.quantity, oi.unit_price, (oi.quantity * oi.unit_price) as total_amount
FROM customers c
JOIN orders o ON o.id_customer = c.id_customer
JOIN order_items oi ON oi.id_order = o.id_order
JOIN products p ON p.id_products = oi.id_products;