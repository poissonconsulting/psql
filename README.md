
# psql

<!-- badges: start -->
<!-- badges: end -->

psql is a wrapper on pg and PostgreSQL commands thus eliminating the
need for users to have to learn postgres as they can use R for all
required tasks except creating the tables as the datatypes and checks
require manual writing.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("poissonconsulting/psql")
```

## Set Up

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

This is needed when using the `psql_backup()` function. Set up a .pgpass
file to also contain the password for the database.

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(psql)
## basic example code
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
