# LayoffLens: SQL Deep Dive into Workforce Trends

## Overview

**LayoffLens** is a comprehensive SQL project that dives deep into analyzing corporate workforce trends using historical layoff data. This project focuses on transforming raw data from layoffs into clean, standardized information and then performing a broad and in-depth exploratory data analysis (EDA) to uncover industry-specific trends, company patterns, and temporal shifts in layoffs.

Using SQL, the project performs:
- **Data Cleaning:** Removal of duplicates, standardization of text fields, conversion of date and numeric formats, and handling missing values.
- **Exploratory Analysis:** Aggregation and analysis by industry, company, and company stage, along with temporal trends, rolling totals, moving averages, and ranking-based insights.

## Repository Structure

```
LayoffLens/
│
├── clean_data.sql         # SQL script to load and clean raw layoffs data from layoffs.csv
├── trend_analysis.sql     # SQL script to perform extensive exploratory data analysis on the cleaned data
└── README.md              # This documentation file
```

## Key Features

- **Comprehensive Data Cleaning:**  
  - Loads data from a CSV file (layoffs.csv) into a raw table.
  - Standardizes textual data (e.g., trimming whitespace, consolidating industry and country names).
  - Converts date and numeric fields to appropriate SQL data types.
  - Handles missing values and duplicates effectively.

- **Deep Exploratory Data Analysis:**  
  - Overall statistics: total records, total layoffs.
  - Breakdown of layoffs by industry, company, and stage.
  - Temporal analysis: Yearly and monthly trends, including moving averages and cumulative (rolling) totals.
  - Advanced ranking queries: Identifies top companies per year and examines companies with 100% layoffs.
  - Basic correlation insights between funds raised and layoffs.

- **Adaptability and Extensibility:**  
  - The code is structured to be easily adaptable to different datasets with similar structures.
  - Clear inline comments and documentation make it simple to understand and extend the analysis.

## Data Source

The dataset used in this project is provided in the attached CSV file, `layoffs.csv`. The file contains information on company layoffs over the past few years, with key columns such as:

- **Company**
- **Location**
- **Industry**
- **Total Laid Off**
- **Percentage Laid Off**
- **Date**
- **Stage**
- **Country**
- **Funds Raised (Millions)**

*Note: Adjust the file path in the `LOAD DATA LOCAL INFILE` statement in `clean_data.sql` to match your environment.*

## Setup & Usage

### Prerequisites

- **MySQL 8.0 or Later:**  
  The scripts use window functions, common table expressions (CTEs), and other features that require MySQL 8.0+.

- **Access to a SQL Client:**  
  Use any MySQL client (e.g., MySQL Workbench, phpMyAdmin, command line) to execute the scripts.

### Steps to Run the Project

1. **Clone or Download the Repository:**  
   Download the repository to your local machine.

2. **Place the CSV File:**  
   Ensure that the `layoffs.csv` file is available and update the file path in the `LOAD DATA LOCAL INFILE` command within `clean_data.sql`.

3. **Execute Data Cleaning Script:**
   - Run `clean_data.sql` in your SQL environment.
   - This script will:
     - Create the raw table (`raw_layoffs`) and load the CSV data.
     - Create a staging table (`layoffs_staging`), clean and standardize the data.
     - Remove duplicates and store the final clean data in a new table (`clean_data`).

4. **Execute Trend Analysis Script:**
   - Run `trend_analysis.sql` in your SQL environment.
   - This script will query the `clean_data` table and output various analyses, such as:
     - Overall statistics.
     - Aggregated insights by industry, company, and stage.
     - Temporal trends with yearly and monthly breakdowns, cumulative totals, and moving averages.
     - Advanced ranking insights and preliminary correlation comparisons.

## Detailed SQL Files Description

### clean_data.sql

- **Purpose:**  
  Load raw CSV data into the database, perform extensive cleaning, standardize data fields, handle missing values, and eliminate duplicate records.
  
- **Key Operations:**
  - Creating and populating `raw_layoffs`.
  - Data standardization: Trimming text fields, converting date formats, cleaning numeric fields.
  - Handling missing values by cross-referencing within the same company.
  - Removing duplicates using a window function and creating the final `clean_data` table.

### trend_analysis.sql

- **Purpose:**  
  Analyze the cleaned data to provide insights into layoffs by various dimensions.
  
- **Key Operations:**
  - Overall record and total layoffs calculation.
  - Grouped analysis by industry, company, and stage.
  - Temporal analysis with yearly and monthly trends, including moving averages and rolling totals.
  - Advanced ranking to find top companies per year.
  - Preliminary correlation insights between funds raised and layoffs.

## Future Improvements

- **Visualization Integration:**  
  Incorporate visualization tools such as Tableau, Power BI, or Python libraries (Matplotlib/Seaborn) to create interactive dashboards.
  
- **Automated ETL Processes:**  
  Automate the data extraction, transformation, and loading (ETL) process for real-time analysis.
  
- **Extended Statistical Analysis:**  
  Explore more advanced statistical models and correlation analyses directly within SQL or by exporting data for further processing in R/Python.

## How to Get Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/Priyanshu-Builds/LayoffLens.git
   ```
2. **Review the SQL Scripts:**
   - `clean_data.sql` for data cleaning.
   - `trend_analysis.sql` for exploratory data analysis.
3. **Load and Analyze:**
   - Execute the scripts in your MySQL environment and explore the outputs.

## Contributing

Contributions are welcome! If you have suggestions, improvements, or additional analyses, feel free to fork the repository and submit a pull request. Please ensure your changes align with the project’s objectives and coding style.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.