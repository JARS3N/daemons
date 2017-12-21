library(RMySQL)
print(Sys.time())
#library(dryqc)
dir <- "/mnt/LSAG/00 AA SENSOR CRTG MFG/01 CRTG QC_RELEASE/01 XF24-2"
dir_list <- list.dirs(dir, recursive = F)
dir_list2 <- dir_list[basename(dir_list) != "Archives"]

db <- dryqc::query_lots()

not_in_db <- dir_list2[!(basename(dir_list2) %in%  db$Lot)]

are_there_wet_qc_folders <- sapply(lapply(
  lapply(
    not_in_db,
    list.dirs,
    recursive = F,
    full.names = T
  ),
  grepl,
  pattern = "DRY QC"
),
any)

what_to_upload <-
  list.files(grep("DRY QC", list.dirs(not_in_db[are_there_wet_qc_folders], recursive = F), value =
                    T),
             pattern = "QCStats_[0-9]+_[0-9]+_[0-9]+\\.xls$",
             full.names = T)

if (length(what_to_upload) > 0) {
  new_data <-do.call('rbind', lapply(what_to_upload, dryqc::load_qc_stats))
  work <- dryqc::write(new_data)
}
#log_name<-paste0("Log_date_",gsub(":","-",gsub(" ","_",Sys.time())),"dq.txt")
#path<-file.path("/home/Jarsenault/ShinyApps/cron_log")
#writeLines(Sys.time(),file.path(path,log_name))
#saveRDS(not_in_db,file.path(path,log_name,".RDS))
