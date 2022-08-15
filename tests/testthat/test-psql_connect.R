test_that("working local connection when NULL supplied", {
    conn <- psql_connect(config_path = NULL, value = NULL)
    on.exit(DBI::dbDisconnect(conn))
    expect_s4_class(conn, "PqConnection")
})

test_that("working local connection when nothing supplied", {
  conn <- psql_connect()
  on.exit(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("working local connection of a different db from config", {
  path <- system.file("testhelpers/config.yml", package = "psql")
  conn <- psql_connect(config_path = path)
  on.exit(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("working local connection of a different db from config other value", {
  path <- system.file("testhelpers/config-value.yml", package = "psql")
  conn <- psql_connect(config_path = path, value = "database")
  on.exit(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

### HACK - delete when confidence or something
test_that("working hosted to test db", {
  skip_on_ci()
  path <- system.file("testhelpers/config-hosted.yml", package = "psql")
  conn <- psql_connect(config_path = path)
  on.exit(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})
