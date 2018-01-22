munge_context <- function(from='remote') {
  loc_list<-c(
    local="G:/Spotting/Logging",
    remote="/mnt/LSAG/Spotting/Logging"
  )
  main <- loc_list[from]
  # check if the drve is connceted
  connected <- dir.exists(main)
  if (!connected) {
    message("Spock is blind!")
    return(NULL)
  } else{
    subs <- c("XFe24", "XFe96", "XFp")
    dirs <- file.path(main, subs)
    sub2 <-
      unlist(lapply(
        dirs,
        list.dirs,
        recursive = F,
        full.names = T
      ))
    # filter out stuff in db already
    exists_in_db<-db_lots()
    index<-basename(sub2) %in% exists_in_db
    cat("There are ",
    sum(!index),
    " Lots to process\n")
    if(sum(!index)>0){
      print(basename(sub2)[!index])
      }
    run <- lapply(sub2[!index], parse_sub2_context)
    message("Done!!!")
  }
}
