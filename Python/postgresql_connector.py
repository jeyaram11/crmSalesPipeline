# import all libaries
import os

import yaml
import sqlalchemy
import psycopg2
# function to create a connection to mysql server

# Define the global engine variable
global engine
engine = None


def postgresql_connection():
    current_directory = os.getcwd()

    parent_directory = os.path.dirname(current_directory)

    # Construct the path to the YAML file in the parent directory
    yaml_file_path = os.path.join(parent_directory, 'credentials.yaml')

    credentials = yaml.safe_load(open(yaml_file_path))

    connection_to = 'crm_sales_pipeline'
    username = credentials[connection_to]['username']
    password = credentials[connection_to]['password']
    hostname = credentials[connection_to]['hostname']
    port = credentials[connection_to]['port']
    database = credentials[connection_to]['database']


    try:
        engine = sqlalchemy.create_engine('postgresql+psycopg2://{username}:{password}@{hostname}/{database}'
                                          .format(username=username,
                                                  password=password,
                                                  hostname=hostname,
                                                  database=database
                                                  ))
        connection = engine.connect()
        print("successfully connected to database")
        connection.close
    except Exception as e:
        print(str(e))
    return engine

def close_connection(engine):
    if engine is not None:
        engine.dispose()
        print("Connection closed")
    else:
        print("Engine is not initialized, no connection to close.")

