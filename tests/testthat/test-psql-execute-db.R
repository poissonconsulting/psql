test_that("create schema in the local database", {
  skip_on_ci()
  local_config <- create_local_database()
  clean_up_schema(local_config)

  output <- psql_execute_db(
    "CREATE SCHEMA boat_count",
    config_path = local_config
  )

  schema_info <- check_schema_exists(local_config)

  expect_equal(output, 0L)
  expect_true("boat_count" %in% schema_info$schema_name)
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




