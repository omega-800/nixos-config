#!/bin/bash
     
help() {
cat << EOF

#########################################
  Lists disk usage by container

  Syntax: sudo ./docker_disk_usage.sh 
#########################################

EOF
}

#  lists disk usage of docker containers
# alias dcs='sudo du -sh /var/lib/docker/containers/* | sort -rh | while read id ; do echo -e "\n$id" && [[ $id =~ ^.+/([^/]+)$ ]] && docker inspect "${BASH_REMATCH[1]}" | grep -m 1 Name | sed -r "s@.*/(.+)\",?@\1@g"; done'

[ "$EUID" -ne 0 ] && echo "Please run as root" && help && exit 1
[ "$1" == "-h" ] && help && exit 0

# list disk usage of containers and sort by size > iterate over list
du -sh /var/lib/docker/containers/* | sort -h | while read id ; do
  # get the container id through <3regex<3 and let docker inspect it. grep the container name from the output and remove unnecessary chars with sed
  [[ $id =~ ^.+/([^/]+)$ ]] && name=$(docker inspect "${BASH_REMATCH[1]}" | grep -m 1 Name | sed -r "s@.*/(.+)\",?@\1@g")
  # finally print it all out in the format of {size(red)} {name(green)} {path/id(normal)} (substitute with ??? if name couldn't be regex'ed, shouldn't happen though)
  printf "\n\033[0;31m%-6s \033[0;32m%-30s \033[0;0m%s" "${id%%	*}" "${name:-???}" "${id##*	}"
done
echo -e "\n"


