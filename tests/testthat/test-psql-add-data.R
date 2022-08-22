dat <- data.frame(
  x = c(1:10),
  y = c(21:30)
)

test_that("add data to database", {
  skip_on_ci()
  # create the schema and table
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql_execute_db("CREATE SCHEMA boat_count", config_path = config_path)
  withr::defer(
    try(
      psql_execute_db(
        "DROP SCHEMA boat_count",
        config_path = config_path
      ),
      silent = TRUE
    )
  )
  psql_execute_db(
    "CREATE TABLE boat_count.dat (
     x INTEGER NOT NULL,
     y INTEGER)",
    config_path = config_path
  )
  withr::defer(
    try(
      psql_execute_db(
        "DROP TABLE boat_count.dat",
        config_path = config_path
      ),
      silent = TRUE
    )
  )
  # execute code to be tested
  output <- psql_add_data(dat, schema = "boat_count", config_path = config_path)
  query <- DBI::dbGetQuery(
    psql_connect(config_path = config_path),
    "SELECT * FROM boat_count.dat"
  )
  # tests
  expect_equal(output, 10)
  expect_equal(query, dat)
})
