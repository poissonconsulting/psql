#' Connect to PostgreSQL Database
#'
#' Connect to a database, either supply connection details though a config file
#'  or connect to local default database.
#'
#' @param config_path A string of a file path to the yaml configuration file.
#' The default value grabs the file path from the psql.config_path option.
#' @param value A string of the name of value. The default value grabs the value
#' from the psql.value option.
#'
#' @return Returns a database connection
#' @details The yml file can contain connection details for: host, port,
#'  dbname, user and password. The host, database name, user name and password
#'  should be passed as string. The port is passed as an integer.
#'  The function uses `config::get()` to read the config file, check there for
#'  more information on reading in the config data.
#'
#'  If no config details are passed it will connect to your local cluster.
#'
#'  Set the values for `psql.config_path` and `psql.value` for the function
#'   to grab config details.
#'   The values can be set `options()`.
#'
#' @examples
#' \dontrun{
#' conn <- psql_connect()
#' DBI::dbDisconnect(conn)
#'
#' psql_connect("config.yml")
#' DBI::dbDisconnect(conn)
#'
#' psql_connect(config_path = "config.yml", value = "database")
#' DBI::dbDisconnect(conn)
#' }
#'
psql_connect <- function(config_path = getOption("psql.config_path", NULL),
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
