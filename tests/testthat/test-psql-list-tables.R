test_that("default params - should be empty so no names returned", {
  skip_on_ci()
  local_config <- create_local_database()
  output <- psql_list_tables(config_path = local_config)
  expect_equal(length(output), 0L)
  expect_type(output, "character")
})

test_that("list local tables", {
  skip_on_ci()
  # set up
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(schema = "boat_count", table = outing)
  # testing
  output <- psql_list_tables(
    "boat_count",
    config_path = local_config
  )
  expect_equal(output, "outing")
})
