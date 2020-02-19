#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	DoAndStopAndDo.sh
#	https://github.com/Headbolt/DoAndStopAndDo
#
#   This Script is designed for use in JAMF as a Login Script in a policy run at login,
#		
#   - This script will ...
#		Run a specified policy Trigger
#		Pause for a defined number of seconds
#		Run an Inventory
#		Pause for another defined number of seconds
#		Run a specified policy Trigger
#
###############################################################################################################################################
#
# HISTORY
#
#	Version: 1.1 - 19/02/2020
#
#	- 14/12/2018 - V1.0 - Created by Headbolt
#
#	- 19/02/2020 - V1.1 - Updated by Headbolt
#							Better Documentation
#
###############################################################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
# Variables used by this script.
#
Pause1=$4 # Grab the Duration of the First Pause In Seconds from JAMF variable #4 eg 10
Pause2=$5 # Grab the Duration of the Second Pause In Seconds from JAMF variable #5 eg 10
Trigger1=$6 # Grab the First Policy Trigger to Execute JAMF variable #6 eg POLICYTRIGGER
Trigger2=$7 # Grab the Second Policy Trigger to Execute JAMF variable #7 eg POLICYTRIGGER
elevate=$8 # Grab whether to run this Policy Trigger usinf SUDO from JAMF variable #8 eg YES
ForeBack=$9 # Grab whether to run theis Policy trigger in the ForeGround or Backgroup (Must be in CAPS) from JAMF variable #9 eg FOREGROUND
#
ScriptName="append suffix as needed - Run Specific Policy Trigger - Pause xxx Seconds - Inventory - Pause xxx Seconds - Run Specific Policy Trigger"
#
Stamp=$(date) # Grab The Current Time so we can output it for Reporting Purposes
#
###############################################################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
#
# Beginning Processing
#
###############################################################################################################################################
#
SectionEnd
#
/bin/echo "$Stamp" # Display Cunnent Time
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
os_ver=$(sw_vers -productVersion)
IFS='.' read -r -a ver <<< "$os_ver"
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
/bin/echo "Running all Policies with the Trigger $Trigger1"
/bin/echo "Then Pausing for $Pause1 Seconds"
/bin/echo "Then Running an Inventory"
/bin/echo "Then Pausing another $Pause2 Seconds"
/bin/echo "Then running all Policies with the Trigger $Trigger2"
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
if [ "${elevate}" == YES ]
	then
		Elevate=sudo
		/bin/echo"Running Commands Elevated"
		/bin/echo # Outputs a blank line for reporting purposes
	else
		Elevate=""    
fi
#
if [ "${ForeBack}" == "FOREGROUND" ]
	then
		FB=""
		/bin/echo "Running Commands in the Foreground"
		/bin/echo # Outputs a blank line for reporting purposes
	else
		FB='&'
		/bin/echo "Running Commands in the Background"
fi
#
Command=$(/bin/echo $Elevate /usr/local/bin/jamf policy -trigger '"'$Trigger1'"' '&&' sleep $Pause1's' '&&' $Elevate /usr/local/bin/jamf recon '&&' sleep $Pause2's' '&&' $Elevate /usr/local/bin/jamf policy -trigger '"'$Trigger2'"' $FB)
#
/bin/echo "$Command"
#
eval "$Command"
#
SectionEnd
ScriptEnd
