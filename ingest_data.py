import os
import pandas as pd
from sqlalchemy import create_engine
import csv

# # Database connection details
DB_USER = "dsubhlok"
DB_PASSWORD = "dsubhlok"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "go_student"
SCHEMA = "landing_layer"

# Create a database connection
engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')
#engine = create_engine('postgresql://{}:{}@{}/{}'.format('dsubhlok', 'dsubhlok', 'postgres:5432', 'go_student'))

def ingest_csv_to_postgres(file_path, table_name):
    """
    Reads a CSV file and ingests it into a PostgreSQL table.
    """
    #Detect delimeter in CSV file
    with open(file_path, 'r') as file:
        sample = file.read(1024)
        sniffer = csv.Sniffer()
        detected_del = sniffer.sniff(sample).delimiter

    # Load CSV data into a pandas DataFrame
    if detected_del == ',':
        data = pd.read_csv(file_path, delimiter=',', header=0)
        if 'Unnamed: 0' in data.columns:
            data = data.drop(columns=['Unnamed: 0'])
    else:
        data = pd.read_csv(file_path, delimiter=';', header=0)
        if 'Unnamed: 0' in data.columns:
            data = data.drop(columns=['Unnamed: 0'])

    # Write DataFrame to PostgreSQL table
    data.to_sql(table_name, engine, index=False, if_exists='replace', schema=SCHEMA )
    print(f"Data from {file_path} ingested into {table_name} table.")

# Directory containing CSV files
csv_directory = "/Users/dhruv.subhlok/Documents/GoStudent_Assignment/source_files/"

# Loop through CSV files in the directory and ingest each into PostgreSQL
for filename in os.listdir(csv_directory):
    if filename.endswith(".csv"):
        file_path = os.path.join(csv_directory, filename)
        table_name = os.path.splitext(filename)[0]  # Use filename as table name
        ingest_csv_to_postgres(file_path, table_name)