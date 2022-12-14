#' Parameters for psql functions
#'
#' Descriptions of the parameters for psql functions
#'
#' @keywords internal
#' @name params
#'
#' @param config_path A string of a file path to the yaml configuration file.
#'   The default value grabs the file path from the psql.config_path option
#'   and uses `NULL` if no value supplied.
#' @param config_value A string of the name of value. The default value grabs
#'   the value from the psql.config_value option and uses `"default"` if no
#'   value is supplied.
#' @param tbl_name A string indicating the name of the table.
#' @param schema A string of the schema name. Default value is `"public"`.
NULL
