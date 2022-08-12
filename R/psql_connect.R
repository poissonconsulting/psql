#' Connect to PostgreSQL Database
#'
#' @param host A string with the host name
#' @param part An integer with the port number
#' @param dbname A string with the name of the database
#' @param user A string with the username
#' @param password A string with the password for the associated user
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' psql_connect(
#'  host = "127.0.0.1",
#'  port = 5432,
#'  database = "postgres",
#'  username = "postgres",
#'  password = "x7sDja$FhDSa!09d"
#' )
#' }
#'
psql_connect <- function(host, port, dbname, user, password) {
  chk::chk_string(host)
  chk::chk_whole_number(port)
  chk::chk_string(database)
  chk::chk_string(username)
  chk::chk_string(password)


  conn <-  DBI::dbConnect(
    RPostgres::Postgres(),
    host = host,
    port = port,
    dbname = dbname,
    user = user,
    password = password
  )

  conn
}
