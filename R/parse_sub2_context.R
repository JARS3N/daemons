
parse_sub2_context<-function(DIR){
  db_state<-is_it_in_db_already(DIR)
  cat("Is the Lot in the Database: ")
  cat(db_state)
  cat("\n")
  if(db_state){
    cat("Lot: ")
    cat(basename(DIR))
    cat(" is already in the Database. Moving on!\n")
    return(NULL)
  }else{
    cat("Data required.\n")
  }
  require(parallel);
  big_start <- Sys.time()
  FLS <- file.path(list.dirs(DIR,full.names = T,recursive = F),"context.xml")
  #index_FLS<-grep("^[0-9]",basename(dirname(FLS)))
  exists<-sapply(FLS,file.exists)
  size.of.list <- sum(exists);
  if(size.of.list<1){return(NULL)}else{
    message("files exist.")
  }
  cl <- makeCluster( min(size.of.list, detectCores()) );
  work<-parallel::parLapply(cl=cl,FLS[exists],get_context_results)
  # null_check<-sapply(work,is.null)
  # DATA<-do.call('rbind',work[!null_check])
  DATA<-do.call('rbind',work)
  stopCluster(cl);
  con <- adminKraken::con_mysql()
  dbWriteTable(con, name="mv_context",value= DATA, append=TRUE,overwrite = FALSE,row.names=FALSE)
  big_end<- Sys.time()
  cat("wrote Lot ")
  cat(basename(DIR))
  cat(" to table at ")
  cat(Sys.time())
  cat(" process took ")
  cat(big_end-big_start)
  cat(" seconds\n")
  dbDisconnect(con)
  message("disconnect")
}

