
# psql

<!-- badges: start -->
<!-- badges: end -->

`psql` is a wrapper on `DBI` and PostgreSQL commands thus eliminating
the need for users to have to learn PostgreSQL. Now R can be used for
most tasks except creating the tables and schema.

`psql` is an R package that

-   open and closes the database connection within the function, no
    closing required

## Installation

``` r
# install.packages("devtools")
devtools::install_github("poissonconsulting/psql")
```

## Set Up

### config file

Your database connection details should be stored in a config.yml file.
Set the `psql.config_path` option as the file path to the config file.
Set the `psql.value` option as the value in the config file.

Example of a config.yml file:

    default:
      user: "postgres"
      host: 127.0.0.1
      dbname: "postgres"
      port: 5432
      password: !expr Sys.getenv("DM_PASSWORD")

### pgpass file

A .pgpass file is required (if your database has a password) when using
the `psql_backup()` function. The [postgresql
website](https://www.postgresql.org/docs/current/libpq-pgpass.html)
provides details on how to set it up.

## Usage

When you need to add data to a table use `psql_add_data()`.

``` r
library(psql)
psql_add_data(mtcars, schema = "cars")
```

To list all the tables in the schema use `psql_list_tables()`.

``` r
psql_list_tables(schema = "cars")
```

To read a table in from your database use `psql_read_table()`

``` r
db_mtcars <- psql_list_tables(tbl_name = "mtcars", schema = "cars")
```

To create a schema and table use `psql_execute_db()`

``` r
psql_execute_db("CREATE SCHEMA cars")
psql_execute_db(
    "CREATE TABLE cars.model (
     name TEXT NOT NULL,
     code INTEGER)"
  )
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
