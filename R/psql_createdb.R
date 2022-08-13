#' Create postgreSQL database
#'
#' @param dbname
#' @param config
#' @param value
#'
#' @return
#' @export
#'
#' @examples
psql_createdb <- function(dbname, config, value) {
  cmd <- paste("createdb", dbname)
  system(cmd)
  TRUE
}
