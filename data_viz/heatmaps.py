import pandas as pd 
import seaborn as sns
import matplotlib.pyplot as plt

heatmap_df = pd.read_csv('data/processed/test_heatmap_counts.csv', index_col=0)



plt.figure(figsize=(6, 5))
sns.heatmap(heatmap_df, annot=True, fmt="g", cmap="Reds", cbar=True)


plt.ylabel("Drug compound", fontsize = 12, fontweight = "bold")
plt.xlabel("Release Method", fontsize = 12, fontweight = "bold")
plt.tight_layout()
plt.show()



