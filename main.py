import pandas as pd
from src import (conn, create_combined_df, calc_value_distribution, getMolDescriptors)
from rdkit import Chem

### Run from root directory: 'py -m experiments.generate_backend_df' ###

# ---- Step 1: Retrieve API information and Join with IVR Table ----
api_query = f"""SELECT 
                IVR.ID,
                IVR.formulation_ID, 
                formulation.API_ID
            FROM 
                IVR 
            JOIN 
                formulation 
            ON 
                formulation.ID = IVR.formulation_ID;"""

API_df = pd.read_sql(api_query, conn)
API_df = pd.DataFrame(API_df)
API_df = API_df.rename(columns = {'ID': 'IVR_ID'})

# Retrieve API names
API_name_query = f"""SELECT 
                ID,
                API_name,
                SMILES
            FROM
                API_name;"""

#calculate molecular descriptors here 
smiles_df = pd.read_sql(API_name_query, conn)
smiles_df['SMILES'] = smiles_df['SMILES'].astype(str)

mol_descriptors = []
for smile in smiles_df['SMILES']:
    mol = Chem.MolFromSmiles(smile)
    mol_descriptors.append(getMolDescriptors(mol))
    
mol_descriptors_df = pd.DataFrame(mol_descriptors)

#Add API_ID to mol_descriptors_df 
mol_descriptors_df = pd.concat([mol_descriptors_df, smiles_df], axis = 1, join = "inner")
#remove smiles column from mol_descriptors_df
mol_descriptors_df = mol_descriptors_df.drop(columns = ['SMILES'])
#move ID column to front of dataframe
ID = mol_descriptors_df['ID']
mol_descriptors_df = mol_descriptors_df.rename(columns = {'ID': 'API_ID'})

#selecting specific mol descriptors 
mol_desc_df = mol_descriptors_df[['API_ID', 'API_name', 'MolWt', 'TPSA', 'NumHAcceptors', 'NumHDonors',
                                  'NumRotatableBonds', 'MolLogP']]


#Merge API information into a single dataframe
API_df_name = pd.read_sql(API_name_query, conn)
API_df_name = API_df_name.rename(columns = {'ID': 'API_ID'})
API_df_name = pd.merge(API_df, API_df_name, on = 'API_ID')
API_df_name = API_df_name.drop(columns = ['formulation_ID'])

#add mol_desc_df to API_df_name
API_df_name = pd.merge(API_df_name, mol_desc_df, on='API_ID')
API_df_name = API_df_name.drop(columns='API_name_y')  # Keep only one
API_df_name = API_df_name.rename(columns={'API_name_x': 'API_name'})

print('Prepared API dataframe!')

# ---- Step 2: Generate unprocessed backend dataframe ----

# Define IVR features to be included in the dataframe
features_IVR_all = f"""IVR.ID, release_method, media_pH, media_temp_oC, media_volume_mL""" #input as string
features_CQAs_all = ['drug_loading','structure_type', 'Z_average_nm', 'PDI', 'zeta_potential'] #input as list 

df_all = create_combined_df(features_IVR_all, features_CQAs_all, conn).rename(columns = {'ID': 'IVR_ID'})

#Merge API information and weighted properties into a single dataframe
df_all_combined = pd.merge(df_all, API_df_name, on = 'IVR_ID')


#Export the time units of each IVR profile (IVR_ID) to a csv file 
time_query = """
            SELECT 
                ID, Time_units
            FROM 
                IVR
     """

time_units = pd.read_sql(time_query, conn)

# ---- Step 3: Calculate % frequency of API and release_method ----
API_percent = calc_value_distribution('API_name', df_all_combined)
method_percent = calc_value_distribution('release_method', df_all_combined)

if __name__ == "__main__":
    mol_desc_df.to_csv('data/processed/mol_descriptors.csv', index=False)
    time_units.to_csv('data/time_units.csv', index=False)
    df_all_combined.to_csv('data/unprocessed/backend_data.csv')
    API_percent.to_csv('data/processed/API_percent.csv', index=True)
    method_percent.to_csv('data/processed/method_percent.csv', index=True)
    