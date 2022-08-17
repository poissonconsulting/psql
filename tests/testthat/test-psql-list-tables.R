test_that("list tables", {
  config_path <- system.file("testhelpers/config.yml", package = "psql")

  psql_list_tables(
    "input",
    "boat_count",
    config_path = config_path
  )
})
