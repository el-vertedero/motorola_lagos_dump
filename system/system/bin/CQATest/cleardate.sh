#!/system/bin/sh

TAG=CQAClearDate

FACSVC_CLIENT=/vendor/bin/FacsvcClient

Log()
{
    log -p d -t $TAG $1
    echo $TAG - $1
}

function SET_PROP
{
    if [ -z "$1" ]; then
        Log "No property to set."
        return 1
    fi
    prop_name=$1
    expected_val="${2:-}"
    setprop "$prop_name" "$expected_val"
    set_result=$(getprop $prop_name)
    [ "$set_result" = "$expected_val" ] && Log "setprop OK" || Log "setprop failed!"
    Log "After setprop $prop_name '$expected_val', getprop result: '$set_result'"
}

function CLEAR_DATE
{
    [ -x "$FACSVC_CLIENT" ] || {
        Log "The file does NOT exist: $FACSVC_CLIENT"
        return 1
    }

    Log "cleardate start."

    RESULT=$($FACSVC_CLIENT -w 185 -v 0)
    Log "clear date RESULT = $RESULT"

    RESULT=$($FACSVC_CLIENT -w 186 -s 1)
    Log "clear date flag RESULT = $RESULT"

    prop_check=sys.odm.check.batt_first_use_date
    SET_PROP "$prop_check"

    prop_vendor=vendor.clear_batt_first_usage_date
    SET_PROP "$prop_vendor" done

    Log "cleardate done."
}

##### Main #####
echo
CLEAR_DATE
echo
