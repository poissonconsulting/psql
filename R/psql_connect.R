#' Connect to PostgreSQL Database
#'
#' This function uses the information from a yaml configuration file that contains
#' the host, port, database name, username and password to make a connection
#' with a postgres database. When no file is present it will give you a local
#' connection back.
#'
#' @param config_filepath A string of a file path to the yaml configuration file.
#' The default value grabs the file path from the psql.config option.
#' @param value A string of the name of value. The default value grabs the value
#' fomr the psql.value option.
#'
#' @return Returns a postgres connection
#' @details The function requires for a host, port, database name, username and
#'  password is present in the config file given. The host, database name,
#'  user name and password should be passed as string. The port is passed as an
#'  integer.
#'
#'  If no config details are passed through it will connect to your local
#'  cluster.
#'
#'
#' @examples
#' \dontrun{
#' psql_connect()
#' }
#'
psql_connect <- function(config_filepath = getOption("psql.config", NULL),
                         value = getOption("psql.value", NULL)) {
  chk::chk_null_or(config_filepath, vld = chk::vld_string)
  chk::chk_null_or(value, vld = chk::vld_string)

  if (is.null(config_filepath) & is.null(value)) {
    config <- list(
      host = NULL,
      port = NULL,
      dbname = NULL,
      user = NULL,
      password = NULL
    )
  } else {
    config <- config::get(value = value, file = config_filepath)
  }
  conn <-  DBI::dbConnect(
    RPostgres::Postgres(),
    host = config$host,
    port = config$port,
    dbname = config$dbname,
    user = config$user,
    password = config$password
  )

  conn
}
