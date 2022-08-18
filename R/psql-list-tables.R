#' List tables in a schema
#'
#' This function lists all the tables in a schema.
#'
#' @inheritParams params
#'
#' @return A vector of table names
#' @export
#' @details The function open and closes its own database connection. You do not
#'   need to close the database connection afterwards.
#'
#' @examples
#' \dontrun{
#' psql_list_tables(
#'   "boat_count"
#' )
#' psql_list_tables()
#' }
psql_list_tables <- function(schema = "public",
                             config_path = getOption("psql.config_path", NULL),
                             config_value = getOption("psql.value", NULL)) {
  chk::chk_string(schema)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  cmd <- DBI::sqlInterpolate(conn, "SELECT * FROM pg_tables WHERE schemaname = ?schema", schema = schema)

  query <- DBI::dbGetQuery(conn, cmd)
  query[["tablename"]]
}
