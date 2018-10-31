#!/bin/sh
#
cd $1
echo $$ > ppid
echo "running" > status
if ./xhpl ; then
    echo "completed" > status;
else
    echo "failed" > status;
fi
