is_it_in_db_already<-function(x){ 
  require(RMySQL)
  rdb<-adminKraken::con_mysql()
  db_lot<-collect(distinct(select(tbl(rdb,"mv_context"),Lot)))
  query<- paste0('Select distinct(Lot) from mv_context where Lot="',
                 #basename(sub2[1]),
                 basename(x),
                 '";')
  a<- RMySQL::dbSendQuery(rdb,query)
  b<-RMySQL::fetch(a)
  RMySQL::dbClearResult(a)
  dbDisconnect(rdb)
  as.logical(length(b$Lot))
}
