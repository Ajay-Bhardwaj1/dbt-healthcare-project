import zipfile
import os
import glob
import duckdb

# ---------- CONFIG ----------
ZIP_PATH    = r"C:\Users\ajayk\Downloads\dataset-healthcare\synthea_sample_data_csv_nov2021.zip"
EXTRACT_TO  = r"C:\Users\ajayk\Downloads\dataset-healthcare\extracted"
DUCKDB_PATH = r"C:\Users\ajayk\OneDrive\Documents\GitHub\dbt-healthcare\healthcare.duckdb"

# ---------- STEP 1: UNZIP ----------
def unzip_data():
    os.makedirs(EXTRACT_TO, exist_ok=True)
    with zipfile.ZipFile(ZIP_PATH, 'r') as z:
        z.extractall(EXTRACT_TO)
    print(f"Unzipped to: {EXTRACT_TO}")

# ---------- STEP 2: FIND CSV FILES ----------
def find_csvs():
    csv_files = glob.glob(os.path.join(EXTRACT_TO, "**", "*.csv"), recursive=True)
    print(f"Found {len(csv_files)} CSV files")
    return csv_files

# ---------- STEP 3: LOAD EACH CSV INTO DUCKDB (DuckDB reads directly) ----------
def load_to_source(csv_files):
    con = duckdb.connect(DUCKDB_PATH)
    con.execute("CREATE SCHEMA IF NOT EXISTS source")

    for path in csv_files:
        table_name = os.path.splitext(os.path.basename(path))[0].lower()
        safe_path = path.replace("\\", "/")
        con.execute(f"""
            CREATE OR REPLACE TABLE source.{table_name} AS
            SELECT * FROM read_csv_auto('{safe_path}', header=true, all_varchar=true)
        """)
        cnt = con.execute(f"SELECT COUNT(*) FROM source.{table_name}").fetchone()[0]
        print(f"Loaded source.{table_name:<25} rows: {cnt}")

    con.close()
    print("\nAll files loaded into DuckDB 'source' schema.")

if __name__ == "__main__":
    unzip_data()
    files = find_csvs()
    load_to_source(files)
