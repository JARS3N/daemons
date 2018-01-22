db_lots<-function(){ 
  require(RMySQL)
  rdb<-adminKraken::con_mysql()
  # db_lot<-collect(distinct(select(tbl(rdb,"mv_context"),Lot)))
  query<- paste0('Select distinct(Lot) from mv_context;')
  a<- RMySQL::dbSendQuery(rdb,query)
  b<-RMySQL::fetch(a)
  RMySQL::dbClearResult(a)
  dbDisconnect(rdb)
return(b$Lot)
}
