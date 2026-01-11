[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.5.x&color=orange)

# The Tuva Project Demo

## 🧰 What does this project do?

This demo provides a quick and easy way to run the Tuva Project 
Package in a dbt project with synthetic data for 1k patients loaded as dbt seeds.

To set up the Tuva Project with your own claims data or to better understand what the Tuva Project does, please review the ReadMe in [The Tuva Project](https://github.com/tuva-health/the_tuva_project) package for a detailed walkthrough and setup.

For information on the data models check out our [Docs](https://thetuvaproject.com/).

## ✅ How to get started

### Pre-requisites
You only need one thing installed:
1. [uv](https://docs.astral.sh/uv/getting-started/) - a fast Python package manager. Installation is simple and OS-agnostic:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
   Or on Windows:
   ```powershell
   powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```

**Note:** This demo uses DuckDB as the database, so you don't need to configure a connection to an external data warehouse. Everything is configured and ready to go!

### Getting Started
Complete the following steps to run the demo:

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine or environment.
2. In the project directory, install Python dependencies and set up the virtual environment:
   ```bash
   uv sync
   ```
3. Activate the virtual environment:
   ```bash
   source .venv/bin/activate  # On macOS/Linux
   # or on Windows:
   .venv\Scripts\activate
   ```
4. Run `dbt deps` to install the Tuva Project package:
   ```bash
   dbt deps
   ```
5. Run `dbt build` to run the entire project with the built-in sample data:
   ```bash
   dbt build
   ```

The `profiles.yml` file is already included in this repo and pre-configured for DuckDB, so no additional setup is needed!

### Using uv commands
You can also run dbt commands directly with `uv run` without activating the virtual environment:
```bash
uv run dbt deps
uv run dbt build
```

## 🤝 Community

Join our growing community of healthcare data practitioners on [Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q)!

# Oncology Analysis Assignment

## Methodology
### Cohort Identification
We identified patients with 'Active Cancer' by filtering medical claims for ICD-10 diagnosis codes starting with 'C' (Malignant neoplasms). We utilized the 'medical_claim' table as the source of truth, scanning all 25 diagnosis code fields to flag any patient with at least one cancer-related diagnosis.

### Cost Profiling
Costs were aggregated from the 'medical_claim' table. We categorized care settings (Inpatient, Outpatient, ER, Other) using a hierarchical logic:
1. **Place of Service (POS)** codes were used for professional claims (e.g., 21=Inpatient, 11=Outpatient, 23=ER).
2. **Bill Type** codes were used for institutional claims where POS was missing (e.g., 11x/12x=Inpatient, 13x/14x=Outpatient).
This ensured that significant institutional spend was correctly attributed rather than falling into 'Other'.

## Key Findings
*   **Prevalence:** 396 patients identified with active cancer.
*   **Total Spend:** ~7.76 Million.
*   **Top Cost Driver:** **Outpatient Care** is the primary driver (~4.20M), followed by Inpatient Care (~2.79M).
    *   *Outpatient:* 4,203,767
    *   *Inpatient:* 2,788,098
    *   *Other:* 675,088
    *   *ER:* 94,830

## AI Usage Log
*   **Code Generation:** AI was used to generate the dbt model structure and the Jinja loop for unpivoting diagnosis codes.
*   **Debugging:** AI helped identify that a significant portion of spend was categorized as 'Other' due to missing POS codes on institutional claims, and suggested using 'bill_type_code' to resolve this.
*   **Syntax:** AI assisted with DuckDB-compatible SQL syntax for lists and string manipulation.

