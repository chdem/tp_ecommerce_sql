import time
from data_repository import create_report

def report():
    create_report()

if __name__ =="__main__":
    print("En attente de la base de données...")
    time.sleep(10)
    report()
