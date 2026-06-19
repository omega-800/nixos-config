#!/usr/bin/env bash

help() {
cat << EOF

#########################################
  Filters log and sorts lines by 
  number of occurrences

  Syntax: sudo ./filter_log.sh 2024

  2024 being the substring of filenames
  to include in result
#########################################

EOF
}

[ "$1" == "-h" ] && help && exit 0

# filters stack-trace and unnecessary lines from log files and sorts the lines by nr of occurrences
# param: substring of filenames which should be included
output=""
filenames=$(find . -maxdepth 1 -type f -name "*$1*")
for filename in $filenames; do
	output="$output\n$(cat $filename |
		grep -v -E '[[:space:]]+at' |
		grep -v '\.\.\.' |
		grep -v ': produktebilder/' |
		grep -v 'from workspace dms' |
		grep -v '\.importer\.' |
		sed -r 's/[0-9]{1,2}-[a-zA-Z]{3}-[0-9]{4} [0-9\.:]+ (SEVERE|INFO) \[[a-z0-9-]+\] //g' |
		sed -r 's/(([0-9]{4}(-[0-9]{2}){2}T)?([0-9]{2}[:\.]){2}[0-9]{2}\.?([0-9]{6}Z|[0-9]{2,3})?|([0-9]{2}-[A-Z][a-z]{2}-[0-9]{4}))//g')"
done

sort <<< $output | uniq -c | sort -n | sed "s@^[[:space:]]\+\([0-9]\+\)@$(tput setaf 1)\1$(tput sgr0)@g"

# one-liner

# sort <<< $(find . -maxdepth 1 -type f -name "*$1*" | xargs -I{} bash -c "cat {} | grep -v -E '[[:space:]]+at' | grep -v '\.\.\.' | grep -v ': produktebilder/' | grep -v 'from workspace dms' | grep -v '\.importer\.' | sed -r 's/[0-9]{1,2}-[a-zA-Z]{3}-[0-9]{4} [0-9\.:]+ (SEVERE|INFO) \[[a-z0-9-]+\] //g' | sed -r 's/(([0-9]{2}[:\.]?){3}([0-9]{2,3})?|[0-9]{2}-[A-Z][a-z]{2}-[0-9]{4})//g'") | uniq -c | sort -n | sed "s@^[[:space:]]\+\([0-9]\+\)@$(tput setaf 1)\1$(tput sgr0)@g"


