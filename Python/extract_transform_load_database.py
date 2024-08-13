import os
import sys

import yaml
import postgresql_connector as pc
from sqlalchemy import text
import pandas as pd

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
    server = credentials[connect_to]['server_connection']
    sql_query = credentials[connect_to]['sql_query']
    #connect the the oltp server
    engine = pc.postgresql_connection(server)
    connection = engine.connect()

    script = open(sql_query, 'r').read()

    result = pd.DataFrame(connection.execute(text(script)))
    print(result)


if __name__ == "__main__":
    main()

