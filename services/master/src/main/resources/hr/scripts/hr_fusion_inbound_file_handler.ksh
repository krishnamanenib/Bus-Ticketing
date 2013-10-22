#!/bin/sh
#Source in the CUSTOM_PROFILE if set.
# This will be set in sudo'ing from the Autosys trg-user to our Admin userid.  System variables do not
# cross over in the sudo, but this variable does (configured that way in /etc/sudoers).
if [ "x${CUSTOM_PROFILE}" != "x" ] ; then
 echo "Sourcing in CUSTOM_PROFILE '${CUSTOM_PROFILE}'"
 . ${CUSTOM_PROFILE}
else
 echo "no CUSTOM_PROFILE set"
fi 

usage(){
  echo "Usage: ./fusion_hr_copy.ksh -P <Full Path of the property file>"
  echo "Usage: ./fusion_hr_copy.ksh -P ${CONF_DIR}${FTP_PROP_DIR}/BN_Ded_Import__BiAnn_64_FMW_To_SAP_Archive.properties"
  exit 1
}


checkFile(){
  echo "-f $FILE_PATTERN*" 
  #if [ -f $FILE_PATTERN* ]; then 
  if ls $FILE_PATTERN* &> /dev/null; then
     echo "File exists in source directory"
  else
     echo "No File found with the pattern ${FILE_PATTERN}"
     SUBJECT="ACTION REQUIRED no files to process from Staging Directory ${INTERFACE_ID}"
	  EMAIL_BODY="No Files available in ${SOURCE_LOCATION} with the file pattern ${FILE_PATTERN} for processing"
	  sendMail 
	  exit 50
  fi

#  if [ -f $TARGET_LOCATION/$FILE_PATTERN* ]; then
   if ls $TARGET_LOCATION/$FILE_PATTERN* &> /dev/null; then
        echo "File already exists in "$TARGET_LOCATION/$FILE_PATTERN$EXTENSION
      	exit 50
  fi
}



processFile(){
  cd $SOURCE_LOCATION
  checkFile 
  GET_OLDEST_FILE=`ls -ltr $FILE_PATTERN* | head -1 | awk '{print $9}'`
  echo "Oldest File in Dir " $GET_OLDEST_FILE

  #if [ "gpg" in ${FILE_PATTERN} ]; then
   if [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/TXT.gpg/')" ]; then
	EXTENSION=".TXT.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/EXP.gpg/')" ]; then
	EXTENSION=".EXP.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/DAT.gpg/')" ]; then
	EXTENSION=".DAT.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/dat.gpg/')" ]; then
	EXTENSION=".dat.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/csv.gpg/')" ]; then
	EXTENSION=".csv.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/DAT.1.gpg/')" ]; then
	EXTENSION=".DAT.1.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/txt.gpg/')" ]; then
	EXTENSION=".txt.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/xml.gpg/')" ]; then
	EXTENSION=".xml.gpg"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/csv/')" ]; then
	EXTENSION=".csv"
	elif [ ! -z "$(echo ${GET_OLDEST_FILE} | awk '/CSV/')" ]; then
	EXTENSION=".CSV"
  else
	EXTENSION=".xml"
	
  fi
  #Copying the file without timestamp to the Target Directory
  cp $GET_OLDEST_FILE $TARGET_LOCATION/$FILE_PATTERN$EXTENSION
  #Moving the file with timestamp to the Second Target Directory
  mv $GET_OLDEST_FILE $TARGET_TIMESTAMP_LOCATION
}


sendMail(){
	EMAIL_TO="!!osb.email6.list.hr!!,!!osb.email7.list.hr!!"
	EMAILMESSAGE="emailmessage.txt"
	echo $EMAIL_BODY> $EMAILMESSAGE
	# send an email using /bin/mail
	/bin/mail -s "$SUBJECT" "$EMAIL_TO" < $EMAILMESSAGE
}



#
#if no argument
#
if [ $# -lt 1 ]; then
  usage
fi


while getopts :P: opt
do
  case "$opt" in
    P) PROPERTY_FILE="$OPTARG";;
    \?) usage;;
  esac
done

#Sourcing the Property File
. $PROPERTY_FILE

SOURCE_LOCATION=$Local_DirectoryName_Stage
TARGET_LOCATION=$Local_DirectoryName
TARGET_TIMESTAMP_LOCATION=$Local_DirectoryName_Arch
FILE_PATTERN=$Local_FileNamePattern
INTERFACE_ID=$Interface_Id

echo "Source Location: "$SOURCE_LOCATION
echo "Target Location: "$TARGET_LOCATION
echo "Target Location to move file with Time stamp: "$TARGET_TIMESTAMP_LOCATION
echo "File Pattern to search for: "$FILE_PATTERN
echo "Interface ID: "$INTERFACE_ID

currDir="!!osb.hr.inbound.log.dir!!"
processFile

CURRENT_STATUS=$?
if [ ${CURRENT_STATUS} != "0" ]; then
	exit 50
fi

#Sending mail to end users on the pending list of files
PENDING_FILES=`ls -rt $FILE_PATTERN*`
if $PENDING_FILES &> /dev/null; then
        echo "No more Files to Process from Staging directory"
		fi
TMP_FILE="${currDir}/hrfiles.txt"
echo " ">$TMP_FILE
for curfiles in $PENDING_FILES:
do
	echo $curfiles>>$TMP_FILE
	echo "  ">>$TMP_FILE
done


SUBJECT="ACTION REQUIRED - Additional HR Files to Process ${INTERFACE_ID}"
OUTPUT=`cat $TMP_FILE`

EMAIL_BODY="List of left over files "$OUTPUT
sendMail
## Removing Temp Files
rm $TMP_FILE
