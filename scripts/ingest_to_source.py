import zipfile
import os
import glob
from pyspark.sql import SparkSession
import duckdb

# ---------- CONFIG ----------
ZIP_PATH = r"C:\Users\ajayk\Downloads\dataset-healthcare\synthea_sample_data_csv_nov2021.zip"
EXTRACT_TO = r"C:\Users\ajayk\Downloads\dataset-healthcare\extracted"
DUCKDB_PATH = r"C:\Users\ajayk\OneDrive\Documents\dbt-healthcare\healthcare.duckdb"

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

# ---------- STEP 3: LOAD EACH CSV INTO DUCKDB AS SOURCE TABLE ----------
def load_to_source(csv_files):
    spark = SparkSession.builder.master("local[*]").appName("ingest").getOrCreate()
    con = duckdb.connect(DUCKDB_PATH)
    con.execute("CREATE SCHEMA IF NOT EXISTS source")

    for path in csv_files:
        table_name = os.path.splitext(os.path.basename(path))[0].lower()
        df = spark.read.csv(path, header=True, inferSchema=True)
        row_count = df.count()
        pdf = df.toPandas()
        con.execute(f"CREATE OR REPLACE TABLE source.{table_name} AS SELECT * FROM pdf")
        print(f"Loaded source.{table_name:<25} rows: {row_count}")

    con.close()
    spark.stop()
    print("\nAll files loaded into DuckDB 'source' schema.")

# ---------- STEP 4: VERIFY WHAT LOADED ----------
def verify():
    con = duckdb.connect(DUCKDB_PATH)
    tables = con.execute(
        "SELECT table_name FROM information_schema.tables WHERE table_schema='source' ORDER BY table_name"
    ).fetchall()
    print(f"\n--- Verification: {len(tables)} tables in 'source' schema ---")
    for (t,) in tables:
        cnt = con.execute(f"SELECT COUNT(*) FROM source.{t}").fetchone()[0]
        print(f"  source.{t:<25} rows: {cnt}")
    print(f"\nDuckDB file location: {DUCKDB_PATH}")
    con.close()

if __name__ == "__main__":
    unzip_data()
    files = find_csvs()
    load_to_source(files)
    verify()