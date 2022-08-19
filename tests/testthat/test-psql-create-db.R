test_that("creates new database", {
  skip_on_ci()
  expect_true(psql_create_db("newdb"))
  # clean up afterwards
  result <- DBI::dbSendQuery(psql_connect(), "DROP DATABASE newdb;")
  DBI::dbClearResult(result)
})

test_that("errors when no dbname passed", {
  skip_on_ci()
  expect_error(
    psql_create_db(),
    regexp = 'argument "dbname" is missing, with no default'
  )
})
