test_that("add data to table that is a new table (has no current data)", {
  skip_on_ci()
  # set up
  outing <- data.frame(x = 1:5, y = 6:10)
  local_config <- create_local_database(
    schema = "boat_count",
    table = outing,
    data = FALSE
  )
  # testing
  output <- psql_add_data(
    outing,
    schema = "boat_count",
    config_path = local_config
  )
  expect_equal(output, 5)

  query <- check_db_table(
    config_path = local_config,
    schema = "boat_count",
    tbl_name = "outing"
  )
  expect_equal(query, outing)
})

test_that("add data to table when data is already in the table", {
  skip_on_ci()
  # set up
  outing <- data.frame(x = 1:5, y = 6:10)

  local_config <- create_local_database(
    schema = "boat_count",
    table = outing
  )
  # testing
  outing_new <- data.frame(x = 6:10, y = 11:15)
  output <- psql_add_data(
    tbl = outing_new,
    tbl_name = "outing",
    schema = "boat_count",
    config_path = local_config
  )
  expect_equal(output, 5)

  query_data <- check_db_table(
    config_path = local_config,
    schema = "boat_count",
    tbl_name = "outing"
  )
  outing_all <- rbind(outing, outing_new)
  expect_equal(query_data, outing_all)
})
