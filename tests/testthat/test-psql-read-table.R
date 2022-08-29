test_that("error when no arguments supplied", {
  expect_error(
    psql_read_table(),
    regexp = 'argument "tbl_name" is missing, with no default'
  )
})

test_that("error when table has not been created", {
  skip_on_ci()
  # set up
  local_config <- create_local_database(schema = "boat_count")
  # testing
  expect_error(
    psql_read_table(
      tbl_name = "outing",
      schema = "boat_count",
      config_path = local_config
    ),
    regexp = 'relation "boat_count.outing" does not exist'
  )
})

test_that("read a table from local database", {
  skip_on_ci()
  # set up
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(schema = "boat_count", table = outing)
  # testing
  output <- psql_read_table(
    tbl_name = "outing",
    schema = "boat_count",
    config_path = local_config
  )
  expect_equal(output, outing)
  expect_s3_class(output, "data.frame")
})
