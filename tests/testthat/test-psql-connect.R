test_that("working local connection when NULL supplied", {
  skip_on_ci()
  conn <- psql_connect(config_path = NULL, config_value = NULL)
  withr::defer(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("working local connection when nothing supplied", {
  skip_on_ci()
  conn <- psql_connect()
  withr::defer(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("working local connection of a different db from config", {
  skip_on_ci()
  path <- create_local_database()
  conn <- psql_connect(config_path = path)
  withr::defer(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("working local connection of different db from config other value", {
  skip_on_ci()
  path <- create_config_with_value_level()
  conn <- psql_connect(config_path = path, config_value = "database")
  withr::defer(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})

test_that("working hosted to test db", {
  skip_on_ci()
  path <- system.file("testhelpers/config-hosted.yml", package = "psql")
  conn <- psql_connect(config_path = path)
  withr::defer(DBI::dbDisconnect(conn))
  expect_s4_class(conn, "PqConnection")
})
