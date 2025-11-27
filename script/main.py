import time
from data_printer import create_report, file_printer

def report():
    create_report()

if __name__ =="__main__":
    print("En attente de la base de données...")
    time.sleep(10)
    report()
    file_printer("rapport_supershop.txt")
