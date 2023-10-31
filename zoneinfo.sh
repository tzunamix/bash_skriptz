#!/bin/sh
# 
# zoneinfo - show the current time in the specified timezone or 
#   geographic zone. Without any argument, show UTC/GMT. Use
#   the word "list" to see a list of known geographic regions
#   Note that it's possible to match a zone directory (a region)
#   but that only timezone files are valid specifications.
#   
#   Timezone database ref: http://www.twinsun.com/tz/tz-link.htm

zonedir="/usr/share/zoneinfo"
if [ ! -d $zonedir ] ; then
        echo "No timezone database at $zonedir." >&2 ; exit 1
fi

if [ -d "$zonedir/posix" ] ; then
        zonedir=$zonedir/posix
fi

if [ $# -eq 0 ] ; then
        timezone="UTC"
        mixedzone="UTC"
        elif [ "$1" = "list" ] ; then
                ( echo "All known timezones and regions defined on this system:"
                cd $zonedir
                find * -type f -print | xargs -n 2 | awk '{ printf "  %-38s %-38s\n", $1, $2 }' ) | $PAGER
                exit 0
        else
                region="$(dirname $1)"
                zone="$(basename $1)"

                # Is it a direct match?  If so,  we're good to go. Otherwise we need 
                # to dig around a bit to find things. Start by just counting matches
                matchcnt="$(find $zonedir -name $zone -type f -print | wc -l | sed 's/[^[:digit:]]//g' )"
                if [ "$matchcnt" -gt 0 ] ; then       # at least one file matches
                        if [ $matchcnt -gt 1 ] ; then       # more than one file match
