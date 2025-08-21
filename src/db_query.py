import sqlite3
import pandas as pd
from rdkit.Chem import Descriptors

def create_combined_df(features_IVR: str, features_CQAs: list, conn: sqlite3.Connection) -> pd.DataFrame:
    """
    Combines the CQAs table with the IVR table based on user selected features.
    
    Parameters:
    - features_IVR (str): Comma-separated feature names from the IVR table.
      Example: "release_method, media_pH, media_temp_oC"
      
    - features_CQAs (list): List of feature names from the CQAs table.
      Example: ['drug_loading', 'structure_type', 'Z_average_nm']
      
    - conn (sqlite3.Connection): SQLite database connection object.

    Returns:
    - pd.DataFrame: A pandas DataFrame containing the selected features along with the formulation ID.
    """

    # Format CQAs feature names to match database column names
    formatted_CQAs = [f'formulation_CPPs_CQAs.{feature}' for feature in features_CQAs]
    
    # Convert the list of CQAs into a comma-separated string
    CQA_string = ", ".join(formatted_CQAs)
    
    # Combine IVR features and formatted CQA features into a single query string
    selected_columns = f"{features_IVR}, {CQA_string}"

    # Construct SQL query to join IVR and CQAs tables based on formulation_ID
    query = f"""
        SELECT 
            IVR.formulation_ID, 
            {selected_columns}
        FROM 
            IVR
        JOIN 
            formulation_CPPs_CQAs
        ON 
            formulation_CPPs_CQAs.formulation_ID = IVR.formulation_ID;
    """

    try:
        return pd.read_sql(query, conn)
    except sqlite3.OperationalError as e:
        print(f"SQL Error: {e}")
        return None



def prepare_heatmap_counts(df, drug_col, method_col, pivot=False, add_totals=False):
    """
    Convert a two-column dataframe (drug_col, method_col)
    into counts suitable for heatmap plotting.
    
    Parameters
    ----------
    df : pd.DataFrame
        Input dataframe with at least two columns: [drug_col, method_col].
    drug_col : str
        Column name containing drug names.
    method_col : str
        Column name containing release method names.
    pivot : bool, default=False
        If False, return long-format dataframe [drug_col, method_col, 'count'].
        If True, return wide matrix with drugs as rows and methods as columns.
    add_totals : bool, default=False
        If True (with pivot=True), add row/column totals.
    
    Returns
    -------
    pd.DataFrame
        Either long-format or matrix form (with optional totals).
    """
    # Count occurrences
    counts = (
        df.groupby([drug_col, method_col])
        .size()
        .reset_index(name="count")
    )

    # All possible combinations
    all_combos = pd.MultiIndex.from_product(
        [df[drug_col].unique(), df[method_col].unique()],
        names=[drug_col, method_col]
    ).to_frame(index=False)

    counts_full = (
        all_combos
        .merge(counts, on=[drug_col, method_col], how="left")
        .fillna({"count": 0})
    )

    if pivot:
        matrix = counts_full.pivot(index=drug_col, columns=method_col, values="count").fillna(0)
        if add_totals:
            # Add row totals
            matrix["Total"] = matrix.sum(axis=1)
            # Add column totals (including row totals)
            matrix.loc["Total"] = matrix.sum()
        return matrix
    else:
        return counts_full



def calc_value_distribution(column_name, df):
    count = df[column_name].value_counts()
    percent = round((count / len(df)) * 100, 2)
    return pd.DataFrame({'Count': count, 'Percent': percent})


#function for obtaining full set of molecular descriptors for each SMILES string
def getMolDescriptors (mol, missingVal = None):
    """Calculate full list of molecular descriptors for a given molecule,
    using RDKit.  Missing val used if descriptor cannot be calculated.  
    Args:
        mol (string): smiles string
        missingVal (optional): Defaults to None.
    """
    res = {}
    for nm, fn in Descriptors._descList:
        try: 
            val = fn(mol)
        except:
            #print error 
            import traceback 
            traceback.print_exc()
            #set descriptor value to whatever missingval is 
            val = missingVal
        res[nm] = val 
    return res