import duckdb

DUCKDB_PATH = r"C:\Users\ajayk\OneDrive\Documents\GitHub\dbt-healthcare\healthcare.duckdb"

con = duckdb.connect(DUCKDB_PATH)

tables = con.execute(
    "SELECT table_name FROM information_schema.tables WHERE table_schema='source' ORDER BY table_name"
).fetchall()

print(f"--- {len(tables)} tables in 'source' schema ---")
for (t,) in tables:
    cnt = con.execute(f"SELECT COUNT(*) FROM source.{t}").fetchone()[0]
    print(f"  source.{t:<25} rows: {cnt}")

con.close()