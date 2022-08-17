#' Save PostgreSQL backup
#'
#' Save a copy of your database in a plain text format. This saves all the
#' SQL code to recreate the structure and data.
#'
#' @inheritParams params
#' @param path A string of the file path to save the dumped database
#'
#' @return Returns TRUE
#' @export
#' @details This function requires the user has postgres installed on their
#' machine.
#'
#' Password protected databases require an extra step. A
#' [.pgpass](https://www.postgresql.org/docs/current/libpq-pgpass.html) file
#' needs to be created so you the password can be passed to the function.
#'
#'
#' @examples
#' \dontrun{
#' psql_backup("/Users/user1/Dumps/dump_db.sql")
#' }
psql_backup <- function(
    path = "dump_db.sql",
    config_path = getOption("psql.config_path", NULL),
    config_value = getOption("psql.value", NULL)
  ) {
  chk::chk_string(path)

  config <- config::get(value = config_value, file = config_path)

  cmd <- paste("pg_dump")
  if (!is.null(config$host)) {
    cmd <- paste(cmd, "-h", config$host)
  }
  if (!is.null(config$user)) {
    cmd <- paste(cmd, "-U", config$user)
  }
  if (!is.null(config$port)) {
    cmd <- paste(cmd, "-p", config$port)
  }
  cmd <- paste(cmd, config$dbname, ">", path)

  system(cmd)
  TRUE
}
