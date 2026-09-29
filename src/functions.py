"""Your reusable functions live here.

The rule from the brief: Python logic goes in `.py` files, SQL goes in `.sql`
files, and the notebooks hold the narrative. The moment a cell grows past a few
lines, or you find yourself pasting it a second time, move it here and call it
from the notebook.

To use this module from a notebook in `notebooks/`:

    import sys
    sys.path.append("..")
    from src.functions import *

The three below are only there to show the shape. Rename them, change the
arguments, write your own. This is a starting point, not an interface you have
to implement.
"""

from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt

from scipy.stats import chi2_contingency
from scipy.stats.contingency import association

import sqlite3

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
CLEAN = ROOT / "data" / "clean"
DB = ROOT / "data" / "project.db"


def clean_data(drop_col, df):
    """
        Add Explanation
    """

    print(f"Columns before: {df.shape[1]}")

    df_clean = pd.DataFrame(df.drop(columns=drop_col))
    print(f"Columns after: {df_clean.shape[1]}")
    return df_clean
    pass


def make_lookup(df, col, id_name):
    """
        Add Explanation
    """
    labels = sorted(df[col].unique())
    return pd.DataFrame(
        {
            id_name: range(1, len(labels) + 1),
            col: labels
        }
    )
    pass


def run_query(sql, db_path=DB):
    """Run a query against the database and return the result as a DataFrame."""
    conn = sqlite3.connect(db_path)
    result = pd.read_sql(sql, conn)
    conn.close()
    return result
    pass

def analyze_categorical_vs_purchase(df, col, target='Purchase_Flag'):
    """
    Docstring for analyze_categorical_vs_purchase
    
    :param df: Description
    :param col: Description
    :param target: Description
    """
    prop = pd.crosstab(df[col], df[target], normalize=True).round(2)
    display(prop)

    # Analysis of the relationship between these two categorical variables
    freq = pd.crosstab(df[col], df[target])

    # Visualizing the crosstab result with a bar chart
    freq.plot(kind='bar')
    plt.title(f"{col} by {target}")
    plt.ylabel(f"{target} count")
    plt.show()


    #Chi2 Test
    _,chi2_pvalue, _, _ = chi2_contingency(freq)
    if chi2_pvalue < 0.05:
        print(f"The p-value is {chi2_pvalue:.3f}, there is a significant association between {target} and {col}.")
    elif chi2_pvalue >= 0.05:
        print(f"The p-value is {chi2_pvalue:.3f}, and there isn't a significant association between {target} and {col}.")

    #Cramer
    cramers_v = association(freq, method='cramer')
    if cramers_v < 0.1:
        label = "Very weak"
    elif cramers_v < 0.2:
        label = "Weak"
    elif cramers_v < 0.3:
        label = "Moderate"
    elif cramers_v < 0.5:
        label = "Strong"
    else:
        label = "Very strong"
    print(f"Cramer's V = {cramers_v:.3f}: {label} association")
    print("\n")

def analyze_numerical(df):   
    mean_df = df.mean().round(2)
    median_df = df.median().round(2)
    mode_df = df.mode().iloc[0].round(2)
    print(f"Measures of Centrality, Mean: {mean_df}, Median: {median_df}, Mode: {mode_df}")

    # Measures of Dispersion for Ratings
    dispersion_df = df.describe().round(2)
    var_df = df.var().round(2)
    std_df = df.std().round(2)
    range_df = df.max().round(2) - df.min().round(2)
    iqr_df = (df.quantile(0.75) - df.quantile(0.25)).round(2)

    print(
        f"Measures of Dispersion for, Variance: {var_df}, Standard Deviation: {std_df}, Range: {range_df}, Interquartile Range: {iqr_df}"
    )