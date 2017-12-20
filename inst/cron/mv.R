library(details)
main <- "/mnt/LSAG/Spotting/Logging"
subs <- c("XFe24", "XFe96", "XFp")
dirs <- file.path(main, subs)

sub2 <- unlist(lapply(dirs, list.dirs, recursive = F, full.names = T))

# df = lots in the Spotting directory
df <- data.frame(loc = sub2,
                 Lot = basename(sub2),
                 stringsAsFactors = F)
dbLots <- details::get_lots()

need_to_add <- df[!(df$Lot %in% dbLots$Lot), ]

work<-details::check_nightly(need_to_add)

log_name<-paste0("Log_date_",gsub(":","-",gsub(" ","_",Sys.time())),"mv.txt")
path<-file.path("/home/Jarsenault/ShinyApps/cron_log")
writeLines(Sys.time(),file.path(path,log_name))
write.csv(file.path(path,log_name,".csv))
