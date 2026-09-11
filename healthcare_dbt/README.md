# 🏥 Healthcare Data Pipeline

<p align="center">
  <img src="https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white" />
  <img src="https://img.shields.io/badge/DuckDB-FFF000?style=for-the-badge&logo=duckdb&logoColor=black" />
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/Tests-18%20Passing-brightgreen?style=for-the-badge" />
</p>

<p align="center">
  <b>A production-grade ELT pipeline transforming 18 raw clinical sources into a tested, documented dimensional warehouse.</b>
</p>

---

## 🏗️ Architecture



╔══════════════════════════════════════════════════════════════╗

║                                                              ║

║   📦 18 Synthea CSV Files (700MB+)                          ║

║       │                                                      ║

║       ▼                                                      ║

║   🔹 INGESTION ─────────────── Python + DuckDB              ║

║       │  Automated unzip → load via read_csv_auto()          ║

║       │  18 raw tables → source schema                       ║

║       ▼                                                      ║

║   🔸 PSA (Silver) ─────────── dbt (incremental)             ║

║       │  Column standardization │ Type casting               ║

║       │  Deduplication │ Null handling                       ║

║       ▼                                                      ║

║   🔶 DIMENSIONAL (Gold) ───── dbt                           ║

║       │  4 SCD2 Dimensions + Fact Tables                     ║

║       │  Point-in-time date-range joins                      ║

║       ▼                                                      ║

║   ✅ DATA QUALITY ─────────── 18 automated tests            ║

║       Uniqueness │ Not-null │ Referential integrity          ║

║                                                              ║

╚══════════════════════════════════════════════════════════════╝



---

## 📊 Data Source — Synthea

> **Synthea** is an open-source synthetic patient generator by MITRE, widely used in healthcare data engineering. It simulates realistic patient medical histories — fully synthetic, zero HIPAA restrictions.

| Detail | Value |
|:---|:---|
| **Dataset** | `synthea_sample_data_csv_nov2021.zip` |
| **Volume** | 18 interconnected CSV files, 700MB+ compressed |
| **Domain** | Demographics, encounters, diagnoses, medications, procedures, labs, insurance |
| **Reference** | [📖 Synthea CSV Data Dictionary](https://github.com/synthetichealth/synthea/wiki/CSV-File-Data-Dictionary) |

### Data Relationships


👤 patients

│

└──── 🏥 encounters

│

├──── 🩺 conditions

├──── 💊 medications

├──── 🔬 procedures

├──── 📋 observations

├──── 💉 immunizations

├──── 🫁 allergies

└──── 📄 claims



---

## 🔄 Pipeline Layers

### 🔹 Source Layer (Bronze)

Automated Python ingestion handles the full lifecycle:

> **Unzip → Discover → Load** — all 18 CSVs loaded into DuckDB with `all_varchar=true`, preserving raw data without type-inference assumptions.

<details>
<summary>📋 18 Source Tables Loaded</summary>

`allergies` · `careplans` · `claims` · `claims_transactions` · `conditions` · `devices` · `encounters` · `imaging_studies` · `immunizations` · `medications` · `observations` · `organizations` · `patients` · `payer_transitions` · `payers` · `procedures` · `providers` · `supplies`

</details>

---

### 🔸 PSA Layer (Silver)

| Feature | Implementation |
|:---|:---|
| **Incremental Loading** | High-volume tables (encounters, observations) only process new records — no full rebuilds |
| **Column Standardization** | Synthea's inconsistent naming (camelCase, spaces, underscores) → clean, uniform convention |
| **Type Casting** | Raw varchar → proper dates, numerics, identifiers — explicitly, not by inference |
| **Null Handling** | Controlled treatment of missing values per business rules |

---

### 🔶 Dimensional Model (Gold)

#### ⭐ Dimension Tables — SCD Type 2

> Every dimension tracks historical changes with `VALID_FROM` / `VALID_TO` windows, enabling point-in-time analysis.

| Table | Description |
|:---|:---|
| `dim_patient` | 👤 Patient demographics, geography, identifiers |
| `dim_provider` | 🧑‍⚕️ Clinician details, specialties, linked organizations |
| `dim_organization` | 🏥 Healthcare facilities — hospitals, clinics |
| `dim_payer` | 🏦 Insurance companies and coverage details |

#### 📊 Fact Tables

| Table | Description | Grain |
|:---|:---|:---|
| `fact_encounter` | Patient visits — the central fact, joining all 4 dimensions | One row per encounter |

#### 🔗 Point-in-Time Join Logic

```sql
-- Fact joins to the correct HISTORICAL VERSION of each dimension
left join dim_patient dp
    on e.PATIENT_ID = dp.PATIENT_ID
    and cast(e.START_DATE as date) >= cast(dp.VALID_FROM as date)
    and cast(e.START_DATE as date) < cast(dp.VALID_TO as date)
```

> This ensures each encounter links to the dimension record **as it existed at the time of the visit** — not the current version.

---

## ✅ Data Quality
┌─────────────────────────────────────────┐

│                                         │

│   dbt test  →  PASS = 18  │  FAIL = 0  │

│                                         │

└─────────────────────────────────────────┘



| Test Type | What It Catches |
|:---|:---|
| **Uniqueness** | Duplicate primary keys across dim and fact tables |
| **Not-null** | Missing values in critical columns (keys, dates, IDs) |
| **Referential Integrity** | Orphaned foreign keys — every fact FK points to a valid dimension |
| **Accepted Values** | Invalid entries in categorical fields |

---

## 🛠️ Tech Stack

<table>
<tr><td>🗄️ <b>Warehouse</b></td><td>DuckDB — columnar, analytical, zero-config</td></tr>
<tr><td>🔄 <b>Transformation</b></td><td>dbt-core + dbt-duckdb — SQL ELT with testing & docs</td></tr>
<tr><td>📥 <b>Ingestion</b></td><td>Python (zipfile, glob, duckdb) — automated CSV loading</td></tr>
<tr><td>📁 <b>Version Control</b></td><td>Git + GitHub — full commit history</td></tr>
<tr><td>⚙️ <b>Runtime</b></td><td>Python 3.12 · Java 17</td></tr>
</table>

---

## 📂 Project Structure
dbt-healthcare/

│

├── 📜 scripts/

│   ├── ingest_to_source.py          # Automated unzip + load 18 CSVs → DuckDB

│   ├── verify_source.py             # Validate source tables and row counts

│   └── query_duckdb.py              # Ad-hoc query runner

│

├── 📦 healthcare_dbt/

│   ├── models/

│   │   ├── staging/                 # PSA layer — clean, type-cast, standardize

│   │   └── marts/                   # Gold layer — dim + fact tables

│   ├── dbt_project.yml

│   └── profiles.yml

│

├── .gitignore

├── requirements.txt

└── README.md



---

## 🚀 How to Run

```bash
# 1️⃣  Clone
git clone https://github.com/<your-username>/dbt-healthcare.git
cd dbt-healthcare

# 2️⃣  Virtual Environment
python -m venv .venv
.venv\Scripts\Activate.ps1          # Windows
source .venv/bin/activate            # Mac/Linux

# 3️⃣  Install Dependencies
pip install -r requirements.txt

# 4️⃣  Ingest — unzip + load to source
python scripts/ingest_to_source.py

# 5️⃣  Build Pipeline (source → PSA → dim → fact)
cd healthcare_dbt
dbt run

# 6️⃣  Run Tests
dbt test

# 7️⃣  Documentation + Lineage Graph
dbt docs generate
dbt docs serve
```

---

## 🧠 Engineering Decisions

| Challenge | Decision | Why |
|:---|:---|:---|
| 🔴 **8GB RAM limit** | DuckDB `read_csv_auto()` over PySpark `toPandas()` | PySpark crashed with OOM on large files; DuckDB streams without loading everything into RAM |
| 🟡 **Raw data safety** | `all_varchar=true` on source load | No silent type-inference surprises; explicit casting in PSA layer |
| 🟢 **Large-volume tables** | Incremental materialization | Only new records processed — avoids expensive full rebuilds |
| 🔵 **Historical accuracy** | SCD2 + date-range joins | Facts link to the correct *point-in-time version*, not just the latest |
| 🟣 **Inconsistent naming** | PSA standardization | Mixed camelCase/spaces/underscores → single clean convention |
| ⚫ **Stale incremental data** | `--full-refresh` after upstream fixes | Upstream bug fixes require full-refresh on downstream incremental models |

---

## 💡 Key Learnings

- 🏗️ **Layered warehouse design** — source → PSA → dimensional with clear separation of concerns
- 🔄 **SCD Type 2** — date-range validity windows with point-in-time join logic
- ⚡ **Incremental models** — including the lesson that upstream fixes need `--full-refresh` downstream
- 🧪 **Data quality as code** — 18 automated tests on every build
- 💾 **Memory-conscious engineering** — right tool for the constraint (DuckDB streaming over PySpark in-memory)
- 🏥 **Healthcare data modeling** — clinical structures: patients, encounters, conditions, providers, payers

---

<p align="center">
  <b>Built by</b> <a href="https://github.com/YOUR_USERNAME">Your Name</a> · <a href="https://linkedin.com/in/YOUR_LINKEDIN">LinkedIn</a>
</p>




### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
