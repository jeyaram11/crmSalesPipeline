import sys

import yaml
import pandas as pd

try:
    full_cmd_arguments = sys.argv
    user_input = full_cmd_arguments[1]
except:
    user_input = input('Please enter filename')

print(user_input)
