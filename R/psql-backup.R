#' Save PostgreSQL backup
#'
#' Save a copy of your database in a plain text format. This saves all the SQL
#' code to recreate the structure and data.
#'
#' @inheritParams params
#' @param path A string of the file path to save the dumped database
#'
#' @return Returns TRUE
#' @export
#' @details This function requires the user has psql installed on their
#'   machine.Go to [postgres](https://www.postgresql.org/download/) for download
#'   instructions.
#'
#'   Password protected databases require an extra step. A
#'   [.pgpass](https://www.postgresql.org/docs/current/libpq-pgpass.html) file
#'   needs to be created so you the password can be passed to the function. The
#'   function will check if you have a password present in your config file it
#'   will require you to have a .pgpass file in your home directory.
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

  # ensure user has psql on thier system before proceeding
  software_test <- try(system2("psql", "--version", stdout = TRUE))
  if (class(software_test) == "try-error") {
    stop(
      "you must have `psql` downloaded before proceeding.
      Go to https://www.postgresql.org/download/ for instructions."
    )
  }

  config <- config::get(value = config_value, file = config_path)
  # ensure .pgpass file is present (except when not needed)
  if (!is.null(config$password)) {
    if (!file.exists("~/.pgpass")) {
      stop("you must have a .pgpass file before proceeding")
    }
  }

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

  # errors because pg_dump creates new file even when it errors out
  if (file.size(path) == 0) {
    stop("Dumped database is zero bytes, transfer failed")
  }

  TRUE
}
