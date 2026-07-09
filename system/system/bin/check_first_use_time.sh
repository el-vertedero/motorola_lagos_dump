#!/bin/sh

Log()
{
    log -p d -t Chk1stTime $1
    echo Chk1stTime--$1
}

SH_FST_USE_TIME=/system/bin/CQATest/CQA_commands.sh
PROP_CHECK_BAT_FIRST_USE_DATE=sys.odm.check.batt_first_use_date
CUR_DATE=$(getprop $PROP_CHECK_BAT_FIRST_USE_DATE)

function shouldWriteToFactory
{
    RESULT=$($SH_FST_USE_TIME READ_FIRST_USAGE_DATE_FLAG)
    if [ "$RESULT" == "FAIL" ]; then
        echo "-1"
    elif [ "$RESULT" == "1" ]; then
        echo "1"
    else
        echo "0"
    fi
}

Log "CUR_DATE: $CUR_DATE"
should_write_to_factory=$(shouldWriteToFactory)
Log "should_write_to_factory: $should_write_to_factory"
if [ "$should_write_to_factory" == "1" ]; then
    # "1" means first use date can be set.
    if [ -z "$CUR_DATE" ]; then
        # if CUR_DATE is empty, no need to refresh factory.
        Log "Ignore writing for empty $PROP_CHECK_BAT_FIRST_USE_DATE: $CUR_DATE"
        exit
    fi
    $($SH_FST_USE_TIME WRITE_FIRST_USAGE_DATE $CUR_DATE)
    $($SH_FST_USE_TIME WRITE_FIRST_USAGE_DATE_FLAG 0)
    Log "write_to_factory: $CUR_DATE"
    exit
elif [ "$should_write_to_factory" == "-1" ]; then
      Log "Read FacsvcClient fail."
      exit
else
    date_in_factory=$($SH_FST_USE_TIME READ_FIRST_USAGE_DATE)
    if [ "$date_in_factory" == "$CUR_DATE" ]; then
      Log "Ignore prop setting for same value: $CUR_DATE"
      exit
    fi
    setprop $PROP_CHECK_BAT_FIRST_USE_DATE "$date_in_factory"
    Log "date_in_factory: $date_in_factory"
fi
