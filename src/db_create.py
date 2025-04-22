"""
This script contains the template for generating the db schema template for the liposome IVR database. 
The template can be adapated to other nanomedicine dosage forms, by replacing the CPP and CQA-related fields with system-specific columns.
 
"""

from config import conn, cur

cur.execute("PRAGMA foreign_keys = ON;")

cur.execute("""
    CREATE TABLE IF NOT EXISTS papers (
        ID INTEGER PRIMARY KEY,
        title text,
        yr INTEGER,
        pdf BLOB,
        num_formulations INTEGER,
        search_ID INTEGER, 
        pdf_name TEXT, 
        doi TEXT,
    FOREIGN KEY (search_ID) REFERENCES search_terms(ID)
    )""")


cur.execute("""
    CREATE TABLE IF NOT EXISTS search_terms (
        ID INTEGER PRIMARY KEY,
        terms text,
        db text,
        where_words_occur text,
        results INTEGER, 
        comments TEXT
    )""")

cur.execute("""
    CREATE TABLE IF NOT EXISTS formulation_composition (
        ID INTEGER PRIMARY KEY AUTOINCREMENT, 
        component_ID INTEGER,
        molar_ratio REAL,
        formulation_ID INTEGER,
    FOREIGN KEY (formulation_ID) REFERENCES formulation (ID)
    FOREIGN KEY (component_ID) REFERENCES component_name (ID)
    )""")

cur.execute("""
    CREATE TABLE IF NOT EXISTS component_name (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        component_name TEXT UNIQUE
    )""")

cur.execute("""
    CREATE TABLE IF NOT EXISTS component_properties (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        component_ID INTEGER,
        property_name TEXT,
        property_value REAL,
    FOREIGN KEY (component_ID) REFERENCES component_name (ID)
    )""")

cur.execute("""
    CREATE TABLE IF NOT EXISTS formulation (
        ID INTEGER PRIMARY KEY,
        API_ID INTEGER,
        formulation_type text,
        paper_id INTEGER,
    FOREIGN KEY (paper_id) REFERENCES papers(ID)
    FOREIGN KEY (API_ID) REFERENCES API_name (ID)
    )""")

cur.execute("""
    CREATE TABLE IF NOT EXISTS formulation_CPPs_CQAs (
        ID INTEGER PRIMARY KEY,
        formulation_ID INTEGER,
        drug_loading REAL,
        preparation_method TEXT,
        encapsulation_method TEXT,
        incubation_temp_oC INTEGER,
        incubation_time_Hrs INTEGER,
        comments TEXT,
        PS_instrument TEXT,
        size_distribution TEXT,
        measurement_angle_0 INTEGER,
        structure_type TEXT,
        particle_size_nm REAL,
        PDI REAL, 
        zeta_potential REAL,
        weighted_Tm REAL,
    FOREIGN KEY (formulation_ID) REFERENCES formulation (ID)
    )""")

cur.execute("""
    CREATE TABLE API_name (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        API_name TEXT UNIQUE, 
        SMILES TEXT)
    )""")

cur.execute("""
    CREATE TABLE media_components (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        IVR_ID INTEGER,
        component_name TEXT,
        media_concentration_mM REAL, 
        media_concentration_percent,
    FOREIGN KEY (IVR_ID) REFERENCES IVR (ID)    
    )""")

cur.execute("""
    CREATE TABLE IVR (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        image_name TEXT,
        formulation_ID INTEGER,
        formulation_name TEXT,
        release_method TEXT,
        drug_addition_vol_mL REAL,
        stirring_rpm REAL,
        aliquot_vol_mL REAL,
        test_duration_Hrs REAL,
        dilution_media TEXT,
        dilution_factor REAL,
        post_sampling_treatment TEXT,
        centrifuge_rpm REAL,
        centrifuge_time_min REAL,
        supernatant_aliquot_uL REAL,
        detection_method TEXT, 
        media_volume_mL REAL, 
        media_pH REAL, 
        media_temp_oC REAL, 
        media_comp TEXT, 
        Time_units REAL,
    FOREIGN KEY (formulation_ID) REFERENCES formulation (ID)
    )""")

conn.commit()
conn.close()