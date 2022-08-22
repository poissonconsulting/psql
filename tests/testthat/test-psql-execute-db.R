test_that("create schema", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  output <- psql_execute_db(
    "CREATE SCHEMA boat_count",
    config_path = config_path
  )
  withr::defer({
    try(
      psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      ),
      silent = TRUE
    )
  })
  query <- DBI::dbGetQuery(
    psql_connect(config_path = config_path),
    "SELECT schema_name FROM information_schema.schemata"
  )
  expect_equal(output, 0L)
  expect_true("boat_count" %in% query$schema_name)
})

test_that("create table", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  output <- psql_execute_db(
    "CREATE TABLE boat_count.input (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  withr::defer({
    try(
      psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      ),
      silent = TRUE
    )
  })
  withr::defer({
    try(
      psql_execute_db(
        "DROP TABLE boat_count.input",
        config_path = config_path
      ),
      silent = TRUE
    )
  })
  query <- DBI::dbGetQuery(
    psql_connect(config_path = config_path),
    "SELECT * FROM pg_tables
     WHERE schemaname = 'boat_count'"
  )
  expect_equal(output, 0L)
  expect_true("input" %in% query$tablename)
})

test_that("error when function empty", {
  expect_error(
    psql_execute_db(),
    regexp = 'argument "sql" is missing, with no default'
  )
})
