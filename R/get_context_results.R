get_context_results <- function(xml) {
  ###
  library(XML)
  xml2 <- XML::xmlTreeParse(xml, useInternalNodes = T)
  index_string <- function(string, index) {
    paste0(strsplit(string, split = "")[[1]][index], collapse = "")
  }
  ###
  bc <- xpathSApply(xml2, path = "//BarCode", xmlValue)#char 1,7:10
  Lot <- index_string(bc, c(1, 7:11))
  sn <- index_string(bc, 2:6)
  #codes<-strsplit(xpathSApply(xml2, path = "//RegressionResults//ResultCodes",xmlValue),split=" ")[[1]]
  codes <-
    xpathSApply(xml2, path = "//RegressionResults//ResultCodes", xmlValue)
  result <- xpathSApply(xml2, path = "//Result", xmlValue)[1]
  data.frame(Lot, sn, result, codes,stingsAsFactors=FALSE)
}
