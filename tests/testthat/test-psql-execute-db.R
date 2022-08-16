test_that("create schema", {
  skip_on_ci()
  output <- psql_execute_db("CREATE SCHEMA boat_count")
  query <- DBI::dbGetQuery(
    psql_connect(),
    "SELECT schema_name FROM information_schema.schemata"
  )
  expect_equal(output, 0L)
  expect_true("boat_count" %in% query$schema_name)
})

test_that("create table", {
  skip_on_ci()
  output <- psql_execute_db(
    "CREATE TABLE boat_count.input (
     x INTEGER NOT NULL,
     y INTEGER)"
  )
  query <- DBI::dbGetQuery(
    psql_connect(),
    "SELECT * FROM pg_tables
     WHERE schemaname = 'boat_count'"
  )
  expect_equal(output, 0L)
  expect_true("input" %in% query$tablename)
})

# clean up
psql_execute_db(
  "DROP TABLE boat_count.input"
)

psql_execute_db(
  "DROP SCHEMA boat_count"
)
