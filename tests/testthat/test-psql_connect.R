test_that("working local connection when NULL supplied", {
    conn <- psql_connect(config_filepath = NULL, value = NULL)
    on.exit(DBI::dbDisconnect(conn))
    expect_s4_class(conn, "PqConnection")
})

test_that("working local connection when nothing supplied", {
  conn <- psql_connect()
  on.exit(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

# could create blank .yml file withr and ensure it works
#
