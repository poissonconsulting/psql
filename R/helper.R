### idea of set up
# test_that("add data to database", {
#   skip_on_ci()
#   schema <- "truck"
#   dat <- data.frame(x = 1:5)
#   config_details <- create_local_database(table = dat)
#   psql_add_data(x = dat, config_path = config_details)
#   # tests
#   ### use code to make sure data was added, could check before and after if you want as well
#
# })

create_local_database <- function(
    schema = NULL,
    table = NULL, # data frame
    data = FALSE, # where the data is added to the table, if FALSE no data added to table, if TRUE data added
    env = parent.frame()
  ) {
  ### be nice if you pass a vector, it creates them in a loop, ie you can create multiple schema?
  chk::chk_null_or(schema, vld = chk::vld_string)
  chk::chk_null_or(table, vld = chk::vld_s3_class)
  chk::chk_flag(data)

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

  local_dbname <- tolower(
    rawToChar(
      as.raw(
        sample(
          c(65:90,97:122),
          12,
          replace = T
        )
      )
    )
  )

  withr::defer({
    clean_cmd <- paste0("DROP DATABASE ", local_dbname, ";")
    try(
      result1 <- DBI::dbSendQuery(conn, clean_cmd),
      silent = TRUE
    )
    try(
      DBI::dbClearResult(result1),
      silent = TRUE
    )
  }, envir = env)

  cmd <- paste0("CREATE DATABASE ", local_dbname, ";")
  result2 <- DBI::dbSendQuery(conn, cmd)
  DBI::dbClearResult(result2)

  if (!is.null(schema)) {

    withr::defer({
      try(
        DBI::dbDisconnect(conn_local),
        silent = TRUE
      )
    }, envir = env)

    conn_local <- DBI::dbConnect(
      RPostgres::Postgres(),
      host = "127.0.0.1",
      port = 5432,
      dbname = local_dbname,
      user = NULL,
      password = NULL
    )

    withr::defer({
      sql_drop <- paste0("DROP SCHEMA ", schema, ";")
      try(
        result3 <- DBI::dbSendQuery(conn_local, sql_drop),
        silent = TRUE
      )
      try(
        DBI::dbClearResult(result3),
        silent = TRUE
      )
    }, envir = env)
    sql <- paste0("CREATE SCHEMA ", schema, ";")
    DBI::dbExecute(conn_local, sql)
  }

  # outputs a config file in a temp directory for the new database it made
  config_deets <- paste0("default:\n  dbname: ", local_dbname, "\n")
  config_file_path <- withr::local_file(
    "local_test_config.yml",
    .local_envir = env
  )
  fileConn <- file(config_file_path)
  writeLines(config_deets, fileConn)
  close(fileConn)

  config_file_path
}


quick_connection <- function(file) {

  x <- config::get(file = file)

  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = "127.0.0.1",
    port = 5432,
    dbname = x$dbname,
    user = NULL,
    password = NULL
  )

  conn
}


check_schema_exists <- function(config_path) {
  withr::defer({DBI::dbDisconnect(conn)})
  conn <- quick_connection(config_path)
  query <- DBI::dbGetQuery(
    conn,
    "SELECT schema_name FROM information_schema.schemata"
  )
  query
}

check_table_exists <- function(config_path) {
  withr::defer({DBI::dbDisconnect(conn)})
  conn <- quick_connection(config_path)
  query <- DBI::dbGetQuery(
    conn,
    "SELECT * FROM pg_tables"
  )
  query$tablename
}



### expand to be clean up db with options for schema or tables
clean_up_schema <- function(config_path,
                            schema = "boat_count",
                            env = parent.frame()) {
  withr::defer({DBI::dbDisconnect(conn)})
  conn <- quick_connection(config_path)
  cmd <- paste0("DROP SCHEMA ", schema)
  withr::defer({
    try(
      DBI::dbExecute(conn, cmd),
      silent = TRUE
    )
  })
}

clean_up_table <- function(config_path,
                           table = "outing",
                           env = parent.frame()) {
  withr::defer({try(DBI::dbDisconnect(conn))})
  conn <- quick_connection(config_path)
  cmd <- paste0("DROP TABLE ", table)
  withr::defer({
    try(
      DBI::dbExecute(conn, cmd),
      silent = TRUE
    )
  })
}









# if (!is.null(table)) {
#   # need way for table sql code to be dynamically created
#   withr::defer({
#     sql_drop <- paste0("DROP TABLE ", schema, ".", deparse(substitute(table)), ";")
#     try(
#       result <- DBI::dbSendQuery(conn, sql_drop),
#       silent = TRUE
#     )
#     try(
#       DBI::dbClearResult(result),
#       silent = TRUE
#     )
#   }, envir = env)
#   DBI::dbCreateTable(
#     conn,
#     name = DBI::Id(schema = schema, table = deparse(substitute(table))),
#     value = table
#   )
# }
#
# if (data) {
#   DBI::dbAppendTable(
#     conn,
#     name = DBI::Id(schema = schema, table = deparse(substitute(table))),
#     value = table
#   )
# }



