
parse_sub2_context<-function(DIR){
  db_state<-is_it_in_db_already(DIR)
  cat(
      "Is the Lot in the Database:",
      db_state,
      "\n")
  if(db_state){
    cat(
      "Lot:",
      basename(DIR),
      "is already in the Database. Moving on!\n"
      )
    return(NULL)
  }else{
    cat("Data required.\n")
  }
  require(parallel);
  big_start <- Sys.time()
  # FLS <- file.path(list.dirs(DIR,full.names = T,recursive = F),"context.xml")
  dir_fls <- list.dirs(DIR,full.names = T,recursive = F)
  FLS <- sapply(dir_fls,list.files,pattern="context.xml",full.names=T)
  if(length(FLS)<1){return(NULL)}else{
    message("files exist.")
  }
  cl <- makeCluster( min(legth(FLS), detectCores()) );
  work<-parallel::parLapply(cl=cl,FLS,get_context_results)
  DATA<-do.call('rbind',work)
  stopCluster(cl);
  con <- adminKraken::con_mysql()
  dbWriteTable(con, name="mv_context",value= DATA, append=TRUE,overwrite = FALSE,row.names=FALSE)
  big_end<- Sys.time()
 msg_wrote<-paste0(
    "wrote Lot ",
    basename(DIR),
    " to table at ",
    Sys.time(),
    " process took ",
    big_end-big_start,
    " seconds."
    )
  message(msg_wrote)
  dbDisconnect(con)
  message("disconnect")
}

