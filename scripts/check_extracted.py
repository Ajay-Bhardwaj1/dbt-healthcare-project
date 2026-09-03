import glob
import os


EXTRACTED_TO = r"C:\Users\ajayk\Downloads\dataset-healthcare\extracted\csv"
csv_files = glob.glob(os.path.join(EXTRACTED_TO, "**", "*.csv"), recursive= True)
print(f"Found {len(csv_files)} CSV files:\n")
for f in csv_files:
    size_mb = os.path.getsize(f) / (1024*1024)
    print(f" {os.path.basename(f):<30} {size_mb:>8.2f} MB ({f})")
