import os 
import numpy as np 
import pandas as pd 

def convert_txt_to_df(column_name:str,txt_file:str)->pd.DataFrame:
    df = pd.read_csv(txt_file,header=None,names=[column_name])
    return df