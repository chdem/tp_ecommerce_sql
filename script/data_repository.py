import psycopg
import os
from dotenv import load_dotenv

load_dotenv()


DSN = f"dbname=ecommerce user={os.getenv("POSTGRES_USER")} password={os.getenv("POSTGRES_PASSWORD")} host=local_pgdb port=5432"

def db_execute(function, *args)-> psycopg.Cursor:
    try:
        with psycopg.connect(DSN) as conn:
            with conn.cursor() as cursor:
                function(cursor, args)
    except psycopg.errors.SyntaxError as e:
        print("error sql", e)
    except psycopg.errors.UniqueViolation as e:
        print("Violation unique error", e)
    except psycopg.errors.OperationalError as e:
        print("Connection issue", e)
    except Exception as e:
        print("other error", e)

def test():
    print("test")



