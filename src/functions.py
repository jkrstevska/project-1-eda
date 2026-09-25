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

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
CLEAN = ROOT / "data" / "clean"
DB = ROOT / "data" / "project.db"


def clean_data(df):
    """Fix the problems you found in notebook 01."""

    ## Make a list of all the columns that need to be dropped from the raw dataset
    num_cols_drop = ["Attention_Weight", "Embedding_Similarity_Score", "Q_Value_Score",
        "Reward_Score", "Candidate_Rank", "Retrieval_Latency_ms",
        "Ranking_Stability_Score", "Current_Ranking_Position",
        "User_Node_Degree", "Item_Node_Degree", "Common_Neighbor_Count",
        "Distance_Score", "Candidate_Recall_Score", "User_Item_Affinity_Score"]
    df = df.drop(columns= num_cols_drop)
    pass


def make_lookup(df, column):
    """Turn a repeated categorical column into its own table with an id."""
    pass


def run_query(sql, db_path=DB):
    """Run a query against the database and return the result as a DataFrame."""
    pass
