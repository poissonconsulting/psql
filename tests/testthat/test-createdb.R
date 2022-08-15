# run DROP DATABASE dbname;

test_that("creates new database", {
  skip_on_ci()
  expect_true(psql_createdb("newdb"))
})

test_that("errors when no dbname passed", {
  skip_on_ci()
  expect_error(
    psql_createdb(),
    regexp = 'argument "dbname" is missing, with no default'
  )
})
