#' Title
#'
#' @inheritParams params
#' @param tbl A dataframe that
#'
#' @return
#' @export
#'
#' @examples
psql_add_data <- function(
    tbl,
    schema = "public",
    tbl_name = NULL,
    config_path = getOption("psql.config_path", NULL),
    config_value = getOption("psql.value", NULL)
  ) {

  chk::chk_string(schema)
  if (is.null(tbl_name)) tbl_name <- deparse_backtick_chk((substitute(tbl)))
  chk::chk_string(tbl_name)

  conn <- psql_connect(config_path, config_value)
  on.exit(DBI::dbDisconnect(conn))

  dbAppendTable(
    conn = conn,
    name = Id(schema = schema, table = tbl_name),
    value = data
  )

  TRUE
}
