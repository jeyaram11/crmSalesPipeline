import os
import date_frame_transformations as dft
import pandas as pd
import yaml
import postgresql_connector as pc

# Get the current working directory
current_directory = os.getcwd()

# Get the parent directory
parent_directory = os.path.dirname(current_directory)

# Construct the path to the YAML file in the parent directory
yaml_file_path = os.path.join(parent_directory, 'source_path.yaml')

# Read and print the YAML file content
credentials = yaml.safe_load(open(yaml_file_path))
connect_to = 'products'
path = credentials[connect_to]['path']

#load dataframe
df = pd.read_csv(path)

#clean columns and remove any duplicates
df = dft.clean_columns(df)

df = dft.remove_duplicatese(df)

#create a connection a load the data into the staging table
engine = pc.postgresql_connection()

connection = engine.connect()

#import into the staging table
try:
    # Import the DataFrame into PostgreSQL
    df.to_sql(connect_to+'_staging', engine, if_exists='replace', index=False)
    print(f"DataFrame successfully imported to the {connect_to+'_staging'} table.")
except Exception as e:
    print(str(e))

pc.close_connection(engine)