#' Create postgreSQL database
#'
#' @inheritParams params
#' @param dbname
#'
#' @return
#' @export
#'
#' @examples
psql_createdb <- function(dbname,
                          config_path = getOption("psql.config_path", NULL),
                          config_value = getOption("psql.value", NULL)) {

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  cmd <- paste0("CREATE DATABASE ", dbname, ";")
  DBI::dbSendQuery(conn, cmd)

  TRUE
}
