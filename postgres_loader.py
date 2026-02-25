from sqlalchemy import create_engine

def load(data, table_name, schema , database):
    db_connection_str = f'postgresql://postgres:root@localhost:5432/{database}'
    
    conn = create_engine(db_connection_str)
    db = conn.connect()

    data.to_sql(table_name, con=db, schema=schema, index=False)
    print("successfully load to Postgres")

