import os
import sys

import sqlalchemy
from sqlalchemy import text

import date_frame_transformations as dft
import pandas as pd
import yaml
import postgresql_connector as pc

def main():

    #get the name of the document
    full_cmd_arguments = sys.argv
    data_source = full_cmd_arguments[1]

    # Get the current working directory
    current_directory = os.getcwd()

    # Get the parent directory
    parent_directory = os.path.dirname(current_directory)

    # Construct the path to the YAML file in the parent directory
    yaml_file_path = os.path.join(parent_directory, 'source_path.yaml')

    # Read and print the YAML file content
    credentials = yaml.safe_load(open(yaml_file_path))
    connect_to = data_source
    path = credentials[connect_to]['path']
    source = credentials[connect_to]['source']
    schema = credentials[connect_to]['schema']
    staging_script = credentials[connect_to]['staging_script']
    insert_script = credentials[connect_to]['insert_script']
    server = credentials[connect_to]['destination_connection']

    #load dataframe
    df = pd.read_csv(path)

    #clean columns and remove any duplicates
    df = dft.clean_columns(df)

    df = dft.remove_duplicatese(df)

    #create a connection a load the data into the staging table
    destination_engine = pc.postgresql_connection(server)

    connection = destination_engine.connect()

    #import into the staging table
    try:
        # Import the DataFrame into PostgreSQL
        df.to_sql(source + '_loading', destination_engine, schema=schema, if_exists='replace', index=False)
        print(f"DataFrame successfully imported to the {source} table in schema {schema}")
    except Exception as e:
        print(str(e))


    #execute SCD1 and SCD 2 script
    pc.execute_script(connection,staging_script)

    #execute script to insert values into datawarehouse
    pc.execute_script(connection,insert_script)


    pc.close_connection(destination_engine)


if __name__ == "__main__":
    main()
