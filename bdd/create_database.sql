CREATE DATABASE ecommerce;

CREATE TABLE categories(
   id_categorie INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   libelle VARCHAR(50) NOT NULL,
   description VARCHAR(255),
   UNIQUE(libelle)
);

CREATE TABLE products(
   id_products INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   name VARCHAR(100) NOT NULL,
   price INT NOT NULL CHECK("price" > 0),
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
   unit_price SMALLINT NOT NULL,
   PRIMARY KEY(id_products, id_order),
   FOREIGN KEY(id_products) REFERENCES products(id_products),
   FOREIGN KEY(id_order) REFERENCES orders(id_order)
);