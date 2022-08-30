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

test_that("create table in the local database", {
  skip_on_ci()
  local_config <- create_local_database(schema = "boat_count")
  clean_up_table(local_config, table = "outing")

  output <- psql_execute_db(
    "CREATE TABLE boat_count.outing (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = local_config
  )

  table_info <- check_table_exists(local_config)
  expect_equal(output, 0L)
  expect_true("outing" %in% table_info)
})

test_that("error when function empty", {
  expect_error(
    psql_execute_db(),
    regexp = 'argument "sql" is missing, with no default'
  )
})
