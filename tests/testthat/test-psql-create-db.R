test_that("creates new database", {
  skip_on_ci()
  output <- psql_create_db("newdb")
  # clean up afterwards
  withr::defer(
    {
      try(
        result <- DBI::dbSendQuery(psql_connect(), "DROP DATABASE newdb;"),
        silent = TRUE
      )
      try(
        DBI::dbClearResult(result),
        silent = TRUE
      )
    }
  )
  #test
  expect_true(output)
})

test_that("errors when no dbname passed", {
  skip_on_ci()
  expect_error(
    psql_create_db(),
    regexp = 'argument "dbname" is missing, with no default'
  )
})
