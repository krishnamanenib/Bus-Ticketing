#!/bin/ksh
# Date - 11/12/2012
# Author - Cliff Nimz
# Description - FTP Wrapper to send file as an attachment in email before FTPing to system.
#               This script reads the properties file to get the filename - can not be filemask!
# Source in the CUSTOM_PROFILE if set.
# This will be set in sudo'ing from the Autosys trg-user to our Admin userid.  System variables do not
# cross over in the sudo, but this variable does (configured that way in /etc/sudoers).
if [ "x${CUSTOM_PROFILE}" != "x" ] ; then
  echo "Sourcing in CUSTOM_PROFILE '${CUSTOM_PROFILE}'"
  . ${CUSTOM_PROFILE}
else
  echo "no CUSTOM_PROFILE set"
fi

ME=${0##*/}

echo $*
FTP_PF=`echo $* | awk '{for(i=1;i<=NF;i++){ if($i=="-ftp_pf"){print $(i+1)} } }'`
LOCAL_DIR=`cat $FTP_PF | grep Local_DirectoryName | cut -d "=" -f2`
ACTUAL_DIR=$(eval echo $LOCAL_DIR )
LOCAL_FILENAME=`cat $FTP_PF | grep Local_FileName= | cut -d "=" -f2`
FILE=$ACTUAL_DIR/$LOCAL_FILENAME
ISFILE=`find $FILE -type f`
if [[ -f ${ISFILE} ]] ; then
   EMAIL_LIST=`cat $FTP_PF | grep EMAIL_LIST | cut -d "=" -f2`
   print  "\nThis is the file being emailed: $ISFILE\n"
   print "\nThis is the email address: $EMAIL_LIST\n"
   cat $ISFILE | uuencode $LOCAL_FILENAME | mailx -s "Here is the file requested: ${LOCAL_FILENAME}" $EMAIL_LIST

### Call the Ftp Command
FTP $*
else
print "\nThere was no file to process.\n"
exit 1
fi
