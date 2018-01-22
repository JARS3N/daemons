munge_context <- function() {
  main <- "/mnt/LSAG/Spotting/Logging"
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
    run <- lapply(sub2, parse_sub2_context)
    sapply(run[run == T], print)
    message("Done!!!")
  }
}
