# DBT-Snowflake Project

A data pipeline project using [dbt](https://www.getdbt.com/) (Data Build Tool) with Snowflake as the data warehouse. This project implements a modern data transformation pipeline with a bronze-silver-gold architecture for Airbnb-style booking data.

## Project Overview

This project demonstrates a production-ready ETL pipeline using dbt and Snowflake. It processes booking, host, and listing data through multiple transformation layers, implementing industry best practices for data modeling.

## Architecture

The project follows a **medallion architecture** with three distinct layers:

```
┌─────────────────────────────────────────────────────────────────┐
│                        SOURCE DATA                              │
│                  (Snowflake STAGING Schema)                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  BRONZE LAYER (Raw Data)                                        │
│  - bronze_bookings.sql, bronze_hosts.sql, bronze_listings.sql   │
│  - Materialized as: table                                       │
│  - Incremental loads from staging                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  SILVER LAYER (Cleaned & Enriched Data)                         │
│  - silver_bookings.sql, silver_hosts.sql, silver_listings.sql   │
│  - Materialized as: table                                       │
│  - Business logic & transformations                             │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  GOLD LAYER (Business-Ready Analytics)                          │
│  - fact_table.sql, obt.sql                                      │
│  - Materialized as: table                                       │
│  - Final analytical models                                      │
└─────────────────────────────────────────────────────────────────┘
```

## Data Sources

The project sources data from the following tables in the `AIRBNB.STAGING` schema:

| Table | Description |
|-------|-------------|
| `bookings` | Booking transactions with dates, amounts, and status |
| `hosts` | Host information with profile details |
| `listings` | Property listings with details and pricing |

## Folder Structure

```
DBT-Snowflake/
├── README.md                    # This file
├── main.py                      # Python entry point
├── pyproject.toml               # Python dependencies
├── dataset/                     # Sample CSV data files
│   ├── bookings.csv
│   ├── hosts.csv
│   └── listings.csv
├── dbt_snowflake_project/       # DBT Project
│   ├── dbt_project.yml          # DBT project configuration
│   ├── profiles.yml              # Snowflake connection profiles
│   ├── README.md                 # DBT project docs
│   ├── analyses/                 # Analysis SQL files
│   │   ├── ifelse.sql           # Jinja if-else demonstration
│   │   └── loop.sql             # Jinja loop demonstration
│   ├── macros/                  # Custom macros
│   │   ├── multiply.sql         # Multiply with precision
│   │   ├── tag.sql              # Tagging based on value ranges
│   │   ├── generate_schema_name.sql  # Custom schema naming
│   │   └── trim_upper.sql       # String manipulation
│   ├── models/                  # DBT models
│   │   ├── sources/             # Source definitions
│   │   │   └── sources.yml
│   │   ├── bronze/             # Bronze layer models
│   │   │   ├── bronze_bookings.sql
│   │   │   ├── bronze_hosts.sql
│   │   │   └── bronze_listings.sql
│   │   ├── silver/             # Silver layer models
│   │   │   ├── silver_bookings.sql
│   │   │   ├── silver_hosts.sql
│   │   │   └── silver_listings.sql
│   │   └── gold/              # Gold layer models
│   │       ├── fact_table.sql
│   │       ├── obt.sql
│   │       └── ephemeral/      # Ephemeral models
│   │           ├── bookings.sql
│   │           ├── hosts.sql
│   │           └── listings.sql
│   ├── seeds/                  # Seed data files
│   ├── snapshots/              # Snapshot models (SCD Type 2)
│   │   ├── dim_bookings.yml
│   │   ├── dim_hosts.yml
│   │   └── dim_listings.yml
│   └── tests/                  # Schema tests
│       └── source_test.sql
├── ddl/                        # DDL statements
│   └── source_ddl.sql
└── logs/                       # Project logs
```

## Custom Macros

The project includes several custom dbt macros:

### 1. `multiply(multiplicand, multiplier, precision)`
Multiplies two values with specified precision.

```sql
{{ multiply('NIGHTS_BOOKED', 'BOOKING_AMOUNT', 2) }} AS total_amount
```

### 2. `tag(column)`
Creates categorical tags based on value ranges.

```sql
{{ tag('PRICE_PER_NIGHT::INT') }} AS price_tag
-- Returns: 'low' (<100), 'medium' (100-200), 'high' (>=200)
```

### 3. `generate_schema_name(custom_schema_name, node)`
Custom schema naming logic based on target environment.

### 4. `trim_upper(column_name, node)`
Trims and uppercases a column value.

## Model Configuration

### Bronze Layer
- **Materialization**: Table
- **Schema**: bronze
- **Features**: Incremental loads using `CREATED_AT` column

### Silver Layer
- **Materialization**: Table
- **Schema**: silver
- **Features**: Unique keys, business transformations

### Gold Layer
- **Materialization**: Table
- **Schema**: gold
- **Features**: Final analytics, joined datasets

## Prerequisites

Before running this project, ensure you have:

1. **Python 3.10+** installed
2. **Snowflake account** with appropriate credentials
3. **DBT Cloud** or **dbt-core** installed

## Installation

1. Clone the repository:
```bash
cd DBT-Snowflake
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
# Or using uv:
uv pip install -r requirements.txt
```

3. Configure Snowflake connection in `dbt_snowflake_project/profiles.yml`:
```yaml
dbt_snowflake_project:
  outputs:
    dev:
      account: YOUR_ACCOUNT
      database: AIRBNB
      password: YOUR_PASSWORD
      role: ACCOUNTADMIN
      schema: dbt_schema
      threads: 1
      type: snowflake
      user: YOUR_USER
      warehouse: COMPUTE_WH
```

## DBT Commands

### Run All Models
```bash
cd dbt_snowflake_project
dbt run
```

### Run Specific Model
```bash
dbt run --select bronze_bookings
```

### Run Tests
```bash
dbt test
```

### Compile Project
```bash
dbt compile
```

### Generate Documentation
```bash
dbt docs generate
dbt docs serve  # Serve docs locally
```

### Debug Connection
```bash
dbt debug
```

## Snapshots (SCD Type 2)

The project includes snapshot models for slowly changing dimensions:

- `dim_bookings.yml` - Track booking changes
- `dim_hosts.yml` - Track host profile changes
- `dim_listings.yml` - Track listing information changes

## Key Features

- **Incremental Models**: Bronze and Silver layers use incremental loads for efficiency
- **Custom Macros**: Reusable SQL transformations via Jinja
- **Ephemeral Models**: Lightweight intermediate models in Gold layer
- **Schema Testing**: Built-in tests for data quality
- **Dynamic SQL**: Jinja templating for flexible transformations
- **Jinja Loops**: Dynamic column selection and joins
