# import all libaries
import yaml
import sqlalchemy
import psycopg2
credentials_file = 'credentials.yaml'


# function to create a connection to mysql server
def postgresql_connection():
    credentials = yaml.safe_load(open(credentials_file))
    connection_to = 'crm_sales_pipeline'
    username = credentials[connection_to]['username']
    password = credentials[connection_to]['password']
    hostname = credentials[connection_to]['hostname']
    port = credentials[connection_to]['port']
    database = credentials[connection_to]['database']
    global engine

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