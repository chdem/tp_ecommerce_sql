import psycopg
import os
from dotenv import load_dotenv

load_dotenv()


DSN = f"dbname=ecommerce user={os.getenv("POSTGRES_USER")} password={os.getenv("POSTGRES_PASSWORD")} host=local_pgdb port=5432"

def db_execute(function)-> psycopg.Cursor:
    try:
        with psycopg.connect(DSN) as conn:
            with conn.cursor() as cursor:
                return function(cursor)
    except psycopg.errors.SyntaxError as e:
        print("error sql", e)
    except psycopg.errors.UniqueViolation as e:
        print("Violation unique error", e)
    except psycopg.errors.OperationalError as e:
        print("Connection issue", e)
    except Exception as e:
        print("other error", e)


def revenue_report(cursor):

    cursor.execute(
    """
    SELECT ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
        FROM orders o
        JOIN order_items oi ON oi.id_order = o.id_order
        """)
    
    result = cursor.fetchone()[0]
    return result


def average_cart(cursor):
    cursor.execute(
    """
        SELECT ROUND(AVG(oi.quantity * oi.unit_price)::numeric, 2)  as avg_amount
        FROM orders o
        JOIN order_items oi ON oi.id_order = o.id_order;  
    """)
    
    result = cursor.fetchone()[0]
    return result

def revenue_by_category(cursor):
    cursor.execute("""
        SELECT ca.libelle, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2) as total_amount
        FROM orders o
        JOIN order_items oi ON oi.id_order = o.id_order
        JOIN products p ON p.id_products = oi.id_products
        JOIN categories ca ON p.id_categorie = ca.id_categorie
        GROUP BY ca.libelle;
    """)
    
    rows = cursor.fetchall()
    return __print_rows(rows, cursor.description)

def most_sold_product(cursor):
    cursor.execute("""
        SELECT p.name, oi.quantity
        FROM customers c
        JOIN orders o ON o.id_customer = c.id_customer
        JOIN order_items oi ON oi.id_order = o.id_order
        JOIN products p ON p.id_products = oi.id_products
        ORDER BY quantity DESC
        LIMIT 3;
      """)
    rows = cursor.fetchall()
    return __print_rows(rows, cursor.description)

def top_customer(cursor):
    cursor.execute("""
            SELECT c.id_customer, c.first_name, c.last_name, ROUND(SUM(oi.quantity * oi.unit_price)::numeric, 2)  as total_amount
        FROM customers c
        JOIN orders o ON o.id_customer = c.id_customer
        JOIN order_items oi ON oi.id_order = o.id_order
        GROUP BY c.first_name, c.last_name, c.id_customer
        ORDER BY total_amount DESC
        LIMIT 5;
                """)
    rows = cursor.fetchall()
    return __print_rows(rows, cursor.description)

def __print_rows(rows, descriptions):
    columns = [c[0] for c in descriptions]
    result = []

    for row in rows:
        row_str = "\n".join(f"{col}: {value}" for col, value in zip(columns, row))
        result.append(row_str)
        result.append("--------------------")
    return "\n".join(result)
