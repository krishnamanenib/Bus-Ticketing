#!/bin/ksh
#set +x
# Date - 09/21/2012
# Author - Cliff Nimz
# Description - FTP Wrapper to check status of Autosys return code and send email notification if no file
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

## Call the Ftp Command
FTP $* 
EXITCODE=$?
if [[ ${EXITCODE} -ne 0 ]] ; then
   FTP_PF=`echo $* | awk '{for(i=1;i<=NF;i++){ if($i=="-ftp_pf"){print $(i+1)} } }'`
   PF=`echo $FTP_PF | cut -d "/" -f15`
   EMAIL_LIST=`cat $FTP_PF | grep EMAIL_LIST | cut -d "=" -f2`
   MAIL_CONTENT_FILE=/tmp/Mail_Ftp_File_Content.txt
   cat<<-EOF>$MAIL_CONTENT_FILE
	This is to notifiy that there is no data to process from Nike, so please disregard the missing file
	email notification for Nike inbound ${PF} feed.

	Below shows the Autosys command line to know which feed didn't have a file:
	
	$*

	Regards,

	Fusion Support
	EOF
   print "\nThere was no file to process for this run.\n"
   mailx -s "No file to process for Nike inbound ${PF}..." $EMAIL_LIST < $MAIL_CONTENT_FILE 
   rm -f $MAIL_CONTENT_FILE
   exit ${EXITCODE}
else
   exit ${EXITCODE}
fi
