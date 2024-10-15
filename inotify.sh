#!/bin/bash -e
# To view how many inotify watchers I have open and what's holding them open

cols=$(stty size | awk '{print $2}')

printf "%-13s%-8s%-6s%-5s%s\n" COUNT PPID PID UID CMD

grep ^inotify /proc/*/fdinfo/* 2>/dev/null |
    cut -d/ -f3 | sort | uniq -c | sort -n |
    while read -r count pid; do
        printf "%-10s" "$count"
        ps -o ppid=,pid=,uid=,cmd= -p "$pid"
    done |
    awk '{sum += $1; print} END {print sum}' |
    cut -c-"$cols"

echo
sysctl fs.inotify.max_user_watches

