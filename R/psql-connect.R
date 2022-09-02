#' Connect to PostgreSQL database
#'
#' Connect to a database, either supply connection details though a config file
#' or connect to local default database.
#'
#' @inheritParams params
#'
#' @return An S4 object that inherits from DBIConnection.
#' @export
#' @details The yml file can contain connection details for: host, port, dbname,
#'   user and password. The host, database name, user name and password should
#'   be passed as string. The port is passed as an integer. The function uses
#'   `config::get()` to read the config file, check there for more information
#'   on reading in the config data.
#'
#'   If no config details are passed it will connect to your local cluster.
#'
#'   Set the values for `psql.config_path` and `psql.config_value` for the function to
#'   grab config details. The values can be set `options()`.
#'
#' @examples
#' \dontrun{
#' conn <- psql_connect()
#' DBI::dbDisconnect(conn)
#'
#' psql_connect("config.yml")
#' DBI::dbDisconnect(conn)
#'
#' psql_connect(config_path = "config.yml", config_value = "database")
#' DBI::dbDisconnect(conn)
#' }
psql_connect <- function(config_path = getOption("psql.config_path", NULL),
                         config_value = getOption("psql.config_value", NULL)) {
  chk::chk_null_or(config_path, vld = chk::vld_string)
  chk::chk_null_or(config_value, vld = chk::vld_string)

  if (is.null(config_path) && is.null(config_value)) {
    config <- list(
      host = NULL,
      port = NULL,
      dbname = NULL,
      user = NULL,
      password = NULL
    )
  } else {
    config <- config::get(value = config_value, file = config_path)
  }
  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    host = config$host,
    port = config$port,
    dbname = config$dbname,
    user = config$user,
    password = config$password
  )

  conn
}
