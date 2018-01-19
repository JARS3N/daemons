main <- "/mnt/LSAG/Spotting/Logging"
subs <- c("XFe24", "XFe96", "XFp")
dirs <- file.path(main, subs)
sub2 <- unlist(lapply(dirs, list.dirs, recursive = F, full.names = T))

get_context_results<-function(xml){
  ###
  library(XML)
  xml2<-XML::xmlTreeParse(xml,useInternalNodes=T)
  index_string<-function(string,index){
    paste0(strsplit(string,split="")[[1]][index],collapse="")
  }
  ###
  bc<-xpathSApply(xml2, path = "//BarCode",xmlValue)#char 1,7:10
  Lot<-index_string(bc,c(1,7:11))
  sn<-index_string(bc,2:6)
  #codes<-strsplit(xpathSApply(xml2, path = "//RegressionResults//ResultCodes",xmlValue),split=" ")[[1]]
  codes<-xpathSApply(xml2, path = "//RegressionResults//ResultCodes",xmlValue)
  result<-xpathSApply(xml2, path = "//Result",xmlValue)[1]
  data.frame(
    Lot,sn,result,codes
  )
}


parse_sub2_context<-function(DIR){
  require(parallel);
  big_start <- Sys.time()
  FLS <- file.path(list.dirs(DIR,full.names = T,recursive = F),"context.xml")
   #index_FLS<-grep("^[0-9]",basename(dirname(FLS)))
  exists<-sapply(FLS,file.exists)
  size.of.list <- sum(exists);
  cl <- makeCluster( min(size.of.list, detectCores()) );
  work<-parallel::parLapply(cl=cl,FLS[exists],get_context_results)
  null_check<-sapply(work,is.null)
  DATA<-do.call('rbind',work[!null_check])
  stopCluster(cl);
  con <- adminKraken::con_mysql()
  dbWriteTable(con, name="mv_context",value= DATA, append=TRUE,overwrite = FALSE,row.names=FALSE)
  big_end<- Sys.time()
  cat("wrote Lot ")
  cat(unname(unique(DATA$Lot)))
  cat(" to table at ")
  cat(big_end)
  cat(" process took ")
  cat(big_end-big_start)
  cat(" seconds\n")
  dbDisconnect(con)
  message("disconnect")
}

run<-lapply(sub2,parse_sub2_context)

message("Done!!!")
