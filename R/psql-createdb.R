#' Create PostgreSQL database
#'
#' @inheritParams params
#' @param dbname A string of the name of the new database to create.
#'
#' @return Returns TRUE
#' @export
#'
#' @examples
#' \dontrun{
#' psql_createdb("new_database")
#'
#' psql_createdb("new_database", config_path = "keys/config.yml")
#' }
psql_createdb <- function(dbname,
                          config_path = getOption("psql.config_path", NULL),
                          config_value = getOption("psql.value", NULL)) {
  chk::chk_string(dbname)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  cmd <- paste0("CREATE DATABASE ", dbname, ";")
  result <- DBI::dbSendQuery(conn, cmd)
  DBI::dbClearResult(result)

  TRUE
}
