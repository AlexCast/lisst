context("Import LISST data")

test_that("read LISST-100X binary checks agains LISST-SOP raw output", {
	flSOP    <- system.file("extdata", "DN_27.log", package = "lisst")
	binSOP   <- read.table(flSOP, header = F)
	for(i in 1:38) units(binSOP[, i]) <- 1
	fltest   <- system.file("extdata", "DN_27.DAT", package = "lisst")
	binlisst <- read_lisst(fltest, sn = '1298', pl = 0.05, yr = 2018, out = 'raw')
  for(i in 1:40) expect_equal(binlisst[, i], binSOP[, i])
})

test_that("read LISST-200X binary checks agains LISST-SOP raw output", {
	flSOP    <- system.file("extdata", "sp_april.rtx", package = "lisst")
	binSOP   <- read.table(flSOP, header = F, sep = ',')
	binSOP[binSOP > 40950] <- binSOP[binSOP > 40950] - 65536
	binSOP[, 1:36] <- binSOP[, 1:36] / 10
	for(i in c(1:42, 49:59)) units(binSOP[, i]) <- 1
	fltest   <- system.file("extdata", "sp_april.RBN", package = "lisst")
	binlisst <- read_lisst(fltest, sn = '2028', pl = 0.025, out = 'raw')
  for(i in 1:59) expect_equal(binlisst[, i], binSOP[, i])
})

test_that("alternative read_lisst calls for LISST-100X works", {
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	binlisst <- read_lisst(fltest, sn = '1298', pl = 0.05, yr = 2018, out = 'raw')
	suppressWarnings(test   <- read_lisst(fltest, sn = '1298', pl = 0.05, out = 'raw'))
	expect_identical(binlisst, test)
	suppressWarnings(test   <- read_lisst(fltest, sn = '1298', yr = 2018, out = 'raw'))
	expect_identical(binlisst, test)
	suppressWarnings(test   <- read_lisst(fltest, sn = '1298', out = 'raw'))
	expect_identical(binlisst, test)
	suppressWarnings(test   <- read_lisst(fltest, model = '100XC', out = 'raw'))
	expect_identical(drop_lisst(binlisst), drop_lisst(test))
	zscat  <- system.file("extdata", "bg_20180326.asc", package = "lisst")
	binlisst <- read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.05, yr = 2018, out = 'raw')
	zscat  <- t(read.table(zscat, header = F))
	for(i in 1:38) units(zscat[, i]) <- 1
	zscat  <- structure(zscat, type = 'raw', lproc = list(A = 1), 
		linst = list(A = 1), lmodl = list(A = 1), zscat = list(A = 1), 
		class = c("lisst", "data.frame"))
	test   <- read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.05, yr = 2018, out = 'raw')
	expect_identical(binlisst, test)

	zscat  <- system.file("extdata", "bg_20180326.asc", package = "lisst")
	fltest <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	prolisst <- read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.05, yr = 2018, out = 'vol')
	suppressWarnings(test   <- read_lisst(fltest, model = '100XC'))
	expect_identical(drop_lisst(prolisst), drop_lisst(test))
})

test_that("alternative read_lisst calls for LISST-200X works", {
	fltest <- system.file("extdata", "sp_april.RBN", package = "lisst")
	binlisst <- read_lisst(fltest, sn = '2028', pl = 0.025, out = 'raw')
	suppressWarnings(test   <- read_lisst(fltest, sn = '2028', out = 'raw'))
	expect_identical(binlisst, test)
	suppressWarnings(test   <- read_lisst(fltest, out = 'raw'))
	expect_identical(binlisst, test)

# Background file created manualy from the one saved inside the instrument. Maybe
# that is generating the error?
#	zscat  <- system.file("extdata", "bg_lisst200_april.asc", package = "lisst")
#	suppressWarnings(test   <- read_lisst(fltest, zscat = zscat, out = 'raw'))
#	expect_identical(binlisst, test)

#	zscat  <- t(read.table(zscat, header = F))
#	for(i in c(1:42, 49:59)) units(zscat[, i]) <- 1
#	zscat  <- structure(zscat, type = 'raw', lproc = list(A = 1), 
#		linst = list(A = 1), lmodl = list(A = 1), zscat = list(A = 1), 
#		class = c("lisst", "data.frame"))
#	test   <- read_lisst(fltest, zscat = zscat, pl = 0.025, out = 'raw')
#	expect_identical(drop_lisst(binlisst), drop_lisst(test))

	fltest <- system.file("extdata", "sp_april_rs.csv", package = "lisst")
	prolisst <- read_lisst(fltest, sn = '2028', pl = 0.025, out = 'vol')
	test   <- read_lisst(fltest, model = '200X', pl = 0.025)
	expect_identical(drop_lisst(prolisst), drop_lisst(test))
})

test_that("read_lisst will give proper warnings", {
	fltest   <- system.file("extdata", "DN_27.DAT", package = "lisst")
	expect_warning(read_lisst(fltest, sn = '1298', pl = 0.05, out = 'raw'), "yr not provided - using best guess")
	expect_warning(read_lisst(fltest, sn = '1298', yr = 2018, out = 'raw'), "pl not provided - assuming standard path length (0.05 m)", fixed = T)
	fltest   <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	expect_warning(read_lisst(fltest, sn = '1298', zscat = 'bckgf', pl = 0.05, yr = 2018, out = 'vol'), "zscat file bckgf not found; zscat data will not be added to lisst object")
	fltest   <- system.file("extdata", "sp_april.RBN", package = "lisst")
	expect_warning(read_lisst(fltest, sn = '2028', out = 'raw'), "pl not provided - assuming standard path length (0.025 m)", fixed = T)
})

test_that("read_lisst will give proper errors", {
	expect_error(read_lisst('lisstFile'), "File lisstFile not found")
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	expect_error(read_lisst(fltest, out = 'vol'), "out for binary LISST files must be 'raw', 'cor', 'cal' or 'vsf'")
	expect_error(read_lisst(fltest, out = 'pnc'), "out for binary LISST files must be 'raw', 'cor', 'cal' or 'vsf'")
	fltest <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	expect_error(read_lisst(fltest, out = 'raw'), "out for LISST SOP processed files must be 'vol' or 'pnc'")
	expect_error(read_lisst(fltest, out = 'cor'), "out for LISST SOP processed files must be 'vol' or 'pnc'")
	expect_error(read_lisst(fltest, out = 'cal'), "out for LISST SOP processed files must be 'vol' or 'pnc'")
	expect_error(read_lisst(fltest, out = 'vsf'), "out for LISST SOP processed files must be 'vol' or 'pnc'")
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	expect_error(read_lisst(fltest, out = 'cor'), "Processing of binary to 'cor', 'cal' or 'vsf' requires instrument specific information - sn of a registered instrument must be provided")
	expect_error(read_lisst(fltest, out = 'cal'), "Processing of binary to 'cor', 'cal' or 'vsf' requires instrument specific information - sn of a registered instrument must be provided")
	expect_error(read_lisst(fltest, out = 'vsf'), "Processing of binary to 'cor', 'cal' or 'vsf' requires instrument specific information - sn of a registered instrument must be provided")
	expect_error(read_lisst(fltest, out = 'raw'), "For reading processed files or for 'raw' outputs from binary files, model must be supplied if sn is not")
	fltest <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	expect_error(read_lisst(fltest, out = 'vol'), "For reading processed files or for 'raw' outputs from binary files, model must be supplied if sn is not")
	expect_error(read_lisst(fltest, out = 'pnc'), "For reading processed files or for 'raw' outputs from binary files, model must be supplied if sn is not")
	expect_error(read_lisst(fltest, model = '000', out = 'vol'), "model must be one of '100(X)B', '100(X)C' or '200X'", fixed = T)
	expect_error(read_lisst(fltest, sn = '0000', out = 'vol'), "Instrument not registered. See ?lisst_reg", fixed = T)
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	expect_error(read_lisst(fltest, sn = '1298', out = 'cor'), "zscat must be provided for out 'cor', 'cal' or 'vsf'")
	expect_error(read_lisst(fltest, sn = '1298', out = 'cal'), "zscat must be provided for out 'cor', 'cal' or 'vsf'")
	expect_error(read_lisst(fltest, sn = '1298', out = 'vsf'), "zscat must be provided for out 'cor', 'cal' or 'vsf'")
	expect_error(read_lisst(fltest, sn = '1298', zscat = 'bckgd', out = 'cor'), "zscat file bckgd not found")
	expect_error(read_lisst(fltest, sn = '1298', zscat = 'bckgd', out = 'cal'), "zscat file bckgd not found")
	expect_error(read_lisst(fltest, sn = '1298', zscat = 'bckgd', out = 'vsf'), "zscat file bckgd not found")
	zscat <- system.file("extdata", "bg_20180326.asc", package = "lisst")
	expect_error(read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.1, out = 'vsf'), "Path length in LISST-100X cannot be larger than 0.05 m")
	fltest <- system.file("extdata", "sp_april.RBN", package = "lisst")
	expect_error(read_lisst(fltest, pl = 0.1, out = 'vsf'), "Path length in LISST-200X cannot be larger than 0.025 m")
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	expect_error(read_lisst(fltest, sn = '2028', zscat = zscat, pl = 0.025, yr = 2018), "LISST-200X binary files must have a .RBN extension")	
	fltest <- system.file("extdata", "sp_april_rs.csv", package = "lisst")
	expect_error(read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.025, yr = 2018), "LISST-100(X) processed files must have a .asc extension", fixed = T)
	fltest <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	expect_error(read_lisst(fltest, sn = '2028', zscat = zscat, pl = 0.025, yr = 2018), "LISST-200X processed files must have a .csv extension", fixed = T)
	expect_error(read_lisst(fltest, model = '200', zscat = zscat, pl = 0.025, yr = 2018), "LISST-200X processed files must have a .csv extension", fixed = T)
	fltest <- system.file("extdata", "sp_april.RBN", package = "lisst")
	zscat  <- read_lisst(fltest, pl = 0.025, out = 'raw')
	zscat  <- lstat(zscat, brks = list(1:nrow(zscat)))
	fltest <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	expect_error(read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.05, yr = 2018, out = 'vol'), "zscat file not compatible with model")
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	expect_error(read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.05, yr = 2018, out = 'vsf'), "zscat file not compatible with model")
	fltest <- system.file("extdata", "sp_april.RBN", package = "lisst")
	zscat <- system.file("extdata", "bg_20180326.asc", package = "lisst")
	expect_error(read_lisst(fltest, zscat = zscat, pl = 0.025), "zscat file not compatible with model", fixed = T)
})

test_that(".lisst_bin and .lisst_pro will give proper errors", {
	fltest <- system.file("extdata", "DN_27.DAT", package = "lisst")
	zscat  <- read_lisst(fltest, sn = '1298', pl = 0.05, yr = 2018, out = 'raw')
	expect_error(read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.025, yr = 2018), "A lisst object used as zscat must have a single row - use lstat for aggregation")	
	fltest <- system.file("extdata", "DN_27_rs.asc", package = "lisst")
	expect_error(read_lisst(fltest, sn = '1298', zscat = zscat, pl = 0.025, yr = 2018), "A lisst object used as zscat must have a single row - use lstat for aggregation")	

	fltest <- system.file("extdata", "sp_april.RBN", package = "lisst")
	zscat  <- read_lisst(fltest, out = 'raw', pl = 0.025)
	expect_error(read_lisst(fltest, zscat = zscat, pl = 0.025), "A lisst object used as zscat must have a single row - use lstat for aggregation")	
	fltest <- system.file("extdata", "sp_april_rs.csv", package = "lisst")
	expect_error(read_lisst(fltest, sn = '2028', zscat = zscat, pl = 0.025), "A lisst object used as zscat must have a single row - use lstat for aggregation")	
})



