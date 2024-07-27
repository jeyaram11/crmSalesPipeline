import os

import pandas as pd
import yaml

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
print(df)