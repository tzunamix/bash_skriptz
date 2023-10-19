#!/bin/bash
# this script will parse the pflogsumm output and pass it to Zabbix

export LC_ALL=""
export LANG="en_US.UTF-8"
#
if [[ -z "$1" ]]; then
  exit 1
fi
##### PARAMETERS #####
MAILQ=$(which mailq)
PFLOGSUMM=$(which pflogsumm)
MAILLOG="/var/log/maillog"
METRIC="$1"
CACHE_TTL="1740"
CACHE_FILE="/tmp/zabbix.postfix.cache"
EXEC_TIMEOUT="4"
NOW_TIME=`date '+%s'`
##### RUN #####
if [ "$METRIC" = "queue" ]; then
  TEMP_DATA=`${MAILQ} 2>&1 | tail -n1`
  if echo "${TEMP_DATA}" | grep -iq "Mail queue is empty"; then
    echo 0
  elif echo "${TEMP_DATA}" | grep -iPq "in\s+\d+\s+request"; then
    echo "${TEMP_DATA}" | sed -e 's/.*in\s\+\([0-9]\+\)\s\+request.*/\1/gI' 2> /dev/null | head -n1
  else
    # Error
    echo 65535
  fi
  exit 0
else
  if [ -s "${CACHE_FILE}" ]; then
    CACHE_TIME=`stat -c"%Y" "${CACHE_FILE}"`
    DELTA_TIME=$((${NOW_TIME} - ${CACHE_TIME}))
    if [ ${DELTA_TIME} -lt ${EXEC_TIMEOUT} ]; then
      sleep $((${EXEC_TIMEOUT} - ${DELTA_TIME}))
    elif [ ${DELTA_TIME} -gt ${CACHE_TTL} ]; then
      echo "" >> "${CACHE_FILE}" # !!!
      DATE_TO=`date +%d\ %H:%M:%S`
      DATE_FROM=`date -d @${CACHE_TIME} +%d\ %H:%M:%S`
      DATA_CACHE=`sudo cat ${MAILLOG} | sed -e 's/^\([a-zA-Z]\{3\}\s\)\s\([0-9]\s\)/\10\2/g' | awk '$2" "$3>=from && $2" "$3<=to' from="${DATE_FROM}" to="${DATE_TO}" | ${PFLOGSUMM} -h 0 -u 0 --bounce_detail=0 --deferral_detail=0 --reject_detail=0 --smtpd_warning_detail=0 --no_no_msg_size 2>&1`
      echo "${DATA_CACHE}" > ${CACHE_FILE} # !!!
      chmod 640 ${CACHE_FILE}
    fi
  else
    echo "" > ${CACHE_FILE} # !!!
    exit 0
  fi
  awk "BEGIN{IGNORECASE=1} /${METRIC}/ {print \$1}" ${CACHE_FILE} | awk '{print $1}' | awk '/k|m/{p = /k/?1:2}{printf "%d\n", int($1) * 1024 ^ p}' | head -n1
fi

exit 0
