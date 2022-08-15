#' Connect to PostgreSQL Database
#'
#' Connect to the default local database or a specific database by supplying
#' the file path for a config.yml file.
#'
#' @param config_path A string of a file path to the yaml configuration file.
#' The default value grabs the file path from the psql.config_path option.
#' @param value A string of the name of value. The default value grabs the value
#' from the psql.value option.
#'
#' @return Returns a postgres connection
#' @details The yml file will use contain connection details for: host, port,
#'  dbname, user and password. The host, database name, user name and password
#'  should be passed as string. The port is passed as an integer.
#'  The function uses `config::get()` to read the config file, check there for
#'  more information on reading in the config data.
#'
#'  If no config details are passed through it will connect to your local
#'  cluster.
#'
#' @examples
#' \dontrun{
#' psql_connect()
#' psql_connect(config_path = "config.yml", value = "database")
#' }
#'
psql_connect <- function(config_path = getOption("psql.config", NULL),
                         value = getOption("psql.value", NULL)) {
  chk::chk_null_or(config_path, vld = chk::vld_string)
  chk::chk_null_or(value, vld = chk::vld_string)

  if (is.null(config_path) & is.null(value)) {
    config <- list(
      host = NULL,
      port = NULL,
      dbname = NULL,
      user = NULL,
      password = NULL
    )
  } else {
    config <- config::get(value = value, file = config_path)
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
