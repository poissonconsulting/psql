test_that("hosted dump works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config-hosted.yml", package = "psql")
  psql_backup(
    path = "~/Dumps/dump_db1.sql",
    config_path = config_path
    )
  expect_true(file.exists("~/Dumps/dump_db1.sql"))
  unlink("~/Dumps/dump_db1.sql")
})

test_that("local dump works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql_backup(
    path = "~/Dumps/dump_db2.sql",
    config_path = config_path
  )
  expect_true(file.exists("~/Dumps/dump_db2.sql"))
  unlink("~/Dumps/dump_db2.sql")
})

test_that("default local dump works", {
  skip_on_ci()
  config_path <- system.file("testhelpers/config.yml", package = "psql")
  psql_backup(
    config_path = config_path
  )
  expect_true(file.exists("dump_db.sql"))
  unlink("dump_db.sql")
})
