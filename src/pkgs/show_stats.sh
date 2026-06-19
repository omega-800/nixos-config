#!/usr/bin/env bash

help() {
cat << EOF

############################################
  Prints system usage in a ~fAnCy* format

  Syntax: ./show_stats.sh
############################################

EOF
}

[ "$1" == "-h" ] && help && exit 0

diskTotal=($(df -l --total | grep total | awk '{printf "%.1f %.1f %.1f %.2f", $2 / 1024^2, $3 / 1024^2, $4 / 1024^2, $5}'))                                   # [total, used, free, percent]
diskRoot=($(df / -l | grep '^/' | awk '{printf "%.1f %.1f %.1f %.2f", $2 / 1024^2, $3 / 1024^2, $4 / 1024^2, $5}'))                                           # [total, used, free, percent]
mem=($(free | grep Mem | awk '{printf "%.1f %.1f %.2f %.1f %.1f", $3 / 1024^2, $2 / 1024^2, $3/$2 * 100.0, $7 / 1024^2, $6 / 1024^2}'))                       # [used, total, percent, free, buffers/cache]
cpu=($(nproc && lscpu | grep '^Core' | awk -F':' '{printf "%i", $2}' && uptime | awk -F',' '{printf " %.2f %.2f", $4, $6}'))                                  # [cores, processors, curr, 15min]
cpuLoad=$(cat <(grep 'cpu ' /proc/stat) | awk -v RS="" '{printf "%.2f", ($2+$3+$4)*100/($2+$3+$4+$5)}')                                                       # load percent    
swap=($(cat /proc/swaps | awk -F'\t' '{for(i=2; i<=NF; i++) sum[i]+=$i} END {for (i=2;i<=NF;i++)if(i!=NF) printf "%d ",sum[i]; else print sum[i]}' | awk '{printf "%.1f %.1f %.2f", $1 / 1024^2, $2 / 1024^2, ($1 - $2) / 1024^2}')) # [total, used, free]
# swap=($(cat /proc/swaps | awk -F'\t' '{for(i=2; i<=NF; i++) sum[i]+=$i} END {for (i=3;i<=NF;i++)if(i!=NF) printf "%d ",sum[i]; else print sum[i]}' | awk '{printf "%.1f %.1f %.2f", $1 / 1024^2, $2 / 1024^2, ($1 - $2) / 1024^2}')) # [total, used, free]

# fancy colors
format() {
    echo "\e[0;49;90m$1\e[m"                                                                `# all text becomes grey` |
        sed -E "s/(\|)/\\\e[0;49;39m\1\\\e[0;49;90m/g"                                      `# separator lines become grey` |
        sed -E "s/(DISK:)/\\\e[1;49;95m\1\\\e[0;49;90m/g"                                   `# DISK: becomes pink` |
        sed -E "s/(MEMORY:)/\\\e[1;49;34m\1\\\e[0;49;90m/g"                                 `# MEMORY: becomes blue` |
        sed -E "s/(CPU:)/\\\e[1;49;36m\1\\\e[0;49;90m/g"                                    `# CPU: becomes turquoise` |
        sed -E "s/(SWAP:)/\\\e[1;49;33m\1\\\e[0;49;90m/g"                                   `# SWAP: becomes red` |
        sed -E "s/(([0-9]|\.)+)([A-Z]{1})/\\\e[1;49;37m\1\\\e[1;49;39m\3\\\e[0;49;90m/g"    `# Gigabyte/Terabyte digits become white+bold and the T/G becomes grey+bold` |
        sed -E "s/ ([0-4]?[0-9](\.[0-9]{1,2})?%)/ \\\e[1;49;32m\1\\\e[0;49;90m/g"           `# 0-49% becomes green` |
        sed -E "s/ ([5-8][0-9](\.[0-9]{1,2})?%)/ \\\e[4;49;33m\1\\\e[0;49;90m/g"            `# 50-89% becomes orange+underline` |
        sed -E "s/ ((9|10)[0-9](\.[0-9]{1,2})?%)/ \\\e[1;41;97m\1\\\e[0;49;90m/g"           `# 90-100% becomes background:red` |
        sed -E "s/ ([0-9]+)(proc|cores)/ \\\e[1;49;37m\1\\\e[0;49;90m\2/g"                  `# cpu processors and cores digits become white+bold and text becomes grey+bold`
}

# 1 in 30 chance to be greeted with green cowsay
if (($RANDOM % 30 == 1)); then
    if command -v cowsay; then
        echo -e "\e[1;49;32m$(cowsay -e ^^ Hello lucky $(whoami)! Welcome to $(uname -n)@$(hostname))\e[0;49;90m"
    else
        echo -e "\e[1;49;32mHello lucky $(whoami)! Welcome to $(uname -n)@$(hostname)\e[0;49;90m"
    fi
fi

echo -e "$(format "CPU: ${cpu[1]}proc - ${cpu[0]}cores - ${cpuLoad}% | DISK: (total: ${diskTotal[1]}G/${diskTotal[0]}G - ${diskTotal[3]}% - ${diskTotal[2]}Gfree) (root: ${diskRoot[1]}G/${diskRoot[0]}G - ${diskRoot[3]}% - ${diskRoot[2]}Gfree)\nSWAP: ${swap[1]}G/${swap[0]}G - $([ "${swap[1]}" == 0.0 ] && echo 0.00 || echo "scale=2; ${swap[1]} / ${swap[0]} * 100" | bc)% - ${swap[2]}Gfree | MEMORY: ${mem[0]}G/${mem[1]}G - ${mem[2]}% - ${mem[3]}Gfree (${mem[4]}G buff/cache)")"


