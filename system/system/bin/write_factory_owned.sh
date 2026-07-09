#!/bin/sh

Log()
{
    log -p d -t ChkOrganizationOwned $1
    echo ChkOrganizationOwned--$1
}

SH_WRITE_FAC=/system/bin/CQATest/CQA_commands.sh
ORGANIZATION_OWNED=ro.organization_owned
PROP_OWNED=$(getprop $ORGANIZATION_OWNED)


Log "PROP_OWNED: $PROP_OWNED"
date_in_factory=$($SH_WRITE_FAC READ_OWNED_DATA)
if [ "true" == "$PROP_OWNED" ]; then
   WRITE_TO_FAC="1"
else
   WRITE_TO_FAC="0"
fi
if [ "$date_in_factory" == "$WRITE_TO_FAC" ]; then
   Log "Ignore prop owned setting for same value: $PROP_OWNED"
   exit
fi
$($SH_WRITE_FAC WRITE_OWNED_DATA $WRITE_TO_FAC)
date_in_factory=$($SH_WRITE_FAC READ_OWNED_DATA)
Log "owned write_to_factory: $date_in_factory"

