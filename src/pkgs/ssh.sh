#!/usr/bin/env bash

downloads_dir="/home/omega/dl/"
shops_dir="/home/omega/doc/work/shops/"

#alias Pluto='ssh -p6699 root@ns1.inteco.ch'
cpPluto() {
	scp -P6699 root@ns1.inteco.ch:"$1" "$downloads_dir"
	cd "$downloads_dir"
}
#alias Zeus='ssh -p6699 root@zeus.inteco.ch'
cpZeus() {
	scp -P6699 root@zeus.inteco.ch:"$1" "$downloads_dir"
	cd "$downloads_dir"
}
#alias Apollo='ssh -p6699 inteco@apollo.inteco.ch'
cpApollo() {
	scp -P6699 inteco@apollo.inteco.ch:"$1" "$downloads_dir"
	cd "$downloads_dir"
}
#alias Morpheus='ssh -p6699 -c aes256-cbc inteco@morpheus.inteco.ch'
cpMorpheus() {
	morpheus_reg='^/var/lib/tomcat7/webapps/([^/]+).+$'
	scp -P6699 inteco@morpheus.inteco.ch:"$1" "$downloads_dir"
	cd "$downloads_dir"
}
#alias Ares='ssh -p6699 -c aes256-cbc inteco@ares.inteco.ch'
cpAres() {
	copy_to=$downloads_dir
	ares_reg='^/var/lib/tomcat7-?(common|shop|test)?/webapps/([^_]+).+$'
	if [[ $1 =~ $ares_reg ]]; then
		customer_id="${BASH_REMATCH[2]}"
		copy_to="$shops_dir$customer_id"
		[[ -d $copy_to ]] || mkdir "$copy_to"
	fi
	scp -P6699 inteco@ares.inteco.ch:"$1" "$copy_to"
	cd "$copy_to"
	filename=$(basename "$1")
	extract "$filename"
}
#alias SB='ssh -p6699 inteco@sb-new.inteco.ch'
SB_URL='inteco@sb-new.inteco.ch'
cpSB() {
	copy_to=$downloads_dir
	sb_reg='^/home/inteco/stacks/web/([^/]+).+$'
	if [[ $1 =~ $sb_reg ]]; then
		customer_id="${BASH_REMATCH[1]}"
		copy_to="$shops_dir$customer_id"
		[[ -d $copy_to ]] || mkdir "$copy_to"
	fi
	scp -P6699 "$SB_URL:$1" "$copy_to"
	cd "$copy_to"
	filename=$(basename "$1")
	extract "$filename"
}
SBDB() {
	filename=$(date +%y-%m-%d)_dump_$1.sql
	ssh -p6699 "$SB_URL" "(docker exec $1_db_1 mysqldump -uroot -p\$(sed -nr 's/^DB_ROOT_PW=\s?(.+)$/\1/p' \"/home/inteco/stacks/web/$1/.env\") wegas_$1) > $filename"
	copy_to="$shops_dir$1/sql"
	[[ -d $copy_to ]] || mkdir -p "$copy_to"
	scp -P6699 "$SB_URL:/home/inteco/$filename" "$copy_to" && ssh -p6699 "$SB_URL" "rm $filename"
	cd "$copy_to"
}
warToSB() {
	if [[ $1 =~ ^(.+)-webapp.war$ ]]; then
		customer="${BASH_REMATCH[1]}"
		scp -P6699 "$1" "$SB_URL:/home/inteco/stacks/web/$customer"/tmp/deployment/
	fi
}
