![repo version](https://img.shields.io/badge/Version-v.1.0-green)
![python version](https://img.shields.io/badge/python-3.12.1-blue)
![R version](https://img.shields.io/badge/R-4.3.0-orange)
![license](https://img.shields.io/badge/License-CC--BY-red)


<h2 id="Title">Making <em>in vitro</em> release and formulation data AI-ready: A foundation for streamlined nanomedicine development</h2>


**Daniel Yanes**<sup>1</sup>, **Heather Mead**<sup>2</sup>, **James Mann**<sup>2</sup>, **Magnus Röding**<sup>3,4</sup>, **Vasiliki Paraskevopoulou**<sup>2</sup>, **Cameron Alexander**<sup>1</sup>, **Maryam Parhizkar**<sup>5*</sup>, **Jamie Twycross**<sup>6*</sup>, **Mischa Zelzer**<sup>1*</sup>

<sup>1</sup>School of Pharmacy, University of Nottingham, University Park Campus, Nottingham, NG7 2RD, UK\
<sup>2</sup>Global Product Development, Pharmaceutical Technology & Development, Operations, AstraZeneca, Macclesfield, SK10 2NA, UK\
<sup>3</sup>Sustainable Innovation & Transformational Excellence, Pharmaceutical Technology & Development, Operations, AstraZeneca, Gothenburg, 43183 Mölndal, Sweden\
<sup>4</sup>Department of Mathematical Sciences, Chalmers University of Technology and University of Gothenburg, 41296 Göteborg, Sweden\
<sup>5</sup>School of Pharmacy, University College London, 29-39 Brunswick Square, London, WC1N 1AX, UK\
<sup>6</sup>School of Computer Science, University of Nottingham, Jubilee Campus, Wollaton Road, Nottingham, NG8 1BB, UK\
<sup>\*</sup>Corresponding authors: mischa.zelzer@nottingham.ac.uk; jamie.twycross@nottingham.ac.uk; maryam.parizkar@ucl.ac.uk

**Abstract**\
Machine learning and artificial intelligence (AI) is transforming the way pharmaceutical products are developed across drug discovery, process engineering, and pharmaceutics functions. AI for nanomedicine development is enabling faster and more accurate prediction of critical quality attributes (CQAs). However, the full potential of AI is limited by the quality and accessibility of data. Unlike adjacent fields such as the chemical sciences, the pharmaceutics domain lacks curated, open-access databases, particularly for nanomedicines. To address this, here we curate an open-access database focused on liposomal formulations. The database includes formulation parameters, in vitro release (IVR) testing conditions, and digitised drug release data. By evaluating the entries in the database qualitatively and quantitatively, we identified current challenges in current data reporting practices. This includes incomplete reporting of formulation and IVR testing conditions, as well as inconsistent quality of drug release plots and their data format. Based on our analysis, we propose a set of data standards and a database structure to support standardisation efforts for nanomedicine formulation and IVR data. By making the curated database open-access, we aim to improve data transparency and accessibility in the field. This will ultimately facilitate the development of robust AI models for IVR and CQA prediction, streamlining nanomedicine development. 

**Graphical Abstract**\
![Figure 1](figures/graphical_abstract.png?raw=true "Graphical Abstract")


<!-- Prerequisites-->
<h2 id="Prerequisites">Prerequisites</h2>

The following key Python and R packages are required to reproduce the analysis, results, and figures in the manuscript:

- [Pandas](https://pandas.pydata.org/) (2.2.3)  
- [Numpy](https://numpy.org/) (2.2.4)  
- [matplotlib](https://matplotlib.org/) (3.10.1)  
- [seaborn](https://scikit-learn.org/) (0.13.2)  
- [missingno](https://pypi.org/project/missingno/) (0.5.2)  
- [tidyverse](https://www.tidyverse.org/packages/) (2.0.0)  
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) (1.1.3)  
- [patchwork](https://cran.r-project.org/web/packages/patchwork/index.html) (1.2.0)  


<h2 id="Installation">Installation</h2>
Install Python and R package depedencies from the `requirements.txt` and `R_requirements.txt` files. The code was tested on Microsoft Windows 10, Version 22H2.

```
pip install -r requirements.txt
```

<!-- Content-->
<h2 id="content">Project structure</h2>
This following folder structure gives an overview of the repository:

<pre>
├── data/
│   ├── drug_release/ #file names of each digitised drug release profile based on IVR_ID     
│   ├── processed/  #datasets for visualisation in R
│   ├── unprocessed/ #backend and media components datasets
│   ├── liposome_IVR.db #store db file here  
├── data_viz/ #scripts for generating figures
├── figures/ 
├── main.py #database connection and SQL queries for generating datasets for analysis and plotting
├── src/ #helper functions connecting to the db and generating db schema
</pre>

<h2 id="content">Connecting to the database, querying database to generate backend dataset and subsequent figures</h2> 
Run `main.py` to generate the datasets for plotting followed by appropriate Python / R scripts in 'data_viz/'. Ensure files are structured as downloaded from the Nottingham Research Data Management Repository, specifically place the 'liposome_IVR.db' file in the 'data/' folder. 


<h2 id="content">Generating database schema for storing IVR and formulation data on different nanomedicine dosage forms</h2> 
In 'src/db_create.py' is the code used to generate the database structure used for storing information on liposome formulations and their drug release profiles. This template can be used for storing similar data on other nanomedicine dosage forms in a standardised format. 

**Database structure**\
![Figure 2](figures/figure_2.PNG?raw=true "Liposome IVR database structure")

**Open-access database**\
The liposome IVR database, digitised drug release data and full code base is deposited on the Nottingham Research Data Management Repository, which can be accessed using the link below. 

```
http://doi.org/10.17639/nott.7542
```

<!-- How to cite-->
<h2 id="How-to-cite">How to cite</h2>
**Add DOI from Nottingham repo**

<!-- License-->
<h2 id="License">License</h2>
This codebase is under a CC-BY license. 