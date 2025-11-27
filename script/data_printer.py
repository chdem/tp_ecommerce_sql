import datetime
import sys
from data_repository import db_execute, revenue_by_category, average_cart, most_sold_product, revenue_report, top_customer


def create_report():

    now = datetime.datetime.now()

    formatted_date = now.strftime("%Y-%m-%d %H:%M:%S")

    print(formatted_date)

    print("")
    print("1 Chiffre d’affaires total")
    print(f"Le chiffre d’affaires total (hors commandes annulées) est de {db_execute(revenue_report)} €.")
    print()
    print("2 panier moyen")
    print(f"Le panier moyen est de {db_execute(average_cart)} €.")
    print()
    print("3 CA par catégories")
    print(db_execute(revenue_by_category))
    print()
    print("4 produit le plus vendu")
    print(db_execute(most_sold_product))
    print("5 Top5 clients")
    print(db_execute(top_customer))

def file_printer(file_name): #not working
    with open(file_name, "a", encoding="utf-8") as f:
        old_stdout = sys.stdout       
        sys.stdout = f               
        try:
            create_report()
        finally:
            sys.stdout = old_stdout

    
