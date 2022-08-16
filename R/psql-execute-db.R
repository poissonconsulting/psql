#' Execute SQL statement for PostgreSQL database
#'
#' @inheritParams params
#' @param sql A string of the SQL statement to execute.
#'
#' @return A scalar numeric of the number of rows affected by the statement.
#' @export
#'
#' @examples
#' \dontrun{
#' psql_execute_db(
#'  "CREATE SCHEMA boat_count"
#' )
#' psql_execute_db(
#'  "CREATE TABLE boat_count.input (
#'   file_name TEXT NOT NULL,
#'   comment TEXT)"
#' )
#' }
psql_execute_db <- function(
    sql,
    config_path = getOption("psql.config_path", NULL),
    config_value = getOption("psql.value", NULL)
  ) {
  chk::chk_string(sql)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  DBI::dbExecute(conn, sql)
}
