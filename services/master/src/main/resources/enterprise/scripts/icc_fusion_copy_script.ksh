#!/bin/sh

 Source in the CUSTOM_PROFILE if set.
# This will be set in sudo'ing from the Autosys trg-user to our Admin userid.  System variables do not
# cross over in the sudo, but this variable does (configured that way in /etc/sudoers).
if [ "x${CUSTOM_PROFILE}" != "x" ] ; then
  echo "Sourcing in CUSTOM_PROFILE '${CUSTOM_PROFILE}'"
  . ${CUSTOM_PROFILE}
else
  echo "no CUSTOM_PROFILE set"
fi

echo "Entered into ICC Fusion Copy Scripts"

usage(){
  echo "Usage: ./icc_fusion_copy_script.ksh -S <Source Dir/Filename> -T <Target Location>" 
  echo "Usage: ./icc_fusion_copy_script.ksh -S source/test.txt -T target" 
  exit 1
}
#
#if no argument
#
if [ $# -lt 1 ]; then
  usage
fi


while getopts :S:T: opt
do
  case "$opt" in
    S) SOURCE_LOCATION="$OPTARG";;
    T) TARGET_LOCATION="$OPTARG";;
    \?) usage;;
  esac
done

. ${ENT_CONF_DIR}/copy_jobnames.properties

#AUTO_JOB_NAME="123testjob1"
echo "Job name executing the script is ${AUTO_JOB_NAME}"

FLAG_CHECK=1


if [[ -z "${AUTO_JOB_NAME}" ]] ; then
    #AUTO_JOB_NAME="DIRECT_COMMAND_LINE"
    echo "Job Name is missing. You are not authorized to execute this script " 
    exit 255
else
    for MYVAL in $JOB_NAMES
    do
	if [ ${AUTO_JOB_NAME} = ${MYVAL} ]; then
	    FLAG_CHECK=0
	 fi
    done   
fi 

if [ $FLAG_CHECK -eq 0 ] ; then
    echo "cp $SOURCE_LOCATION $TARGET_LOCATION"
    eval `cp $SOURCE_LOCATION $TARGET_LOCATION`
else
    echo "${AUTO_JOB_NAME} not authorized to execute this script"
    exit 255
fi

