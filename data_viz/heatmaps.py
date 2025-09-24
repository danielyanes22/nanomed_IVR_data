import pandas as pd 
import seaborn as sns
import matplotlib.pyplot as plt

heatmap_df_release_method = pd.read_csv('data/processed/test_heatmap_counts.csv', index_col=0)
heatmap_df_mediacomponents = pd.read_csv('data/unprocessed/media_components_API.csv')

#plot API-release method heatmap
plt.figure(figsize=(7, 5))
sns.heatmap(heatmap_df_release_method, annot=True, fmt="g", cmap="Reds", cbar=True)
plt.ylabel("Drug compound", fontsize = 11, fontweight = "bold")
plt.xlabel("Release Method", fontsize = 11, fontweight = "bold")
plt.tight_layout()
plt.savefig('figures/API_release_method_heatmap.png', dpi=600, bbox_inches='tight')

#Count unique (API, Component) pairs across IVRs
heatmap_data = heatmap_df_mediacomponents.groupby(["component_name", "API_name", "IVR_ID"]).size().reset_index(name="count")
heatmap_data = heatmap_data.groupby(["component_name", "API_name"]).size().reset_index(name="count")
heatmap_matrix = heatmap_data.pivot(index="API_name", columns="component_name", values="count").fillna(0)
heatmap_matrix.loc["Total"] = heatmap_matrix.sum(axis=0)
heatmap_matrix["Total"] = heatmap_matrix.sum(axis=1)


#Plot heatmap
plt.figure(figsize=(10, 6))
sns.heatmap(heatmap_matrix, annot=True, fmt=".0f", cmap="Reds", cbar=True, annot_kws={"size": 7})

plt.xlabel("Media component", fontsize=12, fontweight="bold")
plt.ylabel("Drug compound", fontsize=12, fontweight="bold")
plt.xticks(rotation=45, ha="right", fontsize=10)
plt.yticks(rotation=0, fontsize=10)
plt.tight_layout()
plt.savefig('figures/API_media_components_heatmap.png', dpi=600, bbox_inches='tight')
