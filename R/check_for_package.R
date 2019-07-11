check_for_package <- function(pkg, os) {
  if (.Platform["OS.type"] == os) {
    if (!requireNamespace(pkg, quietly = T)) {
      install.packages(pkg)
      message(paste("installing", pkg, "package", sep = " "))
    }
  }
}

