#' Read a table from a PostgreSQL database
#'
#' Read a table from a PostgreSQL database as a data frame.
#'
#' @inheritParams params
#'
#' @return A data frame
#' @export
#' @details The function open and closes its own database connection. You do not
#'   need to close the database connection afterwards.
#'
#' @examples
#' \dontrun{
#' psql_read_table("capture")
#' psql_read_table("counts", "boat_count")
#' }
psql_read_table <- function(tbl_name,
                            schema = "public",
                            config_path = getOption("psql.config_path", NULL),
                            config_value = getOption("psql.config_value", "default")) {
  chk::chk_string(tbl_name)
  chk::chk_string(schema)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  output <- DBI::dbReadTable(
    conn = conn,
    name = DBI::Id(schema = schema, table = tbl_name)
  )
  output
}
