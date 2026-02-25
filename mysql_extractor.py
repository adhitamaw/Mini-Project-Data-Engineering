from sqlalchemy import create_engine
import pandas as pd

def extract(table):
    db_connection_str = 'mysql+pymysql://root:@localhost:3307/classicmodels'
    db_connection = create_engine(db_connection_str)

    df = pd.read_sql(f'SELECT * FROM {table}', con=db_connection)


    return df

if __name__ == "__main__":
    extract('orders')