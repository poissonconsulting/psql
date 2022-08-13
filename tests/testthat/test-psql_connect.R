test_that("errors when all parameters are NULL", {
  expect_error(
    psql_connect(config_filepath = NULL, value = NULL),
    regexp = "invalid 'path' argument"
  )
})

# could create blank .yml file withr and ensure it works
#


