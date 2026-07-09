#!/system/bin/sh

# Copyright (C) 2016 Motorola Mobility, Inc.
# All Rights Reserved

# Please provide implementation for all the functions below.
# Then, push this script to /mnt/sdcard/CQATest/

# Your code must provide return values in text form such as:
# RETURN=PASS
# RETURN=FAIL
# RETURN=<VALUE>

# 20250508

version=0.3
Default_Delay=5

readonly  HEAD_1="7E0039180700000000"
readonly  HEAD_2="7E0008180600000000"
readonly  HEAD_3="7E0009180500000000"
readonly  HEAD_4="7E0046180400000000"
readonly  HEAD_5="7E000A0A0200000000"
readonly  HEAD_6="7E0007130500000000"
readonly  HEAD_7="7E0007130100000000"
readonly  HEAD_8="7E0007130300000000"
readonly  HEAD_9="7E0007130400000000"
readonly  HEAD_10="7E000A260400000000"
readonly  HEAD_11="7E0009090E00000000"
readonly  HEAD_12="7E0012020100000000"
readonly  HEAD_13="7E0006120200000000"
readonly  HEAD_14="7E0002070100000000"
readonly  HEAD_15="7E0002070200000000"
readonly  HEAD_16="7E0006120100000000"
readonly  HEAD_17="7E0006240100000000"
readonly  HEAD_18="7E0006240200000000"
readonly  HEAD_19="7E0007270100000000"
readonly  HEAD_20="7E000A090600000000"
readonly  HEAD_21="7E0006090900000000"
readonly  HEAD_22="7E000A090700000000"
readonly  HEAD_23="7E0007090A00000000"
readonly  HEAD_24="7E0007090B00000000"
readonly  HEAD_25="7E0002090F00000000"
readonly  HEAD_26="7E0006190100000000"
readonly  HEAD_27="7E0006020500000000"
readonly  HEAD_28="7E0006020300000000"
readonly  HEAD_29="7E0006020200000000"
readonly  HEAD_30="7E0012010300000000"
readonly  HEAD_31="7E0012010600000000"
readonly  HEAD_32="7E0046180200000000"
readonly  HEAD_33="7E000A020400000000"

readonly  TAIL_AABB="AABB"
readonly  TAIL_CRRC="CRRC"
readonly  TAIL_00="00"

Log(){
    log -p d -t cqa_commands $1
}

function USB_DETACHED_SHUTDOWN
{

    if [ -z $1 ]; then
		 echo "Default Wait: $Default_Delay"
		 AC_Delay=$Default_Delay
	 else
		 echo "Wait: $1"
		 AC_Delay=$1
	 fi

	 Log "USB_DETACHED_SHUTDOWN : AC_Delay = $AC_Delay "

     am broadcast -a "com.mmi.helper.usbrequest" --es type "usb_detached" --es action "test" -f 0x01000000
     RET1=$?
     Log "USB_DETACHED_SHUTDOWN : RETURN RET1 = $RET1"
     if [ $RET1 -ne 0 ];then
         Log "USB_DETACHED_SHUTDOWN : RETURN=FAIL"
         echo "RETURN=FAIL"
     else
         Log "USB_DETACHED_SHUTDOWN : RETURN=PASS"
         echo "RETURN=PASS"
     fi

     sleep $AC_Delay
}


function ENABLE_AT_FLAG
{
	RESULT=$(/vendor/bin/FacsvcClient -w 84 -s 31232700)
	Log "ENABLE_AT_FLAG : RESULT = $RESULT "
	if [ "$RESULT" = "write ok!" ]; then
		Log "ENABLE_AT_FLAG: AT Flag write ok!"
		echo "PASS"
	else
		Log "ENABLE_AT_FLAG: AT Flag write fail!"
		echo "FAIL"
	fi
}

function DISABLE_AT_FLAG
{
	RESULT=$(/vendor/bin/FacsvcClient -w 84 -s 31232701)
	Log "DISABLE_AT_FLAG : RESULT = $RESULT "
	if [ "$RESULT" = "write ok!" ]; then
		Log "DISABLE_AT_FLAG: AT Flag write ok!"
		echo "PASS"
	else
		Log "DISABLE_AT_FLAG:AT Flag write fail!"
		echo "FAIL"
	fi
}

function RESET_TEST_FLAG
{
    BT_Reset=$(FacsvcClient -w 34 -s 0)
    if [ "$BT_Reset" = "write ok!" ]; then
         Log "WRITE_TEST_FLAG: BT Flag reset ok!"
    else
         Log "WRITE_TEST_FLAG: BT Flag reset fail!"
    fi
	
	UCT_Reset=$(FacsvcClient -w 16 -v 0)
    if [ "$UCT_Reset" = "write ok!" ]; then
         Log "WRITE_TEST_FLAG: UCT Flag reset ok!"
    else
         Log "WRITE_TEST_FLAG: UCT Flag reset fail!"
    fi

    L2V_Reset=$(FacsvcClient -w 77 -v 0)
    if [ "$L2V_Reset" = "write ok!" ]; then
         Log "WRITE_TEST_FLAG: L2Vision Flag reset ok!"
    else
         Log "WRITE_TEST_FLAG: L2Vision Flag reset fail!"
    fi

    AR_Reset=$(FacsvcClient -w 14 -v 0)
    if [ "$AR_Reset" = "write ok!" ]; then
         Log "WRITE_TEST_FLAG: AR Flag reset ok!"
    else
         Log "WRITE_TEST_FLAG: AR Flag reset fail!"
    fi

    DC_Reset=$(FacsvcClient -w 15 -v 0)
    if [ "$DC_Reset" = "write ok!" ]; then
         Log "WRITE_TEST_FLAG: Dual Camera Flag reset ok!"
    else
         Log "WRITE_TEST_FLAG: Dual Camera Flag reset fail!"
    fi

    if [ "$L2V_Reset" != "write ok!" ]||[ "$AR_Reset" != "write ok!" ]||[ "$DC_Reset" != "write ok!" ]; then
         echo "7E0046180100000001AABB"
    else
         echo "7E0046180100000000AABB"
    fi
}

function READ_TEST_FLAG
{
    Flag="00000000000000000000000000000000"
    BT_Flag=$(FacsvcClient -r 34 -s)
	UCT_Flag=$(FacsvcClient -r 16 -v)
    L2V_Flag=$(FacsvcClient -r 77 -v)
    AR_Flag=$(FacsvcClient -r 14 -v)
    DC_Flag=$(FacsvcClient -r 15 -v)

    Log "READ_TEST_FLAG : BT_Flag=$BT_Flag,UCT_Flag=$UCT_Flag,L2V_Flag=$L2V_Flag,R_Flag=$AR_Flag,DC_Flag=$DC_Flag"

    if [ "$BT_Flag" -eq 1 ]; then
        Flag="${Flag:0:1}1${Flag:2}"
    fi
	if [ "$UCT_Flag" -eq 1 ]; then
        Flag="${Flag:0:2}1${Flag:3}"
    fi
    if [ "$L2V_Flag" -eq 1 ]; then
        Flag="${Flag:0:16}1${Flag:17}"
    fi
    if [ "$AR_Flag" -eq 1 ]; then
        Flag="${Flag:0:17}1${Flag:18}"
    fi
    if [ "$DC_Flag" -eq 1 ]; then
        Flag="${Flag:0:18}1${Flag:19}"
    fi

    if [ $BT_Flag -gt 1 ]||[ $UCT_Flag -gt 1 ]||[ $L2V_Flag -gt 1 ]||[ $AR_Flag -gt 1 ]||[ $DC_Flag -gt 1 ]; then
        echo "7E004618020000000100000000000000000000000000000000AABB"
    else
        echo "$HEAD_32$Flag$TAIL_AABB"
    fi
}

function WRITE_TEST_FLAG
{
    if [ -z $1 ]; then
        echo "7E0046180300000001AABB"
        Log "WRITE_TEST_FLAG: No input"
        exit 1
    fi
    length=$(echo -n "$1" | wc -c)
    if [ "$length" -ne 32 ]; then
        echo "7E0046180300000001AABB"
        Log "WRITE_TEST_FLAG: Input length should be 32"
        exit 1
    fi

    Flag=$1

    BT_Flag=${Flag:1:1}
	UCT_Flag=${Flag:2:1}
    L2V_Flag=${Flag:16:1}
    AR_Flag=${Flag:17:1}
    DC_Flag=${Flag:18:1}

    Log "WRITE_TEST_FLAG : BT_Flag=$BT_Flag,UCT_Flag=$UCT_Flag,L2V_Flag=$L2V_Flag,R_Flag=$AR_Flag,DC_Flag=$DC_Flag"

    if [ "$BT_Flag" -eq 0 -o "$BT_Flag" -eq 1 ]; then
         BT_W=$(FacsvcClient -w 34 -s "$BT_Flag")
         if [ "$BT_W" = "write ok!" ]; then
              Log "WRITE_TEST_FLAG: BT Flag write ok!"
         else
              Log "WRITE_TEST_FLAG: BT Flag write fail!"
         fi
    fi
    if [ "$UCT_Flag" -eq 0 -o "$UCT_Flag" -eq 1 ]; then
         UCT_W=$(FacsvcClient -w 16 -v $UCT_Flag)
         if [ "$UCT_W" = "write ok!" ]; then
              Log "WRITE_TEST_FLAG: UCT_Flag Flag write ok!"
         else
              Log "WRITE_TEST_FLAG: UCT_Flag Flag write fail!"
         fi
    fi
    if [ "$L2V_Flag" -eq 0 -o "$L2V_Flag" -eq 1 ]; then
         L2V_W=$(FacsvcClient -w 77 -v $L2V_Flag)
         if [ "$L2V_W" = "write ok!" ]; then
              Log "WRITE_TEST_FLAG: L2Vision Flag write ok!"
         else
              Log "WRITE_TEST_FLAG: L2Vision Flag write fail!"
         fi
    fi
    if [ "$AR_Flag" -eq 0 -o "$AR_Flag" -eq 1 ]; then
          AR_W=$(FacsvcClient -w 14 -v $AR_Flag)
          if [ "$AR_W" = "write ok!" ]; then
               Log "WRITE_TEST_FLAG: AR Flag write ok!"
          else
               Log "WRITE_TEST_FLAG: AR Flag write fail!"
          fi
    fi
    if [ "$DC_Flag" -eq 0 -o "$DC_Flag" -eq 1 ]; then
          DC_W=$(FacsvcClient -w 15 -v $DC_Flag)
          if [ "$DC_W" = "write ok!" ]; then
               Log "WRITE_TEST_FLAG: Dual Camera Flag write ok!"
          else
               Log "WRITE_TEST_FLAG: Dual Camera Flag write fail!"
          fi
    fi

    if [ "$BT_W" != "write ok!" ]||[ "$UCT_W" != "write ok!" ]||[ "$L2V_W" != "write ok!" ]||[ "$AR_W" != "write ok!" ]||[ "$DC_W" != "write ok!" ]; then
         echo "7E0046180300000001AABB"
    else
         echo "7E0046180300000000AABB"
    fi
}

##### Read hardware sku - BEGIN #####
# Note: This get the hardware sku
function READ_HW_SKU
{    # insert your code below
	RET=$(getprop ro.boot.hardware.sku)
	Log "READ_HW_SKU : RET = $RET "
	echo $RET
}

# asciid to hex string, maybe buggy.
# xxd change to newline every 16-bytes so we use echo -n to replace \n and tr -d ' ' to replace spaces.
# change to use printf instead of xxd?
function ascii_to_hex
{
    hex_val=$(echo -n $1 | xxd -p)
    echo -n $hex_val|tr -d ' '
}

function hex_to_ascii
{
    ascii_val=$(echo -n $1 | xxd -r -p)
    echo $ascii_val
}
#################Group:asciid to hex string function  End###################

function GET_CHARGE_IC_MODEL
{
    RET=$(cat /sys/class/power_supply/primary_chg/model_name | tr '[:upper:]' '[:lower:]')
    case "$RET" in
      "sgm41512sd" | "sc89602d") echo "10" ;;
      "sgm41542s"  | "sy6970c")  echo "18" ;;
      *) echo "$RET" ;;  # 其他情况输出原型号
    esac
}

function GET_BATTERY_LEVEL
{
    RET=$(cat /sys/class/power_supply/battery/capacity)
    echo "$RET"
}

function UTAG_SET_DDR_VENDOR
{
    Log "HW_CONFIG_FRONTCOLOR : ID = $1"
    if [[ -z $1 ]]; then
                echo "FAIL, wrong parameter!"
    else
        RESULT=$(/vendor/bin/FacsvcClient -w 195 -s "$1")
        Log "UTAG_SET_DDR_VENDOR : RESULT = $RESULT"
        if [[ -z $RESULT ]]; then
            Log "UTAG_SET_DDR_VENDOR : FAIL"
            echo "FAIL"
        else
            Log "UTAG_SET_DDR_VENDOR : PASS"
            echo "PASS"
        fi
    fi
}

function UTAG_GET_DDR_VENDOR
{
    RESULT=$(/vendor/bin/FacsvcClient -r 195 -s)
    Log "UTAG_GET_DDR_VENDOR : RESULT = $RESULT "
    if [[ -z $RESULT ]]; then
        Log "UTAG_GET_DDR_VENDOR : FAIL "
        echo "FAIL"
    else
        Log "UTAG_GET_DDR_VENDOR : PASS " 
        echo $RESULT
    fi
}


function SET_SIM_FLAG
{
    Log "SET_SIM_FLAG : parameter = $1"
    if [[ -z $1 ]]; then
                echo "FAIL, wrong parameter!"
    else
	
        local lower_param=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        
        # Check if parameter is either "ss" or "dsd"
        if [[ "$lower_param" != "ss" && "$lower_param" != "dsd" ]]; then
            Log "SET_SIM_FLAG : Invalid parameter - $1"
            echo "FAIL"
            return
        fi
        
        # Determine value to set based on parameter
        local value_to_set
        if [[ "$lower_param" == "ss" ]]; then
            value_to_set=1
        else
            value_to_set=0
        fi
        
        RESULT=$(/vendor/bin/FacsvcClient -w 9 -v "$value_to_set")
        Log "SET_SIM_FLAG : RESULT = $RESULT"
        if [[ -z $RESULT ]]; then
            Log "SET_SIM_FLAG : FAIL"
            echo "FAIL"
        else
            Log "SET_SIM_FLAG : PASS"
            echo "PASS"
        fi
    fi
}

function GET_SIM_FLAG
{
    RESULT=$(/vendor/bin/FacsvcClient -r 9 -v)
    Log "GET_SIM_FLAG : raw result = $RESULT"
    
    if [[ -z $RESULT ]]; then
        Log "GET_SIM_FLAG : FAIL (empty result)"
        echo "FAIL"
    else
        # Remove any whitespace or non-printing characters
        CLEAN_RESULT=$(echo "$RESULT" | tr -d '[:space:]')
        
        case $CLEAN_RESULT in
            "01")
                OUTPUT="ss"
                ;;
            "00")
                OUTPUT="dsd"
                ;;
            *)
                Log "GET_SIM_FLAG : FAIL (unexpected result: $CLEAN_RESULT)"
                echo "FAIL"
                return
                ;;
        esac
        
        Log "GET_SIM_FLAG : PASS - $OUTPUT"
        echo "$OUTPUT"
    fi
}

##### FINGERPRINT Self Test - BEGIN #####
function FingerPrint_SelfTest
{
    setprop vendor.ontim.cit.fpselftest 0
	if [ -z $1 ]; then
		echo "Default Wait: $Default_Delay"
		FP_Delay=$Default_Delay
	else
		echo "Wait: $1"
		FP_Delay=$1
	fi
	Log "FingerPrint_SelfTest : FP_Delay = $FP_Delay "

  am broadcast -a com.mmi.helper.request --es type "fp_test" -f 0x01000000 > /dev/null
	RET1=$?
	if [ $RET1 -ne 0 ];then
		echo "RETURN=FAIL (CAN NOT START FP SELF_TEST)"
		exit 1
	fi

	sleep $FP_Delay

	RET2=$(getprop vendor.ontim.cit.fpselftest)
	Log "FingerPrint_SelfTest : RET2 = $RET2 "
	if [ "$RET2" == "1" ]; then
	  Log "FingerPrint_SelfTest : RETURN=PASS "
		echo "RETURN=PASS"
	else
	  Log "FingerPrint_SelfTest : RETURN=FAIL "
		echo "RETURN=FAIL"
	fi
}
##### FINGERPRINT Self Test - END #####

function Turn_Unit_Secure
{
    RET=$(getprop ro.boot.securefuse)
    Log "$RET"

    Log "Turn_Unit_Secure : RET = $RET "

    if [ "$RET" == "true" ]; then
      Log "Turn_Unit_Secure : RETURN=PASS "
		  echo "RETURN=PASS"
	  else
	    Log "Turn_Unit_Secure : RETURN=FAIL "
		  echo "RETURN=FAIL"
	  fi
}

##### READ_TRACK_ID  #####

function READ_TRACK_ID
{
    # insert your code below
    READ_TRACK_ID="FAIL"
    for i in $(seq 5 -1 1)
    do
    if [ $(getprop ro.serialno) = "" ];then
    #echo "wait..."
    READ_TRACK_ID="FAIL"
    else
    SN=$(getprop ro.serialno)
    READ_TRACK_ID="OK"
	#asciiStr="ABCDEFG"
 
    for c in $(echo $SN|sed 's/./& /g')
    do
        hexArr=$hexArr$(printf "%X" "'$c")
    done

    echo "7E0046180400000000"$hexArr"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000AABB"

    break
    fi
    sleep 0.5
    done
    if [ $READ_TRACK_ID = "FAIL" ];then
    echo "7E0006180400000003AEA3"
    #  echo "feature $0 not implemented"
    fi
}



##### CHECK_POWER_UP  #####

function CHECK_POWER_UP
{
    # insert your code below
    if [ "$(getprop sys.boot_completed)" = "1" ];then
	echo "7E00081806000000003100AABB"
	else
	echo "7E00081806000000003000AABB"
	fi
}

##### Returns the HW ID to distinguish SKUs ####
function READ_HW_ID
{
    RET=$(getprop ro.boot.hwsku)
    if [ -z "$RET" ]; then
      echo "7E000918050000000000001AABB"
    else
      hex=$(printf "%02X" $RET)
      echo "7E0009180500000000"$hex"0000AABB"
    fi
}

##### UTAG_SET_BATTERY_ID  #####

function UTAG_SET_BATTERY_ID
{
    Log "UTAG_SET_BATTERY_ID : ID = $1 "
    if [[ -z $1 ]]; then
        echo "FAIL, wrong parameter!"
    else
        if [[ $1 == "LWNRL52SWD" || $1 == "ATLRL52NVT" || $1 == "COSRL52COS" || $1 == "ATLSL70NVT"
            || $1 == "VEKRL52ZJD"|| $1 == "ATLRL52UCB"|| $1 == "LWNSL70SWD" ]]; then
            RESULT=$(/vendor/bin/FacsvcClient -w 89 -s $1)
            Log "UTAG_SET_BATTERY_ID : RESULT = $RESULT "
            if [[ -z $RESULT ]]; then
                Log "UTAG_SET_BATTERY_ID : FAIL "
                echo "FAIL"
            else
                Log "UTAG_BATTERY_ID : PASS "
                echo "7E0006250200000000328ACRRC"
            fi
        else
            Log "UTAG_SET_BATTERY_ID : FAIL, wrong parameter! "
            echo "FAIL, wrong parameter!"
        fi
    fi
}

##### UTAG_GET_BATTERY_ID  #####

function UTAG_GET_BATTERY_ID
{
	RESULT=$(/vendor/bin/FacsvcClient -r 89 -s)
	Log "UTAG_GET_BATTERY_ID : RESULT = $RESULT "
	echo "$RESULT"
}

function UTAG_SET_WALLPAPER
{
    Log "HW_CONFIG_FRONTCOLOR : ID = $1"
    if [[ "$1" == "tapestry" || "$1" == "arabesque" || "$1" == "tendril" || "$1" == "laureloak" || "$1" == "cannelicream" ]]; then
        RESULT=$(/vendor/bin/FacsvcClient -w 182 -s "$1")
        Log "HW_CONFIG_FRONTCOLOR : RESULT = $RESULT"
        if [[ -z $RESULT ]]; then
            Log "HW_CONFIG_FRONTCOLOR : FAIL"
            echo "FAIL"
        else
            Log "HW_CONFIG_FRONTCOLOR : PASS"
            echo "7E000618020000000000CRRC"
        fi
    else
        echo "FAIL, wrong parameter!"
    fi
}

function UTAG_GET_WALLPAPER
{
    RESULT=$(/vendor/bin/FacsvcClient -r 182 -s)
    Log "HW_READ_FRONTCOLOR : RESULT = $RESULT "
    if [[ -z $RESULT ]]; then
        Log "HW_READ_FRONTCOLOR : FAIL "
        echo "FAIL"
    else
        Log "HW_READ_FRONTCOLOR : PASS "
        # 将RESULT转换为ASCII码
        ASCII_RESULT=$(echo -n "$RESULT" | xxd -p)
        echo "7E0006180300000000"$ASCII_RESULT
    fi
}

##### GET_TYPE_C_STATE  #####

function GET_TYPE_C_STATE
{
  # insert your code below
	RET=$(cat /sys/devices/platform/extcon_usb/cc_orient)
	log_info "usb_type.log" "read node /sys/devices/platform/extcon_usb/cc_orient => $RET"
	if [ "$RET" == "CC1" ];then
	  echo "7E0009090E00000000434331AABB"
	elif [ "$RET" == "CC2" ]; then
	  echo "7E0009090E00000000434332AABB"
	elif [ "$RET" == "CCNone" ]; then
	  echo "7E0009090E0000000043434EAABB"
	fi
}

##### READ_BATTERY_THERMISTOR_VALUE  #####

function READ_BATTERY_THERMISTOR_VALUE
{
    # insert your code below
    log_path="thermal.log"

    RET=$(grep -w '^battery$' /sys/class/thermal/thermal_zone*/type -rnIs)
    log_info "$log_path" "battery_thermal content = $RET"

    zone_num=$(echo "$RET" | awk -F'thermal_zone' '{print $2}' | awk -F'/' '{print $1}')
    if [ -z "$zone_num" ]; then
      log_info "$log_path" "Failed to extract zone number from grep result."
      return
    fi

    temp_node="/sys/class/thermal/thermal_zone${zone_num}/temp"
    if [ -f "$temp_node" ]; then
      a=1000
      result=$(cat "$temp_node")
      log_info "$log_path" "battery_thermal node path= $temp_node, Temperature = $result"
      #echo $RET
      temp=$(echo $((result/a)))
      #echo $temp
      if [ $temp -gt 0 ]; then
        hex=$(printf "%04x" $temp)
      else
        hex=$(printf "%04x" $((temp & 0xFFFF)))
      fi
      echo "7E0007130500000000"$hex"AABB"
    else
      log_info "$log_path" "Temperature node file does not exist: $temp_node"
      return
    fi
}

function READ_AP_THERMISTOR_VALUE
{
    # insert your code below
    log_path="thermal.log"

    RET=$(grep -w '^mtktsAP$' sys/class/thermal/thermal_zone*/type -rnIs)
    log_info "$log_path" "ap_thermal content = $RET"

    zone_num=$(echo "$RET" | awk -F'thermal_zone' '{print $2}' | awk -F'/' '{print $1}')
    if [ -z "$zone_num" ]; then
      log_info "$log_path" "Failed to extract zone number from grep result."
      return
    fi

    temp_node="/sys/class/thermal/thermal_zone${zone_num}/temp"
    if [ -f "$temp_node" ]; then
        a=1000
        result=$(cat "$temp_node")
        log_info "$log_path" "ap_thermal node path= $temp_node, Temperature = $result"
        temp=$(echo $((result/a)))
        if [ $temp -gt 0 ]; then
          hex=$(printf "%04x" $temp)
        else
          hex=$(printf "%04x" $((temp & 0xFFFF)))
        fi

        echo "7E0007130100000000"$hex"AABB"
    else
      log_info "$log_path" "Temperature node file does not exist: $temp_node"
      return
    fi
}

# Read the PCB Thermistor value
function READ_PCB_THERMISTOR_VALUE
{
    # insert your code below
    log_path="thermal.log"

    RET=$(grep -w '^mtk_ts_board$' /sys/class/thermal/thermal_zone*/type -rnIs)
    log_info "$log_path" "pcb_thermal content = $RET"

    zone_num=$(echo "$RET" | awk -F'thermal_zone' '{print $2}' | awk -F'/' '{print $1}')
    if [ -z "$zone_num" ]; then
      log_info "$log_path" "Failed to extract zone number from grep result."
      return
    fi

    temp_node="/sys/class/thermal/thermal_zone${zone_num}/temp"
    if [ -f "$temp_node" ]; then
      a=1000
      result=$(cat "$temp_node")
      log_info "$log_path" "pcb_thermal node path= $temp_node, Temperature = $result"
      temp=$(echo $((result/a)))
      if [ $temp -gt 0 ]; then
        hex=$(printf "%04x" $temp)
      else
        hex=$(printf "%04x" $((temp & 0xFFFF)))
      fi

      echo "7E0007130200000000"$hex"AABB"
    else
      log_info "$log_path" "Temperature node file does not exist: $temp_node"
      return
    fi
}

function READ_CHARGE_THERMISTOR_VALUE
{
    RET=$(cat /sys/class/thermal/thermal_zone34/temp)
    result=$(echo "scale=0; $RET / 1000" | bc -l)
    tag_hex=$(printf "%04X" "$result")
    echo "7E0007130300000000"$tag_hex"CRRC"
}


function READ_PA_THERMISTOR_VALUE
{
    # insert your code below
    log_path="thermal.log"

    RET=$(grep -w '^mtktsbtsmdpa$' /sys/class/thermal/thermal_zone*/type -rnIs)
    log_info "$log_path" "pa_thermal content = $RET"

    zone_num=$(echo "$RET" | awk -F'thermal_zone' '{print $2}' | awk -F'/' '{print $1}')
    if [ -z "$zone_num" ]; then
      log_info "$log_path" "Failed to extract zone number from grep result."
      return
    fi

    temp_node="/sys/class/thermal/thermal_zone${zone_num}/temp"
    if [ -f "$temp_node" ]; then
      a=1000
      result=$(cat "$temp_node")
      log_info "$log_path" "pa_thermal node path= $temp_node, Temperature = $result"
      temp=$(echo $((result/a)))
      if [ $temp -gt 0 ]; then
        hex=$(printf "%04x" $temp)
      else
        hex=$(printf "%04x" $((temp & 0xFFFF)))
      fi

      echo "7E0007130400000000"$hex"AABB"
    else
      log_info "$log_path" "Temperature node file does not exist: $temp_node"
      return
    fi
}

function READ_CPU_THERMISTOR_VALUE
{
    # insert your code below
    log_path="thermal.log"

    RET=$(grep -w '^mtktscpu$' /sys/class/thermal/thermal_zone*/type -rnIs)
    log_info "$log_path" "cpu_thermal content = $RET"

    zone_num=$(echo "$RET" | awk -F'thermal_zone' '{print $2}' | awk -F'/' '{print $1}')
    if [ -z "$zone_num" ]; then
      log_info "$log_path" "Failed to extract zone number from grep result."
      return
    fi

    temp_node="/sys/class/thermal/thermal_zone${zone_num}/temp"
    if [ -f "$temp_node" ]; then
      a=1000
      result=$(cat "$temp_node")
      log_info "$log_path" "cpu_thermal node path= $temp_node, Temperature = $result"
      temp=$(echo $((result/a)))
      if [ $temp -gt 0 ]; then
        hex=$(printf "%04x" $temp)
      else
        hex=$(printf "%04x" $((temp & 0xFFFF)))
      fi

      echo "7E0007130600000000"$hex"AABB"
    else
      log_info "$log_path" "Temperature node file does not exist: $temp_node"
      return
    fi
}

##### START_TOUCHSCREEN_TEST  #####
function START_TOUCHSCREEN_TEST
{
    # insert your code below
    #RESULT_FILE="/sdcard/testresult.txt"
    # PASS_WORD="MP TEST PASS"
    FAIL_WORD="FAIL"
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
    input keyevent 26
    fi
    sleep 0.5
    RET=$(cat /proc/touch_info/tp_selftest_result)
    #echo $RET
    sleep 3

    #RET=$(grep "$PASS_WORD" $RESULT_FILE)
    #echo $RET

    result=$(echo $RET | grep "$FAIL_WORD")
    if [[ "$result" != "" ]]; then
    #if [ $RET  "$PASS_WORD" ];then
       echo "7E0006190100000001AABB"  #FAIL
    else
      echo "7E0006190100000000AABB"   #PASS
    fi
}

# The magnetometer self-test returns the original value of the XYZ triax
function MAGNETOMETER_TEST_MAG_SENSE_READINGS_ONLY_READ
{
    $(setprop persist.sys.SENSOR_MSENSOR_RAWDATA "")
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
        input keyevent 26
        sleep 0.5
    fi

    am start -n com.ape.factory/com.ape.factory.testActivities.sensor.MSensorFtm >> /dev/null 2>&1
    SENSOR_MSENSOR_RAWDATA="FAIL"
    for i in $(seq 10 -1 1); do
      rawdata=$(getprop persist.sys.SENSOR_MSENSOR_RAWDATA)
      #echo $rawdata
      if echo "$rawdata" | grep -q "," ;then
        result=$(echo $rawdata | grep -oE '[0-9.-]*')
        x=$(echo $result | awk '{print $1 }')
        y=$(echo $result | awk '{print $2 }')
        z=$(echo $result | awk '{print $3 }')
        #echo $x
        #echo $y
        #echo $z

        hexX=$(printf "%8x" $x)
        hexXX=$(echo $(printf "%08s\n" $hexX))
        #echo "hexX: "$hexX" , "$hexXX
        hexY=$(printf "%8x" $y)
        hexYY=$(echo $(printf "%08s\n" $hexY))
        #echo "hexY: "$hexY" , "$hexYY
        hexZ=$(printf "%8x" $z)
        hexZZ=$(echo $(printf "%08s\n" $hexZ))
        #echo "hexZ: "$hexZ" , "$hexZZ

        echo "7E0012030100000000""${hexXX: -8}""${hexYY: -8}""${hexZZ: -8}""CRRC"
        SENSOR_MSENSOR_RAWDAT="OK"
        break
      fi
      sleep 0.1
    done
    if [ SENSOR_MSENSOR_RAWDAT = "FAIL" ]; then
      echo "7E0006260600000001CRRC"
    fi
}

#### Read id the GYROSCOPE exists
function GYROSCOPE_SELF_TEST
{
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
        input keyevent 26
        sleep 0.5
    fi
    cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE SENSOR --es CQA_TEST_FUNCTION SENSOR_GYROSCOPE_SUPPORT))
    sleep 1
    GYROSCOPE_SUPPORT="FAIL"
    for i in $(seq 6 -1 1)
    do
      if [ "$(getprop persist.sys.gyroscope.support)" -eq 1 ]; then
        echo "7E0006010700000000CRRC"
        GYROSCOPE_SUPPORT="OK"
        break
      fi
      sleep 1
      done
      if [ "$GYROSCOPE_SUPPORT" = "FAIL" ]; then
          echo "7E0006010700000001CRRC"
      fi
}

#### Read if the acceleration exists
function ACCELEROMETER_SELF_TEST
{
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
        input keyevent 26
        sleep 0.5
    fi
    result=$(pm list features | grep "android.hardware.sensor.accelerometer")

    if [[ -n "$result" ]]; then
        echo "7E0006010100000000CRRC"  # 检测到加速度计模块
    else
        echo "7E0006010100000001CRRC"  # 未检测到加速度计模块
    fi
}

##### ACCLEROMETER_EXECUTE_OFFSET_CALIBRATION  #####
function ACCLEROMETER_EXECUTE_OFFSET_CALIBRATION
{
    if [ -z $1 ]; then
        AC_Delay=2
    else
        AC_Delay=$1
    fi

    Log "SENSOR_CAL_ACCEL : AC_Delay = $AC_Delay "

    # start
    setprop vendor.gsensor_calibration.gcalibrate ""
    VALUE=$(getprop vendor.gsensor_calibration.gcalibrate)
    am broadcast -a com.mmi.helper.gsensorrequest --es type "gsensor_calibration" -f 0x01000000 > /dev/null
    RET_START_AM=$?
    if [ $RET_START_AM -ne 0 ];then
        echo "RETURN=FAIL"
        exit 1
    fi

    sleep $AC_Delay
    RET=$(getprop vendor.gsensor_calibration.gcalibrate)
    Log "SENSOR_CAL_ACCEL : RET = $RET "
    if [ "$RET" == "1" ]; then
        Log "SENSOR_CAL_ACCEL : RETURN=PASS"
        echo "7E0006010200000000CRRC"
    else
        Log "SENSOR_CAL_ACCEL : RETURN=FAIL"
        echo "7E0006010200000001CRRC"
    fi
}

##### ACCLEROMETER_READ_OFFSET  #####
function ACCLEROMETER_READ_OFFSET
{
   # insert your code below
   RET=$(cat /mnt/vendor/nvcfg/sensor/acc_cali.json)
   #echo $RET
   result=$(echo $RET | grep -oE '[0-9-]*')
   #echo  $result
   x=$(echo  $result | awk '{ print $1 }')
   #echo  $x
   y=$(echo  $result | awk '{ print $2 }')
   #echo  $y
   z=$(echo  $result | awk '{ print $3 }')
   #echo  $z
   
   hexX=$(printf "%8x" $x)
   hexXX=$(echo $(printf "%08s\n" $hexX))
   #echo ${hexXX:0-0:8}
   hexY=$(printf "%x" $y)
   hexYY=$(echo $(printf "%08s\n" $hexY))
   #echo ${hexYY:0-0:8}
   #echo $(printf "%08s\n" $hexY)
   hexZ=$(printf "%x" $z)
   #echo $(printf "%08s\n" $hexZ)
   hexZZ=$(echo $(printf "%08s\n" $hexZ))
   #echo ${hexZ: -8}
   echo "7E0012010300000000""${hexXX: -8}""${hexYY: -8}""${hexZZ: -8}""CRRC"
}


function GYROSCOPE_EXECUTE_OFFSET_CALIBRATION
{
  # insert your code below
  log_info "gyroscope_test.log" "gyroscope calibrate start ..."
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ $RET -eq 0 ];then
    input keyevent 26
    sleep 0.5
  fi

  am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE SENSOR --es CQA_TEST_FUNCTION SENSOR_CAL_GYRO >> /dev/null 2>&1
  sleep 3
  SENSOR_CAL_GRY="FAIL"
  for i in $(seq 6 -1 1)
  do
    gyroscope_calibrate_prop=$(getprop persist.sys.SENSOR_CAL_GRY)
    log_info "gyroscope_test.log" "getprop persist.sys.SENSOR_CAL_GRY = $gyroscope_calibrate_prop"
    if [ "$gyroscope_calibrate_prop" -eq 1 ];then
      echo "7E0006010500000000CRRC"
      SENSOR_CAL_GRY="OK"
      break
    fi
    sleep 1
  done
  if [ "$SENSOR_CAL_GRY" = "FAIL" ];then
    echo "7E0006010500000001CRRC"
  fi
}

function GYROSCOPE_READ_OFFSET
{
   # insert your code below
   RET=$(cat /mnt/vendor/nvcfg/sensor/gyro_cali.json)
   #echo $RET
   result=$(echo $RET | grep -oE '[0-9-]*')
   #echo  $result
   x=$(echo  $result | awk '{ print $1 }')
   #echo  $x
   y=$(echo  $result | awk '{ print $2 }')
  # echo  $y
   z=$(echo  $result | awk '{ print $3 }')
   #echo  $z
   
   hexX=$(printf "%8x" $x)
   hexXX=$(echo $(printf "%08s\n" $hexX))
   #echo ${hexXX:0-0:8}
   hexY=$(printf "%x" $y)
   hexYY=$(echo $(printf "%08s\n" $hexY))
   #echo ${hexYY:0-0:8}
   #echo $(printf "%08s\n" $hexY)
   hexZ=$(printf "%x" $z)
   #echo $(printf "%08s\n" $hexZ)
   hexZZ=$(echo $(printf "%08s\n" $hexZ))
   #echo ${hexZ: -8}
   echo "7E0012010600000000""${hexXX: -8}""${hexYY: -8}""${hexZZ: -8}""CRRC"
}


function ENABLE_PROXIMITY_SENSOR
{
  log_info "psensor_test.log" "enable_proximity_sensor start .."
  # insert your code below
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ $RET -eq 0 ];then
    input keyevent 26
    sleep 0.5
  fi

  am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.ProxSensorFtm >> /dev/null 2>&1
  ENABLE_PROXIMITY_SENSOR="FAIL"
  for i in $(seq 9 -1 1)
  do
    enable_proximity_sensor=$(getprop persist.sys.PSENSOR_ON)
    log_info "psensor_test.log" "getprop persist.sys.PSENSOR_ON = $enable_proximity_sensor"
    if [ "$enable_proximity_sensor" -eq 1 ];then
      echo "7E0006260100000000CRRC" #PASS
      ENABLE_PROXIMITY_SENSOR="OK"
      break
    fi
    sleep 1
  done

  if [ "$ENABLE_PROXIMITY_SENSOR" = "FAIL" ];then
    echo "7E0006260100000001CRRC" #FAIL
  fi

}


function PROX_CROSSTALK_CALIBRATION
{
    # insert your code below
    log_info "psensor_test.log" "psensor_uncover_cali start ..."
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
      input keyevent 26
      sleep 0.5
    fi

    am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.ProxSensorFtm --es action docaliuncover >> /dev/null 2>&1
    sleep 3

    SENSOR_CAL_PROXIMITY="FAIL"
    for i in $(seq 9 -1 1)
    do
      proximity_cal_prop=$(getprop persist.sys.SENSOR_CAL_PROXIMITY)
      log_info "psensor_test.log" "getprop persist.sys.SENSOR_CAL_PROXIMITY = $proximity_cal_prop"
      if [ "$proximity_cal_prop" -eq 1 ];then
        echo "7E0006260300000000CRRC"
        SENSOR_CAL_PROXIMITY="OK"
        break
      fi
      sleep 1
    done

    if [ $SENSOR_CAL_PROXIMITY = "FAIL" ];then
      echo "7E0006260300000001CRRC"
    fi
}

function PROX_READ_COVER_RAWDATA
{
    # insert your code below
    log_info "psensor_test.log" "prox_read_rawdata start ..."
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
      input keyevent 26
      sleep 0.5
    fi

    am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.ProxSensorFtm --es action getrawdata >> /dev/null 2>&1
    sleep 1.5
    SENSOR_PROXIMITY_RAWDATA="FAIL"
    for i in $(seq 9 -1 1)
    do
      prox_read_rawdata=$(getprop persist.sys.SENSOR_PROXIMITY_RAWDATA)
      log_info "psensor_test.log" "getprop persist.sys.SENSOR_PROXIMITY_RAWDATA = $prox_read_rawdata"
      if [ "$prox_read_rawdata" -ne 0 ];then
	      rawdata=$prox_read_rawdata
	      hexX=$(printf "%8x" $rawdata)
        hexXX=$(echo $(printf "%08s\n" $hexX))
        echo "7E000A260400000000""${hexXX: -8}""CRRC"
        SENSOR_PROXIMITY_RAWDATA="OK"
        break
      fi
      sleep 1
    done

    if [ $SENSOR_PROXIMITY_RAWDATA = "FAIL" ];then
      echo "7E000A260400000001CRRC"
    fi
}



function WRITE_PROX_UNCOVER_RAWDATA
{
    # insert your code below
	echo "7E0006260500000000CRRC"
}

function PROX_WRITE_COVER_RAWDATA
{
    # insert your code below
	echo "7E0006260500000000CRRC"
}

function PROX_EXECUTE_THRESHOLD_CALIBRATION
{
  log_info "psensor_test.log" "psensor_cover cali start ..."
  # insert your code below
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ $RET -eq 0 ];then
    input keyevent 26
    sleep 0.5
  fi

  am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.ProxSensorFtm --es action docalicover >> /dev/null 2>&1
  sleep 2
  SENSOR_CAL_PROXIMITY_2CM="FAIL"
  for i in $(seq 9 -1 1)
  do
    prox_cover_cali_prop=$(getprop persist.sys.SENSOR_CAL_PROXIMITY_2CM)
    log_info "psensor_test.log" "getprop persist.sys.SENSOR_CAL_PROXIMITY_2CM = $prox_cover_cali_prop"
    if [ "$prox_cover_cali_prop" -eq 1 ];then
      echo "7E0006260600000000CRRC" #PASS
      SENSOR_CAL_PROXIMITY_2CM="OK"
      break
    fi
    sleep 1
  done

  if [ $SENSOR_CAL_PROXIMITY_2CM = "FAIL" ];then
    echo "7E0006260600000001CRRC" #FAIL
  fi
}

function PROX_READ_THRESHOLD
{
   # insert your code below
   RET=$(cat /mnt/vendor/nvcfg/sensor/ps_cali.json)
   #echo $RET
   result=$(echo $RET | grep -oE '[0-9-]*')
   #echo  $result
   x=$(echo  $result | awk '{ print $1 }')
   #echo  $x
   y=$(echo  $result | awk '{ print $2 }')

   
   hexX=$(printf "%8x" $x)
   hexXX=$(echo $(printf "%08s\n" $hexX))
   #echo ${hexXX:0-0:8}
   hexY=$(printf "%x" $y)
   hexYY=$(echo $(printf "%08s\n" $hexY))
   #echo ${hexYY:0-0:8}
   #echo $(printf "%08s\n" $hexY)
   echo "7E000E260700000000""${hexXX: -8}""${hexYY: -8}""CRRC"
}

function DISABLE_PROXIMITY_SENSOR
{
    # insert your code below
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
    input keyevent 26
	sleep 0.5
    fi
    am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.ProxSensorFtm --es action finish >> /dev/null 2>&1

    DISABLE_PROXIMITY_SENSOR="FAIL"
    for i in $(seq 9 -1 1)
    do
    if [ $(getprop persist.sys.PSENSOR_ON) -eq 0 ];then
    echo "7E0006260200000000CRRC" #PASS
    DISABLE_PROXIMITY_SENSOR="OK"
    break
    #else
    #echo "wait..."
    fi
    sleep 1
    done
    if [ $DISABLE_PROXIMITY_SENSOR = "FAIL" ];then
    echo "7E0006260200000001CRRC" #FAIL
    #echo "feature $0 not implemented"
    fi
}

function ENABLE_ALS_SENSOR
{
  ENABLE_ALS_SENSOR="FAIL"

  if [ -f /sys/bus/platform/drivers/als_ps/test_alsenable ]; then

    echo 1 > /sys/bus/platform/drivers/als_ps/test_alsenable

    for i in $(seq 6 -1 1); do
      enable_als=$(cat /sys/bus/platform/drivers/als_ps/test_alsenable)
      log_info "LSensor.log" "enable_als= $enable_als"

      if [ -n "$enable_als" ] && [ "$enable_als" -eq 1 ]; then
        echo "7E0006020500000000CRRC" # PASS
        ENABLE_ALS_SENSOR="OK"
        break
      fi

      sleep 0.5
    done
  else
    log_info "LSensor.log" "Node /sys/bus/platform/drivers/als_ps/test_alsenable does not exist"
    echo "7E0006020500000001CRRC" # FAIL
    return
  fi

  if [ "$ENABLE_ALS_SENSOR" == "FAIL" ]; then
    echo "7E0006020500000001CRRC" # FAIL
  fi
}

function LIGHT_SENSOR_READ_FROM_PHONE_3CH
{

  SENSOR_LSENSOR_RAWDATA="FAIL"

  if [ -f /sys/bus/platform/drivers/als_ps/test_alsgetch ]; then
    for i in $(seq 6 -1 1); do
      als_lux_result=$(cat /sys/bus/platform/drivers/als_ps/test_alsgetch)
      log_info "LSensor.log" "read_lux= $als_lux_result"

      if [ -n "$als_lux_result" ]; then
        Lux=$(echo "$als_lux_result" | awk '{print $1}')
        Visible_light=$(echo "$als_lux_result" | awk '{print $2}')
        Infrared_light=$(echo "$als_lux_result" | awk '{print $3}')
        Full_spectrum_value=$(echo "$als_lux_result" | awk '{print $4}')
        final=$(echo "$als_lux_result" | awk '{print $5}')
        log_info "LSensor.log" "Lux= $Lux, Visible_light= $Visible_light, Infrared_light= $Infrared_light, Full_spectrum_value= $Full_spectrum_value"
        if [ "$Lux" -eq 0 ] && [ "$Visible_light" -eq 0 ] && [ "$Infrared_light" -eq 0 ] && [ "$Full_spectrum_value" -eq 0 ]; then
          log_info "LSensor.log" "All data is 0, the $i time"
          continue
        else
          hexX=$(printf "%08x" $Lux)
          hexY=$(printf "%08x" $Visible_light)
          hexZ=$(printf "%08x" $Infrared_light)
          echo "7E0012020100000000""${hexX: -8}""${hexY: -8}""${hexZ: -8}""CRRC"
          SENSOR_LSENSOR_RAWDATA="OK"
          break
        fi
      fi

      sleep 0.5

    done
  else
    log_info "LSensor.log" "Node /sys/bus/platform/drivers/als_ps/test_alsgetch does not exist"
    echo "7E0006260600000001CRRC"
    return
  fi

  if [ "$SENSOR_LSENSOR_RAWDATA" == "FAIL" ]; then
    echo "7E0006260600000001CRRC"
  fi

}

function LIGHT_SENSOR_CALIBRATION_WRITE_TARGET
{
    # insert your code below
    echo "7E0006020200000000CRRC"
}

function LIGHT_SENSOR_CALIBRATION_EXCUTE_CALI
{
    # insert your code below
	SENSOR_LSENSOR_CAL="FAIL"
	log_info "LSensor.log" "als_cali_start...."

  if [ -f /sys/bus/platform/drivers/als_ps/test_alscali ]; then
    echo 1 > /sys/bus/platform/drivers/als_ps/test_alscali
    sleep 2

    for i in $(seq 6 -1 1); do
      als_cali_status=$(cat /sys/bus/platform/drivers/als_ps/test_alscali)
      log_info "LSensor.log" "als_cali_status= $als_cali_status"

      if [ -n "$als_cali_status" ] && [ "$als_cali_status" -eq 1 ] ; then
        echo "7E0006020300000000CRRC";
        SENSOR_LSENSOR_CAL="OK"
        break
      fi

      sleep 0.5
    done
  else
    log_info "LSensor.log" "Node /sys/bus/platform/drivers/als_ps/test_alscali does not exist"
    echo "7E0006020300000001CRRC" # FAIL
    return
  fi

  if [ "$SENSOR_LSENSOR_CAL" == "FAIL" ]; then
     echo "7E0006020300000001CRRC"
  fi
}


function LIGHT_SENSOR_CALIBRATION_VERIFY_COEFFICIENTS
{
   # insert your code below
   RET=$(cat /mnt/vendor/nvcfg/sensor/als_cali.json)
   log_info "LSensor.log" "als_cali_result= $RET"
   #echo $RET
   result=$(echo $RET | grep -oE '[0-9-]*')
   #echo  $result
   x=$(echo  $result | awk '{ print $1 }')
   
   hexX=$(printf "%8x" $x)
   hexXX=$(echo $(printf "%08s\n" $hexX))
   #echo ${hexXX:0-0:8}
   echo "7E000E260700000000""${hexXX: -8}""CRRC"
}

function DISABLE_ALS_SENSOR
{

  if [ -f /sys/bus/platform/drivers/als_ps/test_alsenable ]; then
    disable_als=$(cat /sys/bus/platform/drivers/als_ps/test_alsenable)
    log_info "LSensor.log" "disable_als==> $disable_als"
    echo "7E0006020600000000CRRC" #PASS
  else
    log_info "LSensor.log" "Node /sys/bus/platform/drivers/als_ps/test_alsenable does not exist"
    echo "7E0006020600000001CRRC" # FAIL
    return
  fi
}

function FPS_ON_SENSOR
{
    local retry_count=0
    local max_retries=5

    while [ $retry_count -lt $max_retries ]; do
        RET_FPC=$(getprop ro.vendor.fp.driver 2>/dev/null)
        if [ -n "$RET_FPC" ]; then  # 明确判断非空
            echo "7E0006020600000011CRRC"
            return 0  # 成功，退出函数
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                sleep 0.5  # 在最后一次尝试前不 sleep
            fi
        fi
    done

    # 如果5次尝试都失败
    echo "No fingerprint scanner detected after $max_retries attempts."
    return 1  # 失败，返回非0状态码
}

function ENABLE_REAR_LIGHT_SENSOR
{
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ "$RET" -eq 0 ]; then
    input keyevent 26
    sleep 0.5
  fi

  am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.FtmRearLight --activity-clear-top  >> /dev/null 2>&1
  log_info "rals_test.log" "enable_rals start ==> "

  ENABLE_RLS_SENSOR="FAIL"
  sleep 0.3
  for i in $(seq 9 -1 1)
  do
    if [ "$(getprop persist.sys.RLSENSOR_ON)" -eq 1 ]; then
      echo "7E00192300000000AABB"
      ENABLE_RLS_SENSOR="OK"
      break
    fi
    sleep 1
    done
    if [ "$ENABLE_RLS_SENSOR" = "FAIL" ]; then
      echo "7E00192300000001AABB"
    fi
}

function REAR_LIGHT_SENSOR_READ_FORM_PHONE_LUX
{
  SENSOR_RLSENSOR_LUX_3CH="FAIL"
  Machine_Model=$(getprop ro.boot.hwsku)
  log_info "rals_lux.log" "Machine_Model = $Machine_Model"

  echo 1 > /sys/bus/platform/drivers/als_ps/test_rear_alsenable
  als_enable=$(cat /sys/bus/platform/drivers/als_ps/test_rear_alsenable)

  if [ "$als_enable" -eq 1 ]; then
    if [ -f /sys/bus/platform/drivers/als_ps/test_rear_alsgetch ]; then
      for i in $(seq 6 -1 1); do
        rals_lux_result=$(cat /sys/bus/platform/drivers/als_ps/test_rear_alsgetch)
        log_info "rals_lux.log" "rals_read_lux = $rals_lux_result"

        if [ -n "$rals_lux_result" ]; then
            lux=$(echo "$rals_lux_result" | awk '{print $1}')
            visible_light=$(echo "$rals_lux_result" | awk '{print $2}')
            infrared_light=$(echo "$rals_lux_result" | awk '{print $3}')
            full_spectrum_value=$(echo "$rals_lux_result" | awk '{print $4}')
            log_info "rals_lux.log" "lux = $lux, visible_light = $visible_light, infrared_light = $infrared_light, full_spectrum_value = $full_spectrum_value"

            if [ "$lux" -eq 0 ] && [ "$visible_light" -eq 0 ] && [ "infrared_light" -eq 0 ] && [ "$full_spectrum_value" -eq 0 ]; then
              log_info "rals_lux.log" "All data is 0, the $i time"
              continue

            else
              hexX=$(printf "%08x" $lux)
              hexY=$(printf "%08x" $visible_light)
              hexZ=$(printf "%08x" $infrared_light)
              hexW=$(printf "%08x" $full_spectrum_value)

              echo "7E00192400000000""${hexX: -8}""${hexY: -8}""${hexZ: -8}""${hexW: -8}""AABB"  
              SENSOR_RLSENSOR_LUX_3CH="OK"
              break

            fi
        fi

        sleep 0.5

        done
    else
      log_info "rals_lux.log" "Node /sys/bus/platform/drivers/als_ps/test_rear_alsgetch does not exist"
      echo "7E00192400000001AABB"
      return
    fi
  else
    echo "7E00192400000001AABB"
  fi

  if [ "$SENSOR_RLSENSOR_LUX_3CH" == "FAIL" ]; then
    echo "7E00192400000001AABB"
  fi
}

function REAR_LIGHT_SENSOR_CALIBRATION_WRITE_TARGET
{
  echo "7E00192700000000AABB"
}

function REAR_LIGHT_EXECUTE_OFFSET_CALIBRATION
{
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
      input keyevent 26
      sleep 0.5
    fi
    am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.FtmRearLight --es action doCali >> /dev/null 2>&1
    log_info "rals_test.log" "rals_caliration start ==> "
    sleep 2
    SENSOR_CALI_REAR_LIGHT="FAIL"
    for i in $(seq 6 -1 1)
    do
      rals_caliration_prop=$(getprop persist.sys.SENSOR_CALI_REAR_LIGHT)
      log_info "rals_test.log" "getprop persist.sys.SENSOR_CALI_REAR_LIGHT = $rals_caliration_prop"
      if [ "$rals_caliration_prop" -eq 1 ]; then
        echo "7E00192500000001AABB"
        SENSOR_CALI_REAR_LIGHT="OK"
        break
      fi
      sleep 1
      done
      if [ $SENSOR_CALI_REAR_LIGHT = "FAIL" ]; then
        echo "7E00192500000000AABB"
      fi
}

function REAR_LIGHT_READ_OFFSET
{
  if [ -f /mnt/vendor/nvcfg/sensor/rearals_cali.json ]; then
    RET=$(cat /mnt/vendor/nvcfg/sensor/rearals_cali.json)
    result=$(echo $RET | grep -oE '[0-9]*')
    x=$(echo $result | awk '{ print $1 }')
    hexX=$(printf "%8x" $x)
    hexXX=$(echo $(printf "%08s\n" $hexX))
    echo "7E00192600000000""${hexXX: -8}""AABB"
  else
    echo "7E00192600000000AABB"
  fi
}

function DISABLE_REAR_LIGHT_SENSOR
{
    # insert your code below
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
      input keyevent 26
      sleep 0.5
    fi
    am start -n com.mediatek.sensorhub.ui/com.mediatek.sensorhub.sensor.alspsex.FtmRearLight --es action finish >> /dev/null 2>&1
    log_info "rals_test.log" "disable_rls start ==> "

    DISABLE_RLS_SENSOR="FAIL"
    for i in $(seq 9 -1 1)
    do
      if [ "$(getprop persist.sys.RLSENSOR_ON)" -eq 0 ];then
      echo "7E00192800000000AABB" #PASS
      DISABLE_RLS_SENSOR="OK"
      break
      fi
    sleep 1
    done
    if [ "$DISABLE_RLS_SENSOR" = "FAIL" ];then
      echo "7E00192800000001AABB" #FAIL
    fi
}

function FLICKER_SENSOR_READ_OFFSET
{
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
      input keyevent 26
      sleep 0.5
    fi

    am start -n com.ape.factory/com.ape.factory.testActivities.sensor.FlickerSensor --es action getData >> /dev/null 2>&1
    sleep 3
    SENSOR_DATA_FLICKER="FAIL"
    result=$(getprop persist.sys.flicker.data)

    for i in $(seq 6 -1 1)
    do
        if [ -n "$result" ] && [ "$result" -ne 0 ] 2>/dev/null; then  # Check if result is not empty and not 0
            hex=$(printf "%04x" "$result")
            echo "7E00192900000000${hex}AABB"
            SENSOR_DATA_FLICKER="OK"
            break
        fi
        sleep 0.5
        result=$(getprop persist.sys.flicker.data)  # Reread property values
    done

    if [ "$SENSOR_DATA_FLICKER" = "FAIL" ]; then
        echo "7E00192900000000AABB"
    fi
}

function WHETHER_IT_HAS_NFC
{
    hwinfo=$(cat /sys/devices/platform/product-device-info/info_nfc | awk '{$1=$1; print}')
    Log "WHETHER_IT_HAS_NFC  : hwinfo = $hwinfo"
    if [ "$hwinfo" == "THN31FGB1A" ]; then
        echo "7E0006120600000001AABB"
    else
        echo "7E0006120600000000AABB"
    fi
}

function ENABLE_NFC_TEST_MODE
{
    # insert your code below
    cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE NFC --es CQA_TEST_FUNCTION NFCTN))
    NFCTN="FAIL"
    for i in $(seq 6 -1 1)
    do
    if [ $(getprop persist.sys.NFCTN) -eq 1 ];then
    echo "7E0006120300000001AABB"
    NFCTN="OK"
    break
    #else
    #echo "wait..."
    fi
    sleep 1
    done
    if [ $NFCTN = "FAIL" ];then
    echo "7E0006120300000000AABB"
    # echo "feature $0 not implemented"
    fi
}

function NFC_FIRMWARE_CHECK
{
	output=$(tdt -n /dev/tms_nfc -b -f -lEE --chip_info=nfcc 2>&1)

	if echo "$output" | grep -q "FW version: D2.12.2"; then
		echo "7E0006120300000000AABB"  # 版本匹配成功
	else
		echo "7E0006120300000001AABB"  # 版本匹配失败
	fi

}

function START_NFC_SWP_SELF_TEST_BOARD
{
    result=$(tdt -n /dev/tms_nfc -b -f -lEE --swp_test=uicc1 2>&1)

	# 判断结果并输出对应值
	if echo "$result" | grep -q "swp link test OK"; then
		echo "7E0006120400000000AABB"  # 测试成功
	else
		echo "7E0006120400000001AABB"  # 测试失败
	fi
}

function NFC_ANTENNA_SELFTEST
{
    # insert your code below
    echo "feature $0 not implemented"
    echo "1"
}

function READ_LCD_VENDOR_INFO
{
    # insert your code below
    RET=$(cat /sys/devices/platform/product-device-info/info_lcd)
    log_info "vendor_info.log" "$RET"
    if [ $RET == "TXD-ILI79505-VDO" ]; then
      echo "7E00070D010000000001CRRC"
    elif [ $RET == "TM-ICNL9916X-VDO" ]; then
      echo "7E00070D010000000002CRRC"
    elif [ $RET == "CSOT-NT36528A-VDO" ]; then
      echo "7E00070D010000000003CRRC"
    fi
}

function READ_NVM_SIZE
{
    # insert your code below
    RET=$(cat /sys/block/mmcblk0/size)
    #echo $RET
    hex=$(printf "%x" $((RET/2)))
    #echo $hex
    echo "7E000A0A0200000000"$hex"CRRC"
}


function READ_SDCARD_SIZE
{
   # insert your code below
   strA="media_rw"

   RET=$(df | grep "media_rw")
   #echo $RET

   if [ "$RET" =  "" ];then
   echo "7E00062102000000000AABB"
   else
   size=$(echo $RET | awk '{ print $2 }')
   hex=$(printf "%08x" $size)
   echo "7E000621020"$hex"ABBA"
   fi
}



function GET_RAM_LPDDR_SIZE
{
    # insert your code below
    a=1024

    RET=$(getprop ro.boot.mem | cut -d'_' -f3)
    hex=$(printf "%x" $((RET*a)))

    echo "7E0006220100000000"$hex"AABB"
}


function READ_SW_VERSION
{
    # insert your code below
    # echo $(getprop ro.build.description)
    #  echo "feature $0 not implemented"
    RET=$(getprop ro.build.description)
    result=""
    for i in $(seq 0 $((${#RET}-1))); do
       char="${RET:$i:1}"
       ascii=$(printf "%d" "'$char")
       decimal=$(printf "%d" "$ascii")  # Concatenate the ASCII code of each character into the result string
       result+=$(printf "%x" $decimal)  # Convert decimal to hexadecimal
    done

    echo $result
}

function GET_MMC_ABSENT_STATUS
{
    # insert your code below
    #RET=$(cat /sys/devices/platform/11240000.mmc/mmc_host/mmc1/sd_state)
    if [ -f /sys/devices/platform/11240000.mmc/mmc_host/mmc1/sd_state ]; then
      RET=$(cat /sys/devices/platform/11240000.mmc/mmc_host/mmc1/sd_state)
      if [ $RET -eq 1 ]; then
        echo "7E000721010000000001AABB"
      else
        echo "7E000721010000000000AABB"
      fi
    else
      echo "7E000721010000000000AABB"
    fi
}

function SWITCH_POWER_SOURCE_TO_BATTERY
{
    # insert your code below
    echo 1 > /sys/devices/platform/charger/enable_hiz
    echo "7E0006090100000000AABB"
}

function SWITCH_POWER_SOURCE_TO_CHARGE
{
    # insert your code below
    echo 0 > /sys/devices/platform/charger/enable_hiz
    echo "7E0007090200000000AABB"
}

function SWITCH_CHARGER_ENABLE
{
  echo 1 > /sys/devices/platform/charger/factory_enable_switch_charger
  RET=$(cat /sys/devices/platform/charger/factory_enable_switch_charger)
  if [ "$RET" -eq 1 ]; then
    echo "7E0007090300000000AABB"
  else
    echo "7E0007090300000001AABB"
  fi
}

function SWITCH_CHARGER_DISABLE
{
  echo 0 > /sys/devices/platform/charger/factory_enable_switch_charger
  RET=$(cat /sys/devices/platform/charger/factory_enable_switch_charger)
  if [ "$RET" -eq 0 ]; then
    echo "7E0007090400000000AABB"
  else
    echo "7E0007090400000001AABB"
  fi
}

function CHARGER_PUMP_ENABLE
{
  echo 1 > /sys/devices/platform/charger/factory_enable_pump_charger
  RET=$(cat /sys/devices/platform/charger/factory_enable_pump_charger)
  if [ "$RET" -eq 1 ]; then
    echo "7E0007090500000000AABB"
  else
    echo "7E0007090500000001AABB"
  fi
}

function CHARGER_PUMP_DISABLE
{
  echo 0 > /sys/devices/platform/charger/factory_enable_pump_charger
  RET=$(cat /sys/devices/platform/charger/factory_enable_pump_charger)
  if [ "$RET" -eq 0 ]; then
    echo "7E0007090600000000AABB"
  else
    echo "7E0007090600000001AABB"
  fi
}

function QUICK_STANDBY
{
    # insert your code below
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -gt 0 ];then
    input keyevent 26
    fi

    echo "7E0006180300000000AABB"
}

#### Shutdown command
function POWER_OFF
{
    reboot -p
}

function READ_VBUS_VOLTAGE
{
    # insert your code below
    RET=$(cat /sys/devices/platform/charger/ADC_Charger_Voltage)
    hex=$(printf "%x" $RET)

    echo "7E000618030000"$hex"AABB"
}


function DISABLE_BATTERY_FET
{
    # insert your code below
    # echo "not support"
    echo 0 > /sys/devices/platform/charger/enable_charger
    RET=$(cat /sys/devices/platform/charger/enable_charger)
    if [ $RET -eq 0 ]; then
      echo "7E0006090900000000AABB"   # PASS
    else
      echo "7E0006090900000001AABB"   #FAIL
    fi
}

function ENABLE_PATH_FET_TO_BATTERY
{
    # insert your code below
    # echo "not support"
    echo 1 > /sys/devices/platform/charger/enable_charger
    RET=$(cat /sys/devices/platform/charger/enable_charger)
    if [ $RET -eq 1 ]; then
      echo "7E0007090B00000000AABB"   #PASS
    else
      echo "7E0007090B00000001AABB"   #FAIL
    fi
}

##### READ_VBAT_VOLTAGE  #####

function READ_VBAT_VOLTAGE
{
    # insert your code below
    RET=$(cat /sys/class/power_supply/battery/voltage_now)
    hex=$(printf "%x" $RET)

    echo "7E000A09070000000000"$hex"AABB"
}

function SET_INPUT_PATH_TO_3_AMPS
{
    # insert your code below
    echo 3000000 > /sys/devices/platform/charger/factory_charge_upper

    echo "7E0007090A00000000AABB"
}

function SET_OUTPUT_PATH_TO_1_AMPS
{
    # insert your code below
    echo 1000000 > /sys/devices/platform/charger/factory_charging_current

    echo "7E0007090B00000000AABB"
}

function READ_DCP_STATUS
{
  RET=$(cat /sys/devices/platform/charger/chr_type)
  result=""
  if [ $RET -eq 4 ]; then
    result="SDP"
  elif [ $RET -eq 5 ]; then
    result="DCP"
  elif [ $RET -eq 6 ]; then
    result="CDP"
  else
    echo "7E0002090F00000000000001CRRC"  # unknow
    return
  fi

  charType=""
  for i in $(seq 0 $((${#result}-1))); do
    char="${result:$i:1}"
    ascii=$(printf "%d" "'$char")
    decimal=$(printf "%d" "$ascii")
    charType+=$(printf "%x" $decimal)
  done
  echo "7E0002090F00000000"$charType"AABB"
}

# Detect SIM1 status
function VERIFY_SIM1_REMOVE_STATUS
{
    RET=$(getprop gsm.sim.state)
    sleep 0.5
    SIM1=$(echo $RET | cut -d',' -f1)
    if [ "$SIM1" == "ABSENT" ]; then
    echo "7E000727010000000000CRRC"
    else
    echo "7E000727010000000001CRRC"
    fi
}

# Detect SIM2 status
function VERIFY_SIM2_REMOVE_STATUS
{
    RET=$(getprop gsm.sim.state)
    sleep 0.5
    SIM2=$(echo $RET | cut -d',' -f2)
    if [ "$SIM2" == "ABSENT" ]; then
    echo "7E000727010000000000CRRC"
    else
    echo "7E000727010000000001CRRC"
    fi
}

function GET_SIM_ABSENT_STATUS
{
    # insert your code below
    RET=$(cat /sys/devices/platform/product-device-info/info_cardslot)
    result=$(echo "$RET" | sed 's/ //g')
    if [ "$result" == "insert" ]; then
    echo "7E000727030000000001CRRC"
    else
    echo "7E000727030000000000CRRC"
    fi
}

function ENABLE_WLAN
{
    # insert your code below
    svc wifi enable
    echo "7E0006240100000000AABB"
}

function DISABLE_WLAN
{
    # insert your code below
    svc wifi disable
    echo "7E0006240200000000AABB"
}

function ENABLE_BT
{
    # insert your code below
    svc bluetooth enable
    echo "7E0002070100000000AABB"
}

function DISABLE_BT
{
    # insert your code below
    svc bluetooth disable
    echo "7E0002070200000000AABB"
}

function ENABLE_NFC
{
    # insert your code below
    svc nfc enable
    echo "7E0006120100000000AABB"
}

function DISABLE_NFC
{
    # insert your code below
    svc nfc disable
    echo "7E0006120200000000AABB"
}


function CAP_SENSOR_DETECT
{
    # insert your code below
    if [ -f /sys/class/sar/ic_check ];then
      RET=$(cat /sys/class/sar/ic_check)
      if [ "$RET" == "0x00" ]; then
        echo "7E0006080100000000CRRC"
      else
        echo "7E0006080100000011CRRC"
      fi
    else
      echo "7E0006080100000011CRRC"
    fi
}

function CAP_SENSOR_ENABLE
{
    # insert your code below
    if [ -f /sys/class/sar/enable ];then
      echo 1 > /sys/class/sar/enable
      RET=$(cat /sys/class/sar/enable)
      if [ "$RET" == "0x00" ]; then
        echo "7E0006080200000000CRRC"
      else
        echo "7E0006080200000011CRRC"
      fi
    else
    echo "7E0006080200000011CRRC"
    fi
}

function CAP_SENSOR_EXECUTE_SELF_CALIBRATION
{
    # insert your code below
    if [ -f /sys/class/sar/calibrate ];then
    echo 99 > /sys/class/sar/calibrate
    echo "7E0006080400000000CRRC"
    else
    echo "7E0006080400000011CRRC"
    fi
}

function CAP_SENSOR_READ_DIFF_VALUE
{
    # insert your code below
    if [ -f /sys/class/sar/diff ];then
    RET=$(cat /sys/class/sar/diff)
    size=$(echo "$RET" | awk -F'=' '{ print $2 }')
    log_info "sar_diff.log" "RET= $RET \n result= $size"

    result=(${size// /})
    diffret=""

    for v in ${result[@]};do
        #echo "list: $v"
        hexX=$(printf "%8x" $v)
        hexXX=$(echo $(printf "%08s\n" $hexX))
        v=$(echo ${hexXX: -8})
        diffret=$diffret$v
        #echo "diffret= $diffret"
        #echo $v
    done
    #echo "${result[@]}"
    #echo $diffret
    echo "7E001E080700000000"$diffret"00000000CRRC"
    else
    echo "7E0006080700000011CRRC"
    fi
}

function CAP_SENSOR_CHECK_CALI_VALUE_BOARD
{
  logfile="sar_offset.log"
  if [ -f /sys/class/sar/offset ]; then
    RET=$(cat /sys/class/sar/offset)
    log_info "$logfile" "sar_result= $RET"
    if [ -f /sys/bus/i2c/drivers/awinic_sar/3-0012/mode_operation ]; then
      size=$(echo "$RET" | awk -F': ' '{print $2}' | sed 's/[^0-9.]//g' | cut -c1-6)
      log_info "$logfile" "sar1= $size"
      result=(${size// /})
    elif [ -d /sys/bus/i2c/drivers/hx9031as/3-0028 ]; then
      size=$(echo "$RET" | awk -F'[=pF ]+' '{for(i=2; i<=NF; i+=2) print $i}')
      log_info "$logfile" "sar_2= $size"
      result=(${size// /})
    else
      log_info "$log_info" "sar_offset_test_fail"
      echo "7E0006080500000011CRRC"
      return
    fi

    diffret=""
    a=1000
    for v in "${result[@]}"; do
      v=$(echo "$v" | awk '{printf "%.3f", $0}')
      v=$(echo "$v $a" | awk '{printf("%.0f", $1 * $2)}')

      log_info "$logfile" "sar_list: $v"
      hexX=$(printf "%8x" "$v")
      hexXX=$(printf "%08s\n" "$hexX" | tr ' ' '0')
      v=$(echo "${hexXX: -8}")
      diffret="$diffret$v"
      #echo "$diffret"
    done

    echo "7E0006080500000000${diffret}00000000CRRC"
  else
    echo "7E0006080500000011CRRC"
  fi
}


function CAP_SENSOR_CHECK_CALI_VALUE_PHONE
{
    # insert your code below
    if [ -f /sys/bus/i2c/drivers/awinic_sar/3-0012/offset ];then
    size=$(cat /sys/bus/i2c/drivers/awinic_sar/3-0012/offset | awk '{ print $3 }')
    #echo $size

    result=(${size// /})
    diffret=""
    a=1000
    for v in ${result[@]};do
        result="$v"| awk '{printf "%.3f", $0}'
        v=$(echo $v $a | awk '{printf("%.0f",$1*$2)}')

        #echo $v
        hexX=$(printf "%8x" $v)
        hexXX=$(echo $(printf "%08s\n" $hexX))
        v=$(echo ${hexXX: -8})
        diffret=$diffret$v
        #echo $v
    done
    #echo "${result[@]}"
    #echo $diffret
    echo "7E0006080500000000"$diffret"CRRC"
    else
    echo "7E0006080500000011CRRC"
    fi
}

function CAP_SENSOR_DISABLE
{
    # insert your code below
    if [ -f /sys/class/sar/enable ];then
      echo 0 > /sys/class/sar/enable
      echo "7E0006080300000000CRRC"
    else
      echo "7E0006080300000011CRRC"
    fi
}


function TNWRITE_TEST_FLAG
{
    # insert your code below
    log_info "Test_flag.log" "write_test_flag start ..."
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
    input keyevent 26
    sleep 0.5
    fi

    tag=$1
    #echo $tag
    bt="01000000000000000000000000000000"
    L2="01000000000000001000000000000000"
    ar="01000000000000001100000000000000"
   cam="01000000000000001110000000000000"

    log_info "Test_flag.log" "write_test_flag this = $tag"

    if [ $tag = $bt ];then
        cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE  TEST_FLAG_OP --es CQA_TEST_FUNCTION WRITETAGBT))
        sleep 1
        WRITETAGBT="FAIL"
        for i in $(seq 6 -1 1)
        do
        if [ $(getprop persist.sys.WRITETAGBT) -eq 1 ];then
        echo "7E0046180300000000AABB"
        WRITETAGBT="OK"
        break
        #else
        #echo "wait..."
        fi
        sleep 1
        done
        if [ $WRITETAGBT = "FAIL" ];then
        echo "7E0046180300000001AABB"
        # echo "feature $0 not implemented"
        fi
    fi

    if [ $tag = $L2 ];then
        cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE  TEST_FLAG_OP --es CQA_TEST_FUNCTION WRITETAGL2vision))
        sleep 1
        WRITETAGL2vision="FAIL"
        for i in $(seq 6 -1 1)
        do
        if [ $(getprop persist.sys.WRITETAGL2vision) -eq 1 ];then
        echo "7E0046180300000000AABB"
        WRITETAGL2vision="OK"
        break
        #else
        #echo "wait..."
        fi
        sleep 1
        done
        if [ $WRITETAGL2vision = "FAIL" ];then
        echo "7E0046180300000001AABB"
        # echo "feature $0 not implemented"
        fi
    fi

    if [ $tag = $ar ];then
    #echo testar
        cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE  TEST_FLAG_OP --es CQA_TEST_FUNCTION WRITETAGAR))
        sleep 1
        WRITETAGAR="FAIL"
        for i in $(seq 6 -1 1)
        do
        if [ $(getprop persist.sys.WRITETAGAR) -eq 1 ];then
        echo "7E0046180300000000AABB"
        WRITETAGAR="OK"
        break
        #else
        #echo "wait..."
        fi
        sleep 1
        done
        if [ $WRITETAGAR = "FAIL" ];then
        echo "7E0046180300000001AABB"
        # echo "feature $0 not implemented"
        fi
    fi

    if [ $tag = $cam ];then
        cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE  TEST_FLAG_OP --es CQA_TEST_FUNCTION WRITETAGCAM))
        sleep 1
        WRITETAGBT="FAIL"
        for i in $(seq 6 -1 1)
        do
        if [ $(getprop persist.sys.WRITETAGCAM) -eq 1 ];then
        echo "7E0046180300000000AABB"
        WRITETAGBT="OK"
        break
        #else
        #echo "wait..."
        fi
        sleep 1
        done
        if [ $WRITETAGBT = "FAIL" ];then
        echo "7E0046180300000001AABB"
        # echo "feature $0 not implemented"
        fi
    fi

}

function TNREAD_TEST_FLAG
{
    log_info "Test_flag.log" "READ_TEST_FLAG..."
    # insert your code below
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ];then
    input keyevent 26
    sleep 0.5
    fi

    cqatest=$(echo $(am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE  TEST_FLAG_OP --es CQA_TEST_FUNCTION READTAG))
    sleep 1

    bt=$(getprop persist.sys.READTAGBT)
    l2=$(getprop persist.sys.READTAGL2vision)
    ar=$(getprop persist.sys.READTAGAR)
    cam=$(getprop persist.sys.READTAGCAM)

    readtag=$(getprop persist.sys.READTAG)

    log_info "Test_flag.log" "READ_TEST_FLAG flag result: BT= $bt; L2= $l2; AR= $ar; Cam=$cam; ReadTag= $readtag"

    if [ $readtag -ne 2 ];then
        if [ $bt -eq 1 ];then
        bt="100000000000000"
        else
        bt="000000000000000"
        fi

        if [ $l2 -eq 1 ];then
        l2="1"
        else
        l2="0"
        fi

        if [ $ar -eq 1 ];then
        ar="1"
        else
        ar="0"
        fi

        if [ $cam -eq 1 ];then
        cam="10000000000000"
        else
        cam="00000000000000"
        fi

        log_info "Test_flag.log" "read_test_flag output: BT= $bt; L2=$l2; AR=$ar; Caam=$cam"
        echo "7E00461802000000000"$bt$l2$ar$cam"AABB"
    else
        echo "7E004618020000000100000000000000000000000000000000AABB"
    fi
}

function SET_HW_MANUFACTUREDATE
{
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
        input keyevent 26
        sleep 0.5
    fi

    tag=$1
    path="/mnt/persist/misc/HW_MANUFACTUREDATE"

    #  Check if the file or directory exists and create it if it does not exist
    if [ ! -f "$path" ] || [ ! -s "$path" ]; then
        touch "$path"
    fi

    # Write tag to the file
    echo "$tag" > "$path"
    sleep 0.5

    result=$(cat $path)
    if [ $result -eq $tag ]; then
        echo "7E0009171800000000AABB"  #PASS
    else
        echo "7E0009171800000001AABB"  #FAIL
    fi
}

function GET_HW_MANUFACTUREDATE
{
    RET=$(cat /sys/class/leds/lcd-backlight/brightness)
    if [ $RET -eq 0 ]; then
        input keyevent 26
        sleep 0.5
    fi

    file="/mnt/persist/misc/HW_MANUFACTUREDATE"
    if [ ! -f "$file" ]; then
        echo "7E0009171700000001000AABB"
    elif [ ! -s "$file" ]; then
        echo "7E0009171700000001000AABB"
    else
        result=$(cat $file)
        hex=$(printf "%x" $result)
        echo "7E0009171700000000"$hex"AABB"
    fi
}

###################################################################
# Function:    FM_ON                                              #
# Description: This function should enable the FM module          #
#              and sync default frequency of 97.5Mhz              #
# Note:        no splash screen or prompt box should be required  #
# Inputs:      N/A                                                #
# Output:      status:     OK/FAIL                               #
###################################################################
function FM_ON
{
    am startservice -n com.ontim.cit/.service.CitFmRadioService --es CQA_FM_On "yes"
    RET1=$?
    if [ $RET1 -ne 0 ];then
        Log "FM_On : RETURN=FAIL"
        echo "RETURN=FAIL"
    else
        Log "FM_On : RETURN=PASS"
        echo "RETURN=PASS"
    fi
}

###################################################################
# Function:    FM_TUNE                                            #
# Description: This function should sync a desired freq passed as #
#              input on this function call                        #
# Inputs:      Desired FM freq                                    #
# Output:      status:     OK/FAIL                               #
###################################################################
function FM_TUNE
{
    # takes argument
    # insert your code below
    am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE FM --es CQA_TEST_FUNCTION FM_TUNE --es CQA_TEST_PARAMS $1

    #am broadcast -a com.ape.factory.FM_GETRSSI --es FMtune $1
    sleep 1
    FM_TUNE="FAIL"
    for i in $(seq 3 -1 1)
    do
    if [ $(getprop persist.sys.FM_TuneState) -eq 1 ];then
    echo "parameter received: $1"
    echo "RETURN=PASS"
    FM_TUNE="OK"
    break
    #else
    #echo "wait..."
    fi
    sleep 1
    done
    if [ $FM_TUNE = "FAIL" ];then
    echo "parameter received: $1"
    echo "RETURN=FAIL"
    #echo "feature $0 not implemented"
    fi
}

###################################################################
# Function:    FM_GETRSSI                                         #
# Description: This function should return the FM RSSI            #
# Note:        The RSSI should be updated periodically or on      #
#              every call of function FM_GETRSSI                  #
# Inputs:      N/A                                                #
# Output:      OK,[FM rssi]/FAIL                                 #
###################################################################
function FM_GETRSSI
{
    # insert your code below
    am broadcast -a com.ape.factory.FM_GETRSSI
    sleep 1
    FM_GETRSSI="FAIL"
    for i in $(seq 15 -1 1)
    do
    if [ $(getprop persist.sys.RSSI_VALUE) -ne 0 ];then
    echo "RETURN=PASS,[$(getprop persist.sys.RSSI_VALUE)]"
    FM_GETRSSI="OK"
    break
    #else
    #echo "wait..."
    fi
    sleep 1
    done
    if [ $FM_GETRSSI = "FAIL" ];then
    echo "RETURN=FAIL"
    #echo "feature $0 not implemented"
    fi
}

function GET_RSSI
{
    RET=$(cat data/data/com.ontim.cit/files/rssi.txt)
    if [ $RET ]; then
       Log "FM_GetRSSI : RETURN=$RET PASS"
       echo "$RET"
    else
       Log "FM_GetRSSI : RETURN=-999 FAIL"
       echo "-999"
    fi
}

###################################################################
# Function:    FM_OFF                                             #
# Description: This function should disable the FM module         #
# Note:        terminate any FM process                           #
# Inputs:      N/A                                                #
# Output:      status:     OK/FAIL                               #
###################################################################
function FM_OFF
{
    am startservice -n com.ontim.cit/.service.CitFmRadioService --es CQA_FM_Off "yes"
    RET1=$?
    if [ $RET1 -ne 0 ];then
        Log "FM_Off : RETURN=FAIL"
        echo "RETURN=FAIL"
    else
        Log "FM_Off : RETURN=PASS"
        echo "RETURN=PASS"
    fi
}

###################################################################
# Function:    FM_CHECK                                           #
# Description: This function should check FM (SOC or not.)        #
# Inputs:      N/A                                                #
# Output:      status:     OK/FAIL                               #
###################################################################
function FM_CHECK
{
    sleep 1
    FM_CHECK="FAIL"
    for i in $(seq 6 -1 1)
    do
    if [ $(getprop persist.sys.FTMFM_state) -eq 1 ];then
    echo "RETURN=PASS"
    FM_CHECK="OK"
    break
    #else
    #echo "wait..."
    fi
    sleep 1
    done
    if [ $FM_CHECK = "FAIL" ];then
    echo "RETURN=FAIL"
    fi
}

function SET_FM_FRE
{
    am startservice -n com.ontim.cit/.service.CitFmRadioService --ef CQA_freq $1
    RET1=$?
    if [ $RET1 -ne 0 ];then
        Log "FM_Tune : RETURN=FAIL"
       echo "RETURN=FAIL"
    else
        Log "FM_Tune : RETURN=PASS"
       echo "RETURN=PASS"
    fi
}

function AUDIO_BYPASS_AGLO
{
    AudioSetParam SET_BypassProcess=1
    sleep 0.2
    echo "7E000C0100000000CRRC"
}

function AUDIO_BYPASS_CLOSE
{
    AudioSetParam SET_BypassProcess=0
    sleep 0.2
    echo "7E000C0100000001CRRC"
}

####################################################################
# Function:    AIRPLANE_MODE_ON                                    #
# Description: This function is used to turn on the airplane mode  #
# Inputs:      N/A                                                 #
# Output:      status:     OK/FAIL                                 #
####################################################################
function AIRPLANE_MODE_ON
{
    cmd connectivity airplane-mode enable
    echo "7E00191700000001AABB"  #PASS
}

####################################################################
# Function:    AIRPLANE_MODE_OFF                                   #
# Description: This function is used to turn off the airplane mode #
# Inputs:      N/A                                                 #
# Output:      status:     OK/FAIL                                 #
####################################################################
function AIRPLANE_MODE_OFF
{
    cmd connectivity airplane-mode disable
    echo "7E00191800000001AABB"  #PASS
}

###########################################################################
# Function:    WRITE_MFG_DATE                                             #
# Description: This function is used to write the battery production date #
# Inputs:      N/A                                                        #
# Output:      status:     OK/FAIL                                        #
###########################################################################
function WRITE_MFG_DATE
{
    Log "WRITE_MFG_DATE : DATE = $1 "
    length=${#1}
    if [ "$length" -gt 16 ]; then
        Log "WRITE_MFG_DATE : length > 16 "
        echo "FAIL, wrong parameter! length > 16"
    else
        if [[ -z $1 ]]; then
            echo "FAIL, wrong parameter!"
        else
            RESULT=$(/vendor/bin/FacsvcClient -w 184 -s $1)
            Log "WRITE_MFG_DATE : RESULT = $RESULT "
            if [[ -z $RESULT ]]; then
                Log "WRITE_MFG_DATE : FAIL "
                echo "FAIL"
            else
                Log "WRITE_MFG_DATE : PASS "
                echo "7E0006300200000000329ACRRC"
            fi
        fi
    fi
}

###########################################################################
# Function:    READ_MFG_DATE                                              #
# Description: This function is used to read the battery production date  #
# Inputs:      N/A                                                        #
# Output:      status:     OK/FAIL                                        #
###########################################################################
function READ_MFG_DATE
{
    RESULT=$(/vendor/bin/FacsvcClient -r 184 -s)
    Log "READ_MFG_DATE : RESULT = $RESULT "
    if [[ -z $RESULT ]]; then
        Log "READ_MFG_DATE : FAIL "
        echo "FAIL"
    else
        Log "READ_MFG_DATE : PASS "
        echo "$RESULT"
    fi
}

###########################################################################
# Function:    WRITE_OWNED_DATA                                     #
# Description: This function is used to write the zero data#
# Inputs:      N/A                                                        #
# Output:      status:     OK/FAIL                                        #
###########################################################################
function WRITE_OWNED_DATA
{
    Log "WRITE_OWNED_DATA : DATA = $1 "
    length=${#1}
    if [ "$length" -gt 16 ]; then
        Log "WRITE_OWNED_DATA : length > 16 "
        echo "FAIL, wrong parameter! length > 16"
    else
        if [[ -z $1 ]]; then
            echo "FAIL, wrong parameter!"
        else
            RESULT=$(/vendor/bin/FacsvcClient -w 189 -s $1)
            Log "WRITE_OWNED_DATA : RESULT = $RESULT "
            if [[ -z $RESULT ]]; then
                Log "WRITE_OWNED_DATA : FAIL "
                echo "FAIL"
            else
                Log "WRITE_OWNED_DATA : PASS "
                echo "PASS, $RESULT"
            fi
        fi
    fi
}

###########################################################################
# Function:    READ_OWNED_DATA                                      #
# Description: This function is used to read the zero data  #
# Inputs:      N/A                                                        #
# Output:      status:     OK/FAIL                                        #
###########################################################################
function READ_OWNED_DATA
{
    RESULT=$(/vendor/bin/FacsvcClient -r 189 -s)
    Log "READ_OWNED_DATA : RESULT = $RESULT "
    if [[ -z $RESULT ]]; then
        Log "READ_OWNED_DATA : FAIL "
        echo "FAIL"
    else
        Log "READ_OWNED_DATA : PASS "
        echo "$RESULT"
    fi
}

###########################################################################
# Function:    WRITE_FIRST_USAGE_DATE                                     #
# Description: This function is used to write the battery first usgae date#
# Inputs:      N/A                                                        #
# Output:      status:     OK/FAIL                                        #
###########################################################################
function WRITE_FIRST_USAGE_DATE
{
    Log "WRITE_FIRST_USAGE_DATE : DATE = $1 "
    length=${#1}
    if [ "$length" -gt 16 ]; then
        Log "WRITE_FIRST_USAGE_DATE : length > 16 "
        echo "FAIL, wrong parameter! length > 16"
    else
        if [[ -z $1 ]]; then
            echo "FAIL, wrong parameter!"
        else
            RESULT=$(/vendor/bin/FacsvcClient -w 185 -s $1)
            Log "WRITE_FIRST_USAGE_DATE : RESULT = $RESULT "
            if [[ -z $RESULT ]]; then
                Log "WRITE_MFG_DATE : FAIL "
                echo "FAIL"
            else
                Log "WRITE_FIRST_USAGE_DATE : PASS "
                echo "PASS, $RESULT"
            fi
        fi
    fi
}

###########################################################################
# Function:    READ_FIRST_USAGE_DATE                                      #
# Description: This function is used to read the battery first usgae dat  #
# Inputs:      N/A                                                        #
# Output:      status:     OK/FAIL                                        #
###########################################################################
function READ_FIRST_USAGE_DATE
{
    RESULT=$(/vendor/bin/FacsvcClient -r 185 -s)
    Log "READ_MFG_DATE : RESULT = $RESULT "
    if [[ -z $RESULT ]]; then
        Log "READ_MFG_DATE : FAIL "
        echo "FAIL"
    else
        Log "READ_FIRST_USAGE_DATE : PASS "
        echo "$RESULT"
    fi
}

##############################################################################
# Function:    WRITE_FIRST_USAGE_DATE_FLAG                                   #
# Description: This function is used to write the user's first use date mark #
# Inputs:      N/A                                                           #
# Output:      status:     OK/FAIL                                           #
##############################################################################
function WRITE_FIRST_USAGE_DATE_FLAG
{
    Log "WRITE_FIRST_USAGE_DATE_FLAG : DATE = $1 "
    length=${#1}
    if [ "$length" -gt 1 ]; then
        Log "WRITE_FIRST_USAGE_DATE_FLAG : length > 1 "
        echo "FAIL, wrong parameter! length > 1"
    else
        if [[ -z $1 ]]; then
            echo "FAIL, wrong parameter!"
        else
            RESULT=$(/vendor/bin/FacsvcClient -w 186 -s $1)
            Log "WRITE_FIRST_USAGE_DATE_FLAG : RESULT = $RESULT "
            if [[ -z $RESULT ]]; then
                Log "WRITE_MFG_DATE : FAIL "
                echo "FAIL"
            else
                Log "WRITE_FIRST_USAGE_DATE_FLAG : PASS "
                echo "PASS, $RESULT"
            fi
        fi
    fi
}

##############################################################################
# Function:    READ_FIRST_USAGE_DATE_FLAG                                   #
# Description: This function is used to read the user's first use date mark  #
# Inputs:      N/A                                                           #
# Output:      status:     OK/FAIL                                           #
##############################################################################
function READ_FIRST_USAGE_DATE_FLAG
{
    RESULT=$(/vendor/bin/FacsvcClient -r 186 -s)
    Log "READ_MFG_DATE : RESULT = $RESULT "
    if [[ -z $RESULT ]]; then
        Log "READ_MFG_DATE : FAIL "
        echo "FAIL"
    else
        Log "READ_FIRST_USAGE_DATE_FLAG : PASS "
        echo "$RESULT"
    fi
}

function SMALL_PLATE_DETECTION
{

  log_path="small_plate_detection.log"
  log_info "$log_path" "SKU info = $(getprop ro.boot.hardware.sku)"
  RET=$(grep -w '^mtktsusb$' sys/class/thermal/thermal_zone*/type -rnIs)
  log_info "$log_path" "plate_detection content = $RET"
  # echo "grep result: $RET"

  # Extracting hot zone numbers using awk
  ZONE_NUMBER=$(echo "$RET" | awk -F'thermal_zone' '{print $2}' | awk -F'/' '{print $1}')

  if [ -z "$ZONE_NUMBER" ]; then
    log_info "$log_path" "Failed to extract zone number from grep result."
    echo "7E0006310312000001AABB"
  fi

  #echo "Extracted zone number: $ZONE_NUMBER"

  # Constructing the temperature node path
  TEMP_NODE="sys/class/thermal/thermal_zone${ZONE_NUMBER}/temp"

  if [ -f "$TEMP_NODE" ]; then
    path_result=$(cat "$TEMP_NODE")
    log_info "$log_path" "Temperature node path = $TEMP_NODE, Temperature = $path_result"
    #echo "Temperature at $TEMP_NODE: $path_result"
    if [ $path_result -gt 20000 ] && [ $path_result -lt 60000 ]; then
      echo "7E0006310312000000AABB"
    else
      echo "7E0006310312000001AABB"
    fi
  else
    log_info "$log_path" "Temperature node file does not exist: $TEMP_NODE"
    echo "7E0006310312000001AABB"
  fi
}

function GET_FRONT_CAMERA_PN
{
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ "$RET" -eq 0 ]; then
      input keyevent 26
      sleep 0.5
  fi
  camera_path="data/vendor/camera_dump/Moto8SCode_front.bin"
  if [ -f $camera_path ]; then
    camera_pn_result=$(cat $camera_path)
        camera_front_pn_result=${camera_pn_result:0:12}
    log_info "camera_pn.log" "camera_path = $camera_path, camera_front_pn_result= $camera_front_pn_result"
    echo $camera_front_pn_result
  else
    log_info "camera_pn.log" "camera_path the node path does not exist"
    echo "7E0006310401000001AABB"
  fi
}

function GET_CAMERA_PN
{
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ "$RET" -eq 0 ]; then
      input keyevent 26
      sleep 0.5
  fi
  camera_path="data/vendor/camera_dump/MotoCamPN.bin"
  if [ -f $camera_path ]; then
    camera_pn_result=$(cat $camera_path)
    log_info "camera_pn.log" "camera_path = $camera_path, camera_pn_result= $camera_pn_result"
    echo $camera_pn_result
  else
    log_info "camera_pn.log" "camera_path the node path does not exist"
    echo "7E0006310401000001AABB"
  fi
}

function MOTO_CAMERA_8S_CODE
{
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ "$RET" -eq 0 ]; then
    input keyevent 26
    sleep 0.5
  fi

  moto8SCode_path="/data/vendor/camera_dump/Moto8SCode.bin"

  if [ -f "$moto8SCode_path" ]; then
    moto8SCode_result=$(cat "$moto8SCode_path")
    log_info "moto8SCode.log" "moto8SCode_path = $moto8SCode_path, moto8SCode_result = $moto8SCode_result"
    echo "$moto8SCode_result"
  else
    log_info "moto8SCode.log" "moto8SCode_path the node path does not exist"
    echo "7E0006310402000001AABB"
  fi
}

####################################################################
# Function:    READ_FTM_FLAG                                       #
# Description: Get some flags from Tinno production in FtmApp      #
# Inputs:      N/A                                                 #
# parameter:   FinalTest/CaliTest/CouplingT/AudioTest/CameraTes    #
# parameter:   GoogleKey/FtmAppTes/PATTest/PCBATest/SubPCBATe      #
# parameter:   RuninTest/MMITest/FPCTest                           #
# Output:      status:     PASS/FAIL/NA                            #
####################################################################
function READ_FTM_FLAG
{
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ "$RET" -eq 0 ]; then
      input keyevent 26
      sleep 0.5
  fi

  finaltest=$(getprop persist.sys.FinalTest)
  calitest=$(getprop persist.sys.CaliTest)
  copltest=$(getprop persist.sys.CouplingTest)
  audiotest=$(getprop persist.sys.AudioTest)
  cameratest=$(getprop persist.sys.CameraTest)
  googlekey=$(getprop persist.sys.GoogleKey)
  ftmapptest=$(getprop persist.sys.FtmAppTest)
  pattest=$(getprop persist.sys.PATTest)
  pcbatest=$(getprop persist.sys.PCBATest)
  subpcbatest=$(getprop persist.sys.SubPCBATest)
  runintest=$(getprop persist.sys.RuninTest)
  mmitest=$(getprop persist.sys.MMITest)
  fpctest=$(getprop persist.sys.FPCTest)

  pass="PASS"
  fail="FAIL"
  na="NA"

  am start -n com.ape.factory/.CQAtest.CQAActivity -S --es CQA_TEST_MODE TEST_FLAG_OP --es CQA_TEST_FUNCTION READFTMFLAG --es CQA_TEST_PARAMS $1 &>/dev/null
  sleep 0.5
  log_info "ftm_flag.log" "start read ftm flag = $1"

  # Retry logic
  attempt=0
  max_attempts=3
  while [ "$attempt" -lt "$max_attempts" ]; do
    if [ "$1" == "FinalTest" ]; then
      finaltest=$(getprop persist.sys.FinalTest)
      if [ "$finaltest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$finaltest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "CaliTest" ]; then
      calitest=$(getprop persist.sys.CaliTest)
      if [ "$calitest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$calitest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "CouplingTest" ]; then
      copltest=$(getprop persist.sys.CouplingTest)
      if [ "$copltest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$copltest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "AudioTest" ]; then
      audiotest=$(getprop persist.sys.AudioTest)
      if [ "$audiotest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$audiotest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "CameraTest" ]; then
      cameratest=$(getprop persist.sys.CameraTest)
      if [ "$cameratest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$cameratest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "GoogleKey" ]; then
      googlekey=$(getprop persist.sys.GoogleKey)
      if [ "$googlekey" -eq 1 ]; then
        echo $pass
        return
      elif [ "$googlekey" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "FtmAppTest" ]; then
      ftmapptest=$(getprop persist.sys.FtmAppTest)
      if [ "$ftmapptest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$ftmapptest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "PATTest" ]; then
      pattest=$(getprop persist.sys.PATTest)
      log_info "ftm_flag.log" "PATTest flag result = $pattest"
      if [ "$pattest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$pattest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "PCBATest" ]; then
      pcbatest=$(getprop persist.sys.PCBATest)
      if [ "$pcbatest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$pcbatest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "SubPCBATest" ]; then
      subpcbatest=$(getprop persist.sys.SubPCBATest)
      if [ "$subpcbatest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$subpcbatest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "RuninTest" ]; then
      runintest=$(getprop persist.sys.RuninTest)
      if [ "$runintest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$runintest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "MMITest" ]; then
      mmitest=$(getprop persist.sys.MMITest)
      if [ "$mmitest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$mmitest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    if [ "$1" == "FPCTest" ]; then
      fpctest=$(getprop persist.sys.FPCTest)
      if [ "$fpctest" -eq 1 ]; then
        echo $pass
        return
      elif [ "$fpctest" -eq 2 ]; then
        echo $fail
        return
      fi
    fi

    # If the first attempt fails, try again
    attempt=$((attempt + 1))
    sleep 0.3
  done

  # If all retries fail, return NA
  echo $na
}

####################################################################
# Function:    GET_FAST_CHARGE_CUR                                 #
# Description: Get the current charging test current result        #
# Inputs:      N/A                                                 #
# parameter:   N/A                                                 #
# Output:      Current value/FAIL                                  #
####################################################################
function GET_FAST_CHARGE_CUR
{
  RET=$(cat /sys/class/leds/lcd-backlight/brightness)
  if [ $RET -eq 0 ]; then
    input keyevent 26
    sleep 0.5
  fi
  
  CHG_CUR=$(cat /sys/devices/platform/charger/ADC_Charging_Current)
  echo $CHG_CUR
  
}

####################################################################
# Function:    GET_FAST_CHARGE_VOL                                 #
# Description: Get the current charging test voltage result        #
# Inputs:      N/A                                                 #
# parameter:   N/A                                                 #
# Output:      Voltage value/FAIL                                  #
####################################################################
function GET_FAST_CHARGE_VOL
{
	RET=$(cat /sys/class/leds/lcd-backlight/brightness)
	if [ $RET -eq 0 ]; then
	input keyevent 26
	sleep 0.5
	fi
	CHG_VOL=$(cat /sys/devices/platform/charger/ADC_Charger_Voltage)
	echo $CHG_VOL
}

# Create a log information method to store logs in the specified directory
function log_info
{
    local pathfile="$1"
    local message="$2"
    path="/data/debuglogger/CQA_command/$pathfile"

    # Make sure the directory exists
    local dirpath=$(dirname "$path")
    if [ ! -d "$dirpath" ]; then
        mkdir -p "$dirpath"  # Create a directory and its parent directory
    fi

    # Make sure the log file exists
    if [ ! -f "$path" ]; then
        touch "$path"
    fi

    # Recording log information
    echo "[$(date +'%Y-%m-%d %H:%M:%S.%6N')] [INFO] $message" >> "$path"
}

##### Other - END #####

##### Main #####
#echo
#echo "CQA Commands - Version $version"
#echo
#echo "Command executed - \"$0 $@\""
#echo
eval $@
