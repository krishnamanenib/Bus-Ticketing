#!/bin/ksh
##############################################################################################
# Name: ConcatenateXMLFiles.ksh
# Description: 
#      Concatenate XML files 
#          1. Move them to a "stage" sub folder
#          2. Strip the "xml" and root tags from each input file
#          2. Concatenate the files together into one temporary file
#          4. Add the "xml" and root tags back on to the concatenated file
#
# E.g. ConcatenateXMLFiles.ksh $DATA_DIR/my_dir $DATA_DIR/my_output_dir/my_output_file INVOIC
#
# Arguments:
#      1. Directory to where the input files are 
#           E.g. $DATA_DIR/my_dir_name
#      2. Output file path/name
#           E.g. $DATA_DIR/my_output_dir_name/my_output_file_name
#      3. Root tag to strip from individual files and to add back on concatenated file
#           E.g. _-AFS_-ORDERS05 or PEXR2002 or _-AFS_-INVOIC05 or _-AFS_-SHPMN etc
#
# Change History:
# Date: 05/16/12 - clorim
##############################################################################################

if [[ $# < 3 ]]; then
   echo "Usage: ConcatenateXMLFiles.ksh input-directory concatenated-file"
   echo ""
   echo "  E.g.    ConcatenateXMLFiles.ksh $DATA_DIR/my_dir $DATA_DIR/my_output_dir/my_output_file _-AFS_-SHPMN"
   echo ""
   exit 50
fi

ofile=$(basename $2)
odir=$(dirname $2)

rm -f $2.tmp
rm -f $1/StagedFilesList.txt


## Check for files to process
cd $1
num=`find . -maxdepth 1 -type f -mmin +1 -print | wc -l`
if [[ $num -eq 0 ]] ; then
   echo "##NO files in $1 directory to process, exiting"
   exit 1
fi

##  1. Move files to stage sub folder
cd $1
find . -maxdepth 1 -type f -mmin +1 -exec mv -t stage {} \;
EXITCODE=$?
if [[ ${EXITCODE} -ne 0 ]] ; then
   echo "##MOVE of files to stage directory Failed"
   exit ${EXITCODE}
fi

##  2. Strip the xml and root tags from each input file and concatenate into temporary file
export XMLLINT_INDENT=''
find $1/stage -type f -print > $1/StagedFilesList.txt 2> /dev/null
 x=1
 while read LINE
 do
   rm -f $odir/tempxml.txt
   xmllint --format ${LINE} > $odir/tempxml.txt
   if [ "$?" != 0 ]; then
      echo "Unable to format input file ${LINE} from stage folder"
      exit 2
   fi
   cat $odir/tempxml.txt >> $2.tmp
## Grab the Root and End Tags from the first file encountered
   if [ $x -eq 1 ]; then
      head -2 $odir/tempxml.txt > $odir/RootTag.txt 2> /dev/null
      tail -1 $odir/tempxml.txt > $odir/EndTag.txt 2> /dev/null
      x=0
   fi
 done < $1/StagedFilesList.txt

rm -f $1/stage/*.*

##  3. Strip the xml and root tags from the file
cd $odir
sed -i -e "s;<?xml version=\"1.0\" encoding=\"UTF-8\"?>;;g" $ofile.tmp
sed -i -e "s;<\b[^>]*${3}\b[^>]*>;;g" $ofile.tmp
sed -i -e "s;</\b[^>]*${3}>;;g" $ofile.tmp
EXITCODE=$?
if [[ ${EXITCODE} -ne 0 ]] ; then
   echo "##sed command Failed"
   exit ${EXITCODE}
fi

##  4. Add the xml and root tags back on to the file
rm -f $ofile
cat RootTag.txt $ofile.tmp EndTag.txt > $ofile.tmp2
EXITCODE=$?
if [[ ${EXITCODE} -ne 0 ]] ; then
   echo "##Final cat to put Root tag and End Tag Failed" 
   exit ${EXITCODE}
fi

##  5. Remove newlines from output file
tr -d "\012" <$ofile.tmp2 >$ofile

#CLEANUP 
rm -f RootTag.txt
rm -f EndTag.txt
rm -f $ofile.tmp
rm -f $ofile.tmp2
rm -f $odir/tempxml.txt

