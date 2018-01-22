
parse_sub2_context<-function(DIR){
 bars<-"###########\n"
  require(parallel);
  big_start <- Sys.time()
  dir_fls <- list.dirs(DIR,full.names = T,recursive = F)
  FLS <- unlist(sapply(dir_fls,list.files,pattern="context.xml",full.names=T))
  if(length(FLS)<1){return(NULL)}else{
    message("files exist.")
  }
  cl <- makeCluster( min(length(FLS), detectCores()) );
  work<-parallel::parLapply(cl=cl,FLS,get_context_results)
  DATA<-do.call('rbind',work)
  stopCluster(cl);
  con <- adminKraken::con_mysql()
  dbWriteTable(con, name="mv_context",value= DATA, append=TRUE,overwrite = FALSE,row.names=FALSE)
  big_end<- Sys.time()
 msg_wrote<-paste0(
   bars,
    "wrote Lot ",
    basename(DIR),
    " to table at ",
    Sys.time(),
   "\n",
    " process took ",
    big_end-big_start,
    " seconds."
    )
  message(msg_wrote)
  dbDisconnect(con)
  message("disconnected from db")
}

