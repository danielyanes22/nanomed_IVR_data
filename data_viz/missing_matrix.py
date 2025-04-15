import pandas as pd 
import numpy as np
import missingno as msno
import matplotlib.pyplot as plt

backend_df = pd.read_csv('data/unprocessed/backend_data.csv')

#convert all NULL values to NaN 
backend_df = backend_df.fillna(np.nan)
backend_df_reduced = backend_df.iloc[:,4:12]
backend_df_reduced = backend_df_reduced.drop(columns=['structure_type'])

#multiply everything in the drug_loading column by 100 to convert to %
backend_df_reduced['drug_loading'] = backend_df_reduced['drug_loading'] * 100
backend_df_reduced['drug_loading'] = backend_df_reduced['drug_loading'].round(2)

print("Number of rows in the dataframe: ", backend_df_reduced.shape[0])

#change column names of zeta_potential to zeta potential / mV
backend_df_reduced = backend_df_reduced.rename(columns = {'zeta_potential': 'Zeta potential / mV'})
backend_df_reduced = backend_df_reduced.rename(columns = {'Z_average_nm': 'Particle size / nm'})
backend_df_reduced = backend_df_reduced.rename(columns = {'media_pH': 'Media pH'})
backend_df_reduced = backend_df_reduced.rename(columns = {'media_temp_oC': 'Media temp / °C'})
backend_df_reduced = backend_df_reduced.rename(columns = {'media_volume_mL': 'Media volume / mL'})
backend_df_reduced = backend_df_reduced.rename(columns = {'drug_loading': 'Drug-lipid / %'})

#check for missing values in the dataframe

#count number of missing values in each column
missing_data = backend_df_reduced.isnull().sum()

#calculate as a percentage of the total number of rows
total = backend_df_reduced.isnull().sum().sort_values(ascending=False)
percent = (backend_df_reduced.isnull().sum()/backend_df_reduced.isnull().count()).sort_values(ascending=False) * 100
missing_data = pd.concat([total, percent], axis=1, keys=['Total', 'Percent'])

missing_data.to_csv('data/processed/missing_data.csv', index=True)

# Generate the missing value matrix
msno.matrix(backend_df_reduced, fontsize=16, figsize=(16, 12), color=(0.2, 0.4, 0.6))
plt.ylabel('IVR ID', fontsize=16)

plt.savefig('figures/missing_matrix.png', dpi=600, bbox_inches='tight')
plt.close()

