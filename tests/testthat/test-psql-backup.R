test_that("hosted dump works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config-hosted.yml", package = "psql")
  temp_dir <- withr::local_tempdir()
  dump_path <- file.path(temp_dir, "dump_db1.sql")
  psql_backup(
    path = dump_path,
    config_path = config_path
  )
  expect_true(file.exists(dump_path))
})

test_that("local dump works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  temp_dir <- withr::local_tempdir()
  dump_path <- file.path(temp_dir, "dump_db2.sql")
  psql_backup(
    path = dump_path,
    config_path = config_path
  )
  expect_true(file.exists(dump_path))
})
