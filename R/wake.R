wake<-function(){
  #need to rund as sudo
  require(cronR)
  cmd_dryqc<-cron_rscript(system.file(package='daemons',path='cron','dryqc.R'))
  cmd_mv<-cron_rscript(system.file(package='daemons',path='cron','mv.R'))
  cron_add(command = cmd_dryqc,frequency = 'daily', at='1:01', id = 'dryqc')
  cron_add(command = cmd_mv,frequency = 'daily', at='2:01', id = 'mv')
}
