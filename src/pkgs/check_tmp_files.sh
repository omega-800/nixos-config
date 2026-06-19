#!/usr/bin/env bash

############################################################
# Help                                                     #
############################################################
help()
{
cat << EOF

##########################################################################
  Lists temporary files and directories (must be run as root)
  
  Syntax: sudo ./check_tmp_files.sh -[h|s|c|d
				     |t (log|webapp)
				     |i (customerID)]

  Options:
  h     print this help
  s     sort output by size
  c     concise mode (only prints total)
  d	delete backup/*.xml
  t     types to list only
        - log
        - webapp
  i     only check provided customer (by dirname)
        - [customerID]
##########################################################################

EOF
}

############################################################
# Args                                                     #
############################################################

ROOT_DIR='/home/inteco/stacks/web/'
WEBAPP_DIRS=('admin' 'www')
WEBAPP_TMP_DIRS=('backup' 'logs' 'restore' 'sync')
SIZE=0
OUTPUT=''

[ -d $ROOT_DIR ] || exit 1

while getopts ":hsdct:i:" arg; do
  case $arg in
    t) 
      TYPE=${OPTARG}
      echo "showing only $TYPE"
      if [[ $TYPE == 'log' ]]; then
        WEBAPP_TMP_DIRS=('logs')
      elif [[ $TYPE == 'webapp' ]]; then
        WEBAPP_TMP_DIRS=('backup' 'restore' 'sync')
      else
        echo "Invalid argument passed: only 'log' or 'webapp' are accepted"
      fi
      ;;
    i) CUSTOMERID=${OPTARG} ;;
    c) SILENT=true          ;;
    s) SORT=true            ;;
    d) DELETE=true          ;;
    h | *) help; exit 0     ;;
  esac
done

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

if [ "$EUID" -ne 0 ]
  then echo "[[sudo /home/inteco/scripts/check_tmp_files.sh -h]] >> Please run as root to check temporary files which can be deleted"
  exit 1
fi

processInfo()
{
  if [ -z $SILENT ]; then
    OUTPUT="$OUTPUT$(awk '{ printf "%s %.2f %.2f %s %s %s\n", "Size:" , $1/1024/1024/1024, $1/1024/1024, $1, "Path:", $2; }' <(echo "$1" "$2$3")) "
  fi
  SIZE=$((SIZE + $1))
}

if [ -z $CUSTOMERID ]; then
  echo "checking all dirs"
  DIRS_TO_CHECK=$( find $ROOT_DIR -maxdepth 1 -type d )
else 
  echo "only checking $CUSTOMERID"
  DIRS_TO_CHECK="$ROOT_DIR$CUSTOMERID"
fi

for D in $DIRS_TO_CHECK; do
  if [ -z $TYPE ] || [ $TYPE == 'webapp' ]; then 
    DIR="${D}/tmp/deployment"
    if [ -d $DIR ]; then 
      for FILE in $(find $DIR -type f | awk '!/unpacked\//'); do
        [ -z "$DELETE" ] && processInfo $(wc -c "$FILE")
      done
      for UNPACKED in $(find $DIR -type d | awk '!/unpacked\// && /unpacked/'); do
        [ -z "$DELETE" ] && processInfo $(du -bs "$UNPACKED") "/"
      done
    fi
  fi
  if [ -z $TYPE ] || [ $TYPE == 'log' ]; then 
    LOGDIR="${D}/container/app/data/logs"
    [ -d $LOGDIR ] && [ -z "$DELETE" ] && processInfo $(du -bs "$LOGDIR") "/"
    DBLOGDIR="${D}/container/db/data/log"
    [ -d $DBLOGDIR ] && [ -z "$DELETE" ] && processInfo $(du -bs "$DBLOGDIR") "/"
    DBLOGDIR2="${D}/container/db/data"
    [ -d $DBLOGDIR2 ] && [ -z "$DELETE" ] && processInfo $(find $DBLOGDIR2 -maxdepth 1 -type f -regextype sed -regex '.*binlog\.[[:digit:]]\{6\}' -print0 | du --files0-from=- -cbs | tail -1 | sed "s@total@$DBLOGDIR2/(only_binlog)@g")
  fi
  for WEBDIR in ${WEBAPP_DIRS[@]}; do
    DIRECTORY="${D}/container/app/data/webapps/${WEBDIR}/ROOT/"
    if [ -d "$DIRECTORY" ]; then 
      if [ -z $TYPE ] || [ $TYPE == 'webapp' ]; then 
        for FILE in $(find $DIRECTORY -type f | awk '!/backup\// && !/jsp/ && /backup/' ); do
	  [ -z "$DELETE" ] && processInfo $(wc -c "$FILE")
        done
      fi
      for WEB_TMP_DIR in ${WEBAPP_TMP_DIRS[@]}; do
        TMP_DIR="${DIRECTORY}${WEB_TMP_DIR}"
	if [ -d $TMP_DIR -a "$WEB_TMP_DIR" != "logs" -a -n "$DELETE" ]; then
	  echo "rm -rf $TMP_DIR/*"
	  rm -rf "$TMP_DIR"/*
	  processInfo $(du -bs "$TMP_DIR") "/"
	elif [ -d $TMP_DIR -a -z "$DELETE" ]; then
	  processInfo $(du -bs "$TMP_DIR") "/"
	fi
      done
    fi
  done
done


if [ -z $SILENT ]; then 
  if [ -z $SORT ]; then 
    printf "%-15s GB: %-7.2f MB: %-10.2f B: %-20s %s %s\n" $OUTPUT
  else 
    printf "%-15s GB: %-7.2f MB: %-10.2f B: %-20s %s %s\n" $OUTPUT | sort -h -k 7
  fi
  printf "\n%-15s GB: %-7.2f MB: %-10.2f B: %-20s %s %s\n\n" "TOTAL" $(bc <<< "scale=2; $SIZE/1024/1024/1024") $(bc <<< "scale=2; $SIZE/1024/1024") $SIZE
else
  printf "%s GB of temporary files can be deleted. \nRun [[sudo /home/inteco/scripts/check_tmp_files.sh -h]] for more info.\n" $( bc <<< "scale=4; $SIZE / 1024 / 1024 / 1024" )
fi

[ -n "$DELETE" ] && echo "DELETED"
