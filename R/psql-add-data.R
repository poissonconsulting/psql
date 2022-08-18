#' Add data to PostgreSQL database
#'
#' Add data with a data frame to your PostgreSQL database. The data frame name
#' must match the table name in your database, if not use the `tbl_name`
#' argument to pass the table name.
#'
#' @inheritParams params
#' @param tbl The data frame to add to the database.
#' @param tbl_name A string indicating the name of the table. Default is to use
#'   the name of the `tbl` argument.
#'
#' @return returns a scalar numeric.
#' @export
#' @details The function open and closes its own database connection. You do not
#'   need to close the database connection afterwards.
#'
#'   This function uses `DBI::dbAppendTable()` to add data to the database.
#'
#' @examples
#' \dontrun{
#' psql_add_data(outing, "creel")
#' psql_add_data(outing_new, "creel", "outing")
#' }
psql_add_data <- function(tbl,
                          schema = "public",
                          tbl_name = NULL,
                          config_path = getOption("psql.config_path", NULL),
                          config_value = getOption("psql.value", NULL)) {
  chk::chk_string(schema)

  if (is.null(tbl_name)) tbl_name <- deparse((substitute(tbl)))
  chk::chk_string(tbl_name)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  DBI::dbAppendTable(
    conn = conn,
    name = DBI::Id(schema = schema, table = tbl_name),
    value = tbl
  )
}
