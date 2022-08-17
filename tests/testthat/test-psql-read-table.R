test_that("read table from local", {
  skip_on_ci()
  # set up database
  dat <- data.frame(
    x = c(1:10),
    y = c(rep("yes", 5), rep("no", 4), NA)
  )
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  psql_execute_db(
    "CREATE TABLE boat_count.dat (
     x INTEGER NOT NULL,
     y TEXT)",
    config_path = config_path
  )
  psql_add_data(dat, schema = "boat_count", config_path = config_path)
  # execute tests
  output <- psql_read_table(
    tbl_name = "dat",
    schema = "boat_count",
    config_path = config_path
  )
  expect_equal(output, dat)
  expect_s3_class(output, "data.frame")
  # clean up
  psql_execute_db(
    "DROP TABLE boat_count.dat",
    config_path = config_path
  )
  psql_execute_db(
    "DROP SCHEMA boat_count",
    config_path = config_path
  )
})

test_that("error when no arguments supplied", {
  expect_error(
    psql_read_table(),
    regexp = 'argument "tbl_name" is missing, with no default'
  )
})


# backup clean up
try(
  psql_execute_db(
    "DROP TABLE boat_count.dat",
    config_path = config_path
  ),
  silent = TRUE
)
try(
  psql_execute_db(
    "DROP SCHEMA boat_count",
    config_path = config_path
  ),
  silent = TRUE
)
