# need DBI function that puts data frame in to database by writing the sql code itself

test_that("add data to database", {
  skip_on_ci()
  schema <- "truck"
  dat <- data.frame(x = 1:5)
  config_details <- create_local_database(table = dat)
  psql_add_data(x = dat, config_path = config_details)
  # tests
  ### use code to make sure data was added, could check before and after if you want as well

})

create_local_database <- function(
    schema = NULL,
    table = NULL, # data frame
    data = FALSE, # where the data is added to the table, if FALSE no data added to table, if TRUE data added
    env = parent.frame()
  ) {
  ### be nice if you pass a vector, it creates them in a loop, ie you can create multiple schema?
  chk::chk_string(schema)


  withr::defer({
    try(
      DBI::dbDisconnect(conn),
      silent = TRUE
    )
  }, envir = env)

  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = "127.0.0.1",
    port = 5432,
    dbname = NULL,
    user = NULL,
    password = NULL
  )

  withr::defer({
    try(
      result <- DBI::dbSendQuery(conn, "DROP DATABASE newdb;"),
      silent = TRUE
    )
    try(
      DBI::dbClearResult(result),
      silent = TRUE
    )
  }, envir = env)

  cmd <- paste0("CREATE DATABASE ", dbname, ";")
  result <- DBI::dbSendQuery(conn, cmd)
  DBI::dbClearResult(result)

  if (!is.null(schema)) {
    withr::defer({
      sql_drop <- paste0("DROP SCHEMA ", schema, ";")
      try(
        result <- DBI::dbSendQuery(conn, sql_drop),
        silent = TRUE
      )
      try(
        DBI::dbClearResult(result),
        silent = TRUE
      )
    }, envir = env)
    sql <- paste0("CREATE SCHEMA ", schema, ";")
    DBI::dbExecute(conn, sql)
  }

  if (!is.null(table)) {
    # need way for table sql code to be dynamically created
  }

}

