import numpy as np 
from src import file_names
import os
import matplotlib.pyplot as plt

#Py -m experiments.data_points to run 

data_point_counts = []

for file_name in file_names:
    full_path = os.path.join("data", "drug_release", file_name)
    drug_release_plot = np.genfromtxt(full_path, delimiter=',')
    
    num_points = drug_release_plot.shape[0]
    data_point_counts.append(num_points)
    
# Plot the histogram
plt.figure(figsize=(8, 5))
plt.hist(data_point_counts, bins='auto', color='skyblue', edgecolor='black')
plt.ylabel("Number of digitised drug release files")
plt.xlabel("Number of release time points")
plt.grid(True, linestyle='--', alpha=0.5)
plt.tight_layout()
plt.savefig('figures/figure_S1.png', dpi=600, bbox_inches='tight')
plt.close()