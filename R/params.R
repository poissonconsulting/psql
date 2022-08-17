#' Parameters for readwriteaws functions
#'
#' Descriptions of the parameters for readwriteaws functions
#'
#' @keywords internal
#' @name params
#'
#' @param config_path A string of a file path to the yaml configuration file.
#' The default value grabs the file path from the psql.config_path option.
#' @param config_value A string of the name of value. The default value grabs the value
#' from the psql.value option.
#' @param tbl_name A string indicating the name of the table. Default is to use
#'  the name of the `tbl` argument.
#' @param schema A string of the schema name. Default value is `"public"`.
NULL
