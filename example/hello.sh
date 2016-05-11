### BEGIN INIT INFO
# Provides:          scriptname
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

SCRIPT=/opt/test/start_hello.sh
RUNAS=test
 
PIDFILE=/var/run/hello.pid
#LOGFILE=/var/log/<NAME>.log
 
start() {
  if [ "$(ps -ef|grep hello.py|grep -v grep)" -ne "" ]; then
    echo 'Service already running' >&2
    return 1
  fi
  echo 'Starting service…' >&2
  su -c "$SCRIPT &" $RUNAS
  echo 'Service started' >&2
}
 
stop() {
  echo 'stopping service…' >&2
  for i in $(ps -ef|grep hello.py|grep -v grep|tr -s " "|cut -d" " -f2) ;do
    echo "Killing process $i"
    kill $i
  done  
  echo 'Service stopped' >&2

}

### main logic ###
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        #status
        return -1
        ;;
  restart|reload|condrestart)
        stop
        start
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart|reload|status}"
        exit 1
esac
exit 0
