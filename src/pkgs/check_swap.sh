#!/usr/bin/env bash

help() {
cat << EOF

#########################################
  Lists swap usage by container

  Syntax: sudo ./check_swap.sh 20

  20 being the nr of processes to show
#########################################

EOF
}

[ "$EUID" -ne 0 ] && echo "Please run as root" && help && exit 1

[ "$1" == "-h" ] && help && exit 0

printcol() { printf "%-25s %-15s %-15s %-15.4f %-20s\n" $1 $2 $3 $4 $5; }

printf "%-25s %-15s %-15s %-15s %-20s\n" "CONTAINER" "PID" "PPID" "SIZE (GB)" "CONTAINER ID"

sorted=$(for file in /proc/*/status; do
  awk '/VmSwap|Name|Pid|PPid/{printf "%4s %4s %4s %4s", $2, $3, $4, $5}END{print ""}' $file
done | sort -k5 -n | tail -n "${1:-20}")

while IFS= read -r line; do
  props=($line)
  ppdir="/proc/${props[2]}"
  if [ -d "$ppdir" ]; then
    if [[ $(ls -la $ppdir | grep cwd) =~ ^.+/([^/]+)/?$ ]]; then
      container_id="${BASH_REMATCH[1]}" 
      container_name=$(docker inspect "$container_id" | grep -m 1 Name | sed -r "s@.*/(.+)\",?@\1@g")
      printcol "$container_name" "${props[1]}" "${props[2]}" $(bc <<< "scale=4; ${props[4]}/1000/1000") "$container_id"
    fi
  fi
done <<< "$sorted"


