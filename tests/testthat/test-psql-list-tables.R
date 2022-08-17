test_that("list local tables", {
  skip_on_ci()
  # set up test
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  psql_execute_db(
    "CREATE TABLE boat_count.input (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  psql_execute_db(
    "CREATE TABLE boat_count.counts (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  # execute tests
  output <- psql_list_tables(
    "boat_count",
    config_path = config_path
  )
  expect_equal(output, c("input", "counts"))
  # clean up
  psql_execute_db(
    "DROP TABLE boat_count.input",
    config_path = config_path
  )
  psql_execute_db(
    "DROP TABLE boat_count.counts",
    config_path = config_path
  )
  psql_execute_db(
    "DROP SCHEMA boat_count",
    config_path = config_path
  )
})

test_that("default params - should be empty so no names returned", {
  output <- psql_list_tables()
  expect_equal(length(output), 0L)
  expect_type(output, "character")
})
