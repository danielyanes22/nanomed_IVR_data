import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

# Set seaborn style for publication aesthetics
sns.set(style='darkgrid')

# Load data
backend_df = pd.read_csv('data/unprocessed/backend_data.csv')

# Create KDE jointplot with a clean colormap and filled contours
g = sns.jointplot(
    data=backend_df,
    x='media_temp_oC',
    y='media_pH',
    kind='kde')

# Axis labels with units
g.ax_joint.set_xlabel('Media Temperature (°C)', fontsize=14)
g.ax_joint.set_ylabel('Media pH', fontsize=14)

# Axis limits
g.ax_joint.set_ylim(5, 9)

# Ticks and labels
g.ax_joint.tick_params(axis='both', labelsize=12)

sns.despine(ax=g.ax_joint, trim=True)
sns.despine(ax=g.ax_marg_x, left=True)
sns.despine(ax=g.ax_marg_y, bottom=True)

# Save as PNG
g.fig.savefig('figures/IVR_testingspace.png', dpi=600, bbox_inches='tight')
