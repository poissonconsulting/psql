#' Create PostgreSQL database
#'
#' Create a new PostgreSQL database.
#'
#' @inheritParams params
#' @param dbname A string of the name of the new database to create.
#'
#' @return TRUE (or errors).
#' @export
#' @details The function open and closes its own database connection. You do not
#'   need to close the database connection afterwards.
#'
#' @examples
#' \dontrun{
#' psql_create_db("new_database")
#' psql_create_db("new_database", config_path = "keys/config.yml")
#' }
psql_create_db <- function(dbname,
                           config_path = getOption("psql.config_path", NULL),
                           config_value = getOption("psql.config_value", "default")) {
  chk::chk_string(dbname)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  cmd <- paste0("CREATE DATABASE ", dbname, ";")
  result <- DBI::dbSendQuery(conn, cmd)
  DBI::dbClearResult(result)
  invisible(TRUE)
}
