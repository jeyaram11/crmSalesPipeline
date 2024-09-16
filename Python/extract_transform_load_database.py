import os
import sys

import yaml
import postgresql_connector as pc
from sqlalchemy import text
import pandas as pd
import date_frame_transformations as dft


def main():
    full_cmd_arguments = sys.argv
    #data_source = full_cmd_arguments[1]
    data_source = 'sales_data'

    #get the current working directory
    current_directory = os.getcwd()

    #get the parent directory
    parent_directory = os.path.dirname(current_directory)

    #construct the path to the YAML file in the parent directory
    yaml_file_path = os.path.join(parent_directory,'source_path.yaml')

    #Read and print the YAML file content
    credentials = yaml.safe_load(open(yaml_file_path))
    connect_to = data_source
    source_connection = credentials[connect_to]['source_connection']
    sql_query = credentials[connect_to]['sql_query']
    source = credentials[connect_to]['source']
    schema = credentials[connect_to]['schema']
    destination_connection = credentials[connect_to]['destination_connection']
    staging_script = credentials[connect_to]['staging_script']
    insert_script = credentials[connect_to]['insert_script']

    #create an engine and connect to the source_server
    source_engine = pc.postgresql_connection(source_connection)
    connection_to_source = source_engine.connect()

    script = open(sql_query, 'r').read()

    result = pd.DataFrame(connection_to_source.execute(text(script)))

    #clean columns and remove any duplicates
    result = dft.clean_columns(result)

    result = dft.remove_duplicatese(result)

    #create an engine to connect to the destination server
    destination_engine = pc.postgresql_connection(destination_connection)
    connection_to_destination = destination_engine.connect()

    #import into the staging table
    try:
        # Import the DataFrame into PostgreSQL
        result.to_sql(source + '_loading', connection_to_destination, schema=schema, if_exists='replace', index=False)
        print(f"DataFrame successfully imported to the {source} table in schema {schema}")
    except Exception as e:
        print(str(e))

    #execute staging script
    try:
        pc.execute_script(connection_to_destination, staging_script)
    except Exception as e:
        print('check sql staging script', str(e))

    #execute staging script
    try:
        pc.execute_script(connection_to_destination, insert_script)
    except Exception as e:
        print('check sql staging script', str(e))


    pc.close_connection(source_engine)
    pc.close_connection(destination_engine)

if __name__ == "__main__":
    main()

