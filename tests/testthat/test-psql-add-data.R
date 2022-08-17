dat <- data.frame(
  x = c(1:10),
  y = c(21:30)
)

test_that("add data to database", {
  skip_on_ci()
  # create the schema and table
  psql_execute_db("CREATE SCHEMA boat_count")
  psql_execute_db(
    "CREATE TABLE boat_count.dat (
     x INTEGER NOT NULL,
     y INTEGER)"
  )
  # execute code to be tested
  output <- psql_add_data(dat, schema = "boat_count")
  query <- DBI::dbGetQuery(
    psql_connect(),
    "SELECT * FROM boat_count.dat"
  )
  # tests
  expect_equal(output, 10)
  expect_equal(query, dat)
  # clean up
  psql_execute_db(
    "DROP TABLE boat_count.dat"
  )
  psql_execute_db(
    "DROP SCHEMA boat_count"
  )
})

# backup clean up
try(
  psql_execute_db(
    "DROP TABLE boat_count.dat"
  ),
  silent = TRUE
)
try(
  psql_execute_db(
    "DROP SCHEMA boat_count"
  ),
  silent = TRUE
)
