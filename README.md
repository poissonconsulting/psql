
# psql

<!-- badges: start -->

[![R-CMD-check](https://github.com/poissonconsulting/psql/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/poissonconsulting/psql/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/poissonconsulting/psql/branch/main/graph/badge.svg?token=7F2LIBp2Tt)](https://codecov.io/gh/poissonconsulting/psql)
<!-- badges: end -->

`psql` is a wrapper on `DBI` and PostgreSQL commands thus eliminating
the need for users to have to learn PostgreSQL and can just use R.

`psql` is an R package that

-   open and closes the database connection within the function, no
    closing required

## Installation

``` r
# install.packages("devtools")
devtools::install_github("poissonconsulting/psql")
```

## Set Up

### Install postgres locally by running the following

    brew install postgresql

### config file

Your database connection details should be stored in a config.yml file.
Set the `psql.config_path` option as the file path to the config file.
Set the `psql.value` option as the value in the config file.

Example of a `config.yml` file:

    default:
      user: "postgres"
      host: 127.0.0.1
      dbname: "postgres"
      port: 5432
      password: !expr Sys.getenv("DM_PASSWORD")

### pgpass file

A `.pgpass` file is required (if your database has a password) when
using the `psql_backup()` function. The [postgresql
website](https://www.postgresql.org/docs/current/libpq-pgpass.html)
provides details on how to set it up.

Currently add the following file named `.pgpass` to your home directory
(`~`)

    *:*:*:*:<password>

and then in the terminal run `chmod 0600 ~/.pgpass`

## Usage

Start by setting the file path for your config file in options so you do
not have to pass the config file each time.

``` r
library(psql)
options(psql.config_path = "config.yml")
```

Lets create a schema and table with `psql_execute_db()`

``` r
psql_execute_db("CREATE SCHEMA truck")
## [1] 0
psql_execute_db(
  "CREATE TABLE truck.model (
     name TEXT NOT NULL,
     code INTEGER)"
)
## [1] 0
```

When you need to add data to a table use `psql_add_data()`, and the
number of rows added will be output.

``` r
model <- data.frame(
  name = c("Ranger", "F-150", "F-250"),
  code = c(2457, 1475, 1247)
)

psql_add_data(model, schema = "truck")
## [1] 3
```

To list all the tables in the schema use `psql_list_tables()`.

``` r
psql_list_tables(schema = "truck")
## [1] "model"
```

To read a table in from your database use `psql_read_table()`

``` r
truck_models <- psql_read_table(tbl_name = "model", schema = "truck")
truck_models
##     name code
## 1 Ranger 2457
## 2  F-150 1475
## 3  F-250 1247
```

To copy and save your database use `psql_backup()`

``` r
psql_backup("~/Database_backups/db_trucks_2020-07-19.sql")
```

## Contribution

Please report any
[issues](https://github.com/poissonconsulting/psql/issues).

[Pull requests](https://github.com/poissonconsulting/psql/pulls) are
always welcome.

## Code of Conduct

Please note that the psql project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## Inspiration

-   [readwritesql](https://github.com/poissonconsulting/readwritesqlite)

## Testing

In your local server you need to have a database called mydb for the
tests to work.

You also need the hosted test database credentials in your .Renviron
file.
