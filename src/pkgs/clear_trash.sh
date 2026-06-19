#!/bin/sh

# bruh i didn't even need this bc trash-empty takes days as an argument
# i feel really stupid

help() {
  cat <<EOF

#################################################

  Clears all files in ~/.trash which were put
  there longer ago than the specified timeframe
  (default is 7 days)

  usage: ./clear-trash.sh [-h|-t (time)]

  args:
    -h | --help) print this help
    -t | --time) timeframe after which trash 
                 should be cleared (in days)

  example: ./clear-trash.sh -t7

#################################################

EOF
}

olderthan=7
verbose=0

while :; do
  case $1 in
  -t | --time)
    if [ "$2" != "" ]; then
      olderthan="$2"
    else
      echo "ERROR: -f requires an argument"
      exit 1
    fi
    ;;
  -h | --help) help && exit ;;
  *) break ;;
  esac
  shift
done

trash-list | while IFS= read -r fileinfo; do
  filename=${fileinfo##* }
  filedate=${fileinfo%% *}
  timeframe=$((60 * 60 * 12 * "$olderthan"))
  #[ $(( "$(date +%s -d "$filedate")" + "$timeframe" )) -ge "$(date +%s)" ] && rm -rf "$filename"
  [ $(("$(date +%s -d "$filedate")" + "$timeframe")) -ge "$(date +%s)" ] && echo "$filename"
done
