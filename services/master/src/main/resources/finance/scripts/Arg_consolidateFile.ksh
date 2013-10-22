#!/bin/ksh
# Source in the CUSTOM_PROFILE if set.
# This will be set in sudo'ing from the Autosys trg-user to our Admin userid.  System variables do not
# cross over in the sudo, but this variable does (configured that way in /etc/sudoers).
if [ "x${CUSTOM_PROFILE}" != "x" ] ; then
  echo "Sourcing in CUSTOM_PROFILE '${CUSTOM_PROFILE}'"
  . ${CUSTOM_PROFILE}
else
  echo "no CUSTOM_PROFILE set"
fi

ISFILE=`find $DATA_DIR/cdp/in -type f -mmin +1`

if [[ -n ${ISFILE} ]]; then

CREATE_DATE=`date +%Y%m%d%H%M%S`
print "\nThis is the create date: $CREATE_DATE "
TMPFILE="annx_eInvoice_Index_${CREATE_DATE}"
print "\nThis is the temp file name: $TMPFILE "
print "\nMoving $DATA_DIR/cpd/in/$FILENAME to $DATA_DIR/cdp/stage/$FILENAME..."
find $DATA_DIR/cdp/in -type f -mmin +1 -exec mv -t $DATA_DIR/cdp/stage {} \;
typeset -Z6 FCNT=`find $DATA_DIR/cdp/stage -type f | wc -l`
print "\nNumber of files to process: $FCNT"
for FILENAME in $(ls $DATA_DIR/cdp/stage)
   do
       print "\n$FILENAME" 
       cat $DATA_DIR/cdp/stage/$FILENAME  >> $DATA_DIR/cdp/stage/$TMPFILE
       rm -f $DATA_DIR/cdp/stage/$FILENAME
   done
echo "C$FCNT" >> $DATA_DIR/cdp/stage/$TMPFILE
FSIZE=`ls -lat $DATA_DIR/cdp/stage/$TMPFILE | cut -d ' ' -f5`
NEWFILE="$DATA_DIR/cdp/stage/${TMPFILE}_${FSIZE}B.txt"
print "\nRenaming to new file name...$NEWFILE\n" 
mv $DATA_DIR/cdp/stage/$TMPFILE $NEWFILE
print "Moving to out directory...$DATA_DIR/cdp/out\n"
mv $NEWFILE $DATA_DIR/cdp/out
else

print "\nNo files to process... exiting!\n"
exit 1
fi
