import re
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Functions for DataFrames

def remove_spaces_column_names(df):
    '''
    input: df
    output: df with column names without empty spaces
    
    '''
    df.columns = df.columns.str.strip()
    return df.columns

def remove_spaces_columns(df):
    '''
    input: df
    output: df without empty spaces in column cells
    
    '''
    for col in df.select_dtypes(include = 'object'):
        df[col] = df[col].str.strip()
    return df

def any_duplicate(df):
    '''
    input: df
    output: boolean answer for: is there any duplicate?
    
    '''
    return df.duplicated().any()

def specific_duplicates(df, cols):
    '''
    input: df and a list with the names of the columns to check, ex: ['col1', 'col2']
    output: a dataframe with the duplicates
    
    '''
    duplicates = df.duplicated(subset = cols, keep = False)
    return df[duplicates]

def drop_duplicates(df):
    '''
    input: df
    output: df without duplicates
    
    '''
    return df.drop_duplicates(inplace = True)

def nan(df):
    '''
    input: df
    output: list with the column name and the amount of NaN values
    '''
    return df.isna().sum().sort_values(ascending = False)

def view_nan(df: pd.DataFrame) -> None:
    """
    input: df
    output: plot of NaN values per column
    """
    plt.figure(figsize = (10, 6), facecolor = 'none') 
    sns.heatmap(df.isna(),           
                yticklabels = False,  
                cmap = 'magma',     
                cbar = False)
    plt.show();

def low_variance(df):
    """
    input: df
    output: list of names of columns with low variance
    """
    low_variance = []
    for col in df.select_dtypes(include = np.number): 
        minimo = df[col].min()
        maximo = df[col].max()
        per_90 = np.percentile(df[col], 90)
        per_10 = np.percentile(df[col], 10)
        if minimo == per_90 or maximo == per_10:
            low_variance.append(col)
    return low_variance

def constant_columns(df):
    """
    input: df
    output: 2 lists of names of constant columns 
    """
    cte_cols = []
    cte_str_cols = []
    for col in df.select_dtypes(include = np.number):
        if len(df[col].unique()) == 1:
            cte_cols.append(col)          
    for col in df.select_dtypes(include = 'object'):
        if len(df[col].unique()) == 1:
            cte_str_cols.append(col)
    return cte_cols, cte_str_cols

def find_special_chars(df, patron = r'[?¿*$%&]'):
    '''
    input: df
    output: a str with column, row and special char
    '''
    try:
        for col in df.select_dtypes(include = 'object').columns:
            for i in range(len(df)):
                value = df.loc[i, col]
                weird_chars = re.findall(patron, value)
                if weird_chars:
                    print(f"Columna: {col} | Fila: {i} | Caracteres raros: {weird_chars}")
    except:
        pass

def unique_values(df):
    '''
    input: df
    output: a list with the column name and the amount of unique values
    '''
    return sorted([(col, len(df[col].unique())) for col in df.columns], key = lambda x: x[1])