import mysql_extractor
import postgres_loader

def etl_run():
    # extract table from MySQL
    tables = ['customers',
            'employees',
            'offices',
            'orderdetails',
            'orders',
            'payments',
            'productlines',
            'products'
            ]
    
    for table in tables:

        data = mysql_extractor.extract(table)

        print(f'Extract table {table} from MySQ successfully')

        # load table to Postgres raw schema
        postgres_loader.load(data, table, 'raw', 'data_warehouse')

        print(f'table {table} loaded to Postgres successfully')

if __name__ == "__main__":
    etl_run()
