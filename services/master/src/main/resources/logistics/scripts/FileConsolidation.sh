#!/bin/sh

# Source in the CUSTOM_PROFILE if set.
# This will be set in sudo'ing from the Autosys trg-user to our Admin userid.  System variables do not
# cross over in the sudo, but this variable does (configured that way in /etc/sudoers).
if [ "x${CUSTOM_PROFILE}" != "x" ] ; then
  echo "Sourcing in CUSTOM_PROFILE '${CUSTOM_PROFILE}'"
  . ${CUSTOM_PROFILE}
else
  echo "no CUSTOM_PROFILE set"
fi

if [ $# -ne 1 ]; then
   echo "Incorrect number of Parameters Passed"
   echo "Format: GSFileConsolidation.sh <Property_File>"
   exit 2
fi

ScriptDir=`dirname $0`
SCRIPT_NAME=$(basename $0)

cd $ScriptDir;


SCRIPT_NAME=`echo "$SCRIPT_NAME"|sed 's/\..*//'`
ext=`date "+%Y%m%d%H%M%S"`

Property_File=$1

prefix=$(basename $Property_File)
prefix=`echo "$prefix"|sed 's/\..*//'`

#Log_Dir=/int3/logs/prdosb1/application/gsFileConsolidation
Log_Dir=!!osb.file.logdir.scripts!!
log_file=lg_${prefix}_${ext}.log
LastRunLog=LastRun_${prefix}.log

SrcFileLstName=Src_${prefix}_${ext}_list
SpltFileLstName=Splt_${prefix}_${ext}_list

###########################################################################################
## To Check is the user had proper access to the property file and if the file exists
###########################################################################################

if [ ! -w "$Log_Dir" ]; then
 echo "User $USER does not have proper access to write to the log directory ${iLog_Dir} OR log directory does not exist. \n"
 exit 99;
fi

exec >> ${Log_Dir}/${log_file}

echo "Starting execution of the script"
echo `date`

if [ ! -r "$Property_File" ]; then
echo "User $USER does not have proper access on property file ${Property_File} OR property file does not exist. \n"
exit 99;
fi

PrptyFile_ParmCnt=`cat $Property_File|wc -l`

echo "Total number of parameters in Property file is ${PrptyFile_ParmCnt}"

                if [ "$PrptyFile_ParmCnt" -lt 4 ]; then
                    echo "Insufficient parameters entered in the property file $Property_File."
                    exit 99;
                fi

##############################################################################################
## Extracting contents of property file
##############################################################################################

var=`grep -i "SrcFilePath" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string SrcFilePath in property file : $Property_File"
   exit 2;
fi

SrcDir=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

var=`grep -i "TgtFilePath" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string TgtFilePath in property file : $Property_File"
   exit 2;
fi

TgtDir=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

var=`grep -i "StgFilePath" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string StgFilePath in property file : $Property_File"
   exit 2;
fi

StgDir=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

var=`grep -i "FilePattern" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string FilePattern in property file : $Property_File"
   exit 2;
fi

File_Pattern=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

var=`grep -i "MsgLimit" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string MsgLimit in property file : $Property_File"
   exit 2;
fi

Msg_Limit=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

var=`grep -i "MsgHdr" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string MsgHdr in property file : $Property_File"
   exit 2;
fi

if [ -z "$Msg_Limit" ]; then
    Msg_Limit=0
fi

Msg_Hdr=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`


var=`grep -i "Interface" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string Interface in property file : $Property_File"
   exit 2;
fi

Int_Val=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'|tr '[a-z]' '[A-Z]'`

#############################################################################
#####  To check if the user has access to Source Dir
############################################################################

if [ ! -d "$SrcDir" -o ! -x "$SrcDir" -o ! -r "$SrcDir" -o ! -w "$SrcDir" ]; then

echo "User $USER does not have proper access (Read, Write or Execute) on Source file Directory ${SrcDir} or
the Directory does not exist."

exit 2;

fi

#############################################################################
#####  To check if the user has access to Target Dir
############################################################################

if [ ! -d "$TgtDir" -o ! -x "$TgtDir" -o ! -r "$TgtDir" -o ! -w "$TgtDir" ]; then

echo "User $USER does not have proper access (Read, Write or Execute) on Target file Directory ${TgtDir} or
the Directory does not exist."

exit 2;

fi

#############################################################################
#####  To check if the user has access to Stage Dir
############################################################################

if [ ! -d "$StgDir" -o ! -x "$StgDir" -o ! -r "$StgDir" -o ! -w "$StgDir" ]; then

echo "User $USER does not have proper access (Read, Write or Execute) on Stage file Directory ${StgDir} or
the Directory does not exist."

exit 2;

fi


##################################################################################################
# Checking status of previous run, if previous run was not successful, we need to delete the 
# target files created by that run
##################################################################################################


PrevRunLogFile=`ls -ltr ${Log_Dir}/lg_${prefix}_*.log | tail -2|head -1|awk '{print $9}'`
echo "previous run log file is $PrevRunLogFile "

StatusFlag=`grep -i 'STATUS=SUCCESS' ${PrevRunLogFile}|wc -l`

       if [[ "$StatusFlag" -eq "1" ]]; then
            echo "previous status run for this job was successful"
            rm -f ${Log_Dir}/${LastRunLog}
            touch ${Log_Dir}/${LastRunLog}
       else
            echo "previous status run status for this job was Failure"

               if [[ -s "${Log_Dir}/${LastRunLog}" ]]; then
                        
                     echo "Target files generated for previous run are:"
                     cat ${Log_Dir}/${LastRunLog} >> ${Log_Dir}/${log_file}
               
                     while read LINE
                     do
                          EXT=`date "+%Y%m%d%H%M%S"`
                          echo "Archiving Target file $LINE to file ${TgtDir}/Arch_${File_Pattern}_${EXT}"
                          mv -f $LINE ${TgtDir}/Arch_${File_Pattern}_${EXT}

                              if [ "$?" != 0 ]; then
                                 echo "unable to delete target file ${LINE} generated from previous run"
                                 exit 2;
                              fi
                          sleep 1                          
            
                    done < ${Log_Dir}/${LastRunLog}
                  
                    rm -f ${Log_Dir}/${LastRunLog}
                    touch ${Log_Dir}/${LastRunLog}
               fi             

       fi





#############################################################################
#####  create source file list in source directory.
#####  Moving source files from source to stage directory and renaming and
##### checking to see if file is not in use
############################################################################

SrcCnt=`ls -l ${SrcDir}/${File_Pattern}* 2> /dev/null`

       if [ "$?" -eq "0" ]; then

           ls -ltr ${SrcDir}/${File_Pattern}*|awk '{print $9}' > ${StgDir}/${SrcFileLstName}

             while read LINE
             do  
                DtTime=`date "+%Y%m%d%H%M%S"`
                if [ "${ARCHIVE_FLAG}" = "true" ]; then
                    echo "Archiving Source file ${LINE} to ${StgDir}/archive/${File_Pattern}_${DtTime}"
                    cp $LINE ${StgDir}/archive/${File_Pattern}_${DtTime}
                fi
                echo "Moving Source file ${LINE} to ${StgDir}/${File_Pattern}_${DtTime}"
                mv -f $LINE ${StgDir}/${File_Pattern}_${DtTime}
                In_FileName=`echo "$LINE"|sed 's/.*\///'`
                echo "AUDIT_LOG~${In_FileName}~${File_Pattern}_${DtTime}"
                

                     if [ "$?" != 0 ]; then
                        echo "unable to move source files from ${SrcDir}/${File_Pattern}* to ${TgtDir}"
                        exit 2;
                     fi
                sleep 1

            done < ${StgDir}/${SrcFileLstName}

       fi

#############################################################################
#####  create source file list in stage directory
############################################################################

ls -ltr ${StgDir}/${File_Pattern}*|awk '{print $9}' > ${TgtDir}/${SrcFileLstName} 2> /dev/null

              if [ "$?" != 0 ]; then
                 echo "unable to create source list file ${TgtDir}/${SrcFileLstName}"
                 exit 2;
              fi

echo `date`": checking if the source files are been used by any application"

       while read LINE
       do
         
         status=`lsof $LINE|wc -l`
         echo "${LINE} status is $status"
        
         while [ "$status" -ne "0" ]; do
               echo "${LINE} file in use sleep for 60 seconds"
               sleep 60
               status=`lsof $LINE|wc -l`
         done


       done < ${TgtDir}/${SrcFileLstName}

echo `date`": checking completed"

echo "SrcDir = $SrcDir"
echo "TgtDir = $TgtDir"
echo "File_Pattern = $File_Pattern"

echo " List of source files"
cat ${TgtDir}/${SrcFileLstName} >> ${Log_Dir}/${log_file}


#######################################################################################
## Creating consolidated file based on source files in stage directory
#######################################################################################
trap "rm -f ${StgDir}/ICncl_${File_Pattern}_*.TEMP ${StgDir}/Splt_${File_Pattern}_*.TEMP ${TgtDir}/Src_${prefix}_*_list ${TgtDir}/Splt_${prefix}_*_list ${StgDir}/Src_${prefix}_*_list; exit" 0

      if [ -s "${TgtDir}/${SrcFileLstName}" ]; then

           echo `date`": starting to create Initial consolidate file"
           ext=`date "+%Y%m%d%H%M%S"`
           ICnclFname=ICncl_${File_Pattern}_${ext}.TEMP

           SpltFname=Splt_${File_Pattern}_${ext}.TEMP

           touch ${StgDir}/${ICnclFname};


                  while read FNAME
                  do
                     if [ "$Int_Val" = "I001" ]; then

                          File_MsgCnt=`grep -in '<Order xmlns="">$' ${FNAME}| wc -l 2> /dev/null`
                          echo `date`": Total number of messages in stage file ${FNAME} is ${File_MsgCnt} "

                          cat $FNAME|sed 's/<?xml version.*/ \
<Order>/' >> ${StgDir}/${ICnclFname}
                     else 
                          File_MsgCnt=`sed 's/^ *//' ${FNAME}|grep -in "^$Msg_Hdr"| wc -l 2> /dev/null`
                          echo `date`": Total number of messages in stage file ${FNAME} is ${File_MsgCnt} "
                          cat $FNAME >> ${StgDir}/${ICnclFname}
                     fi     
              
                     if [ "$?" != 0 ]; then
                        echo `date`": Failed while trying to copy file contents $FNAME to Initial consolidated file ${StgDir}/${ICnclFname}"
                        rm -f ${TgtDir}/${SrcFileLstName}
                        exit 2;
                     fi         

                  done < ${TgtDir}/${SrcFileLstName}

           echo ""


           Total_Msg=`sed 's/^ *//' ${StgDir}/${ICnclFname}|grep -in "^$Msg_Hdr"| wc -l 2> /dev/null`

           echo `date`": Total number of messages in Initial Consolidated file ${StgDir}/${ICnclFname} is ${Total_Msg} "

###############################################################################################################
##  create chunk files based on message limit parameter provided in property file, if the message limit is given 
## as zero only one file will be generated
###############################################################################################################

           if [ "$Msg_Limit" -eq "0" ]; then
                ITR=1
                Rmd=0
                k=$(( $Total_Msg + 1 ))
           else      
                ITR=$(( $Total_Msg / $Msg_Limit ))
                Rmd=$(( $Total_Msg % $Msg_Limit ))
                k=$(( $Msg_Limit + 1 ))
           fi
      

           if [ "$Rmd" -gt "0" ]; then
                ITR=$(( $ITR + 1 ))
           fi

           echo `date`": The Initial consolidated file ${StgDir}/${ICnclFname} will be split into $ITR files"

           n=1
           start=$(( $start + 1 ))
           NOL=`wc -l < ${StgDir}/${ICnclFname}`




           while [ $n -le $ITR ]
           do
                  echo `date`": Generating new split file ${StgDir}/${SpltFname}"
            
                  if [[ "$n" -lt "$ITR" ]];then
                        end=`sed 's/^ *//' ${StgDir}/${ICnclFname}|grep -in "^$Msg_Hdr"|cut -d":" -f1| sed -n "$k"p`
                        end=$(( $end - 1 ))
                  else
                        end=`wc -l < ${StgDir}/${ICnclFname}`
                        end=$(( $end + 1 ))     
                  fi

                  echo "NOL=$NOL"
                  echo "end=$end"
                  echo "start=$start, end=$end"

                  sed -n "$start","$end"p ${StgDir}/${ICnclFname} > ${StgDir}/${SpltFname}
                  sleep 1
                  ext=`date "+%Y%m%d%H%M%S"`
                  SpltFname=Splt_${File_Pattern}_${ext}.TEMP
                  n=$(( n + 1 ))
                  start=$(( $end + 1 ))
                  k=$(( $Msg_Limit + $k ))

           done

           echo `date`": validating if Initial consolidated file size is equal to size of all split files"

           ICSize=`ls -l ${StgDir}/${ICnclFname}|awk '{print $5}'`
           SFSize=`ls -l ${StgDir}/Splt_${File_Pattern}_*.TEMP|awk '{var=var+$5} END {print var}'`

              if [[ "$ICSize" -ne "$SFSize" ]]; then
                  echo `date`": Initial Consolidated file ${StgDir}/${ICnclFname} size ${ICSize} \n is not matching with Split files in location ${StgDir} size ${SFSize}"
                  exit 2
              fi

           echo `date`": Validation completed size is matching"
           echo "Creating Split file list"

           ls -ltr ${StgDir}/Splt_${File_Pattern}*.TEMP|awk '{print $9}' > ${TgtDir}/${SpltFileLstName}

              if [ "$?" != 0 ]; then
                 echo "unable to create source list file ${TgtDir}/${SpltFileLstName}"
                 exit 2;
              fi

           echo `date`": List of split source files"
           cat ${TgtDir}/${SpltFileLstName} >> ${Log_Dir}/${log_file}
      else
          echo "No source files available for transfer:"
      fi

########################################################################################
## File Concatenation process
########################################################################################

if [ "$Int_Val" = "I001" ]; then

      if [ -s ${TgtDir}/${SpltFileLstName} ]; then

           while read FNAME
           do
               ext=`date "+%Y-%m-%d_%H%M%S"`
               TgtFileName=${File_Pattern}_${ext}.xml
               sleep 1
               echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} from Split file $FNAME \n"
               echo '<?xml version="1.0" encoding="UTF-8" ?><DOMSToGSS xmlns="">' > ${TgtDir}/${TgtFileName}
               echo '<Orders>' >> ${TgtDir}/${TgtFileName}


	        cat $FNAME >> ${TgtDir}/${TgtFileName}

                       if [ "$?" != 0 ]; then
                            echo "unable to copy source file $FNAME content to ${TgtDir}/${TgtFileName}"
                            rm -f ${TgtDir}/${SrcFileLstName}
                            rm -f ${TgtDir}/${SpltFileLstName}
                            exit 2;
                       fi


               echo '</Orders>' >> ${TgtDir}/${TgtFileName}
               echo '</DOMSToGSS>' >> ${TgtDir}/${TgtFileName}
               TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
               echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
               echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog}
               In_FileName=`echo "$FNAME"|sed 's/.*\///'`
               echo "AUDIT_LOG~${In_FileName}~${TgtFileName}"

	    done < ${TgtDir}/${SpltFileLstName}

      else
           ext=`date "+%Y-%m-%d_%H%M%S"`
           TgtFileName=${File_Pattern}_${ext}.xml
           echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} \n"
           echo '<?xml version="1.0" encoding="UTF-8" ?><DOMSToGSS xmlns="">' > ${TgtDir}/${TgtFileName}
           echo '</DOMSToGSS>' >> ${TgtDir}/${TgtFileName}
           TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
           echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
           echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog}
      fi


elif [ "$Int_Val" = "I002" ]; then

    DtTime=`date +%Y%m%d%H%M%S`
    Header=`echo "0|H||||${DtTime}||||||||||||||||||||||||||"`


      if [ -s ${TgtDir}/${SpltFileLstName} ]; then

          while read FNAME
          do
               if [ "$Msg_Limit" -eq "0" ]; then
                  ext=''
               else
                    ext="_"`date "+%Y%m%d%H%M%S"`
               fi

             TgtFileName=${File_Pattern}${ext}.409
             sleep 1
             echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} from Split file $FNAME \n"
             echo "$Header" > ${TgtDir}/${TgtFileName}
             cnt=0


               while read LINE
               do
                  cnt=$(( $cnt + 1 ))

                  echo "${cnt}${LINE}" >> ${TgtDir}/${TgtFileName}

                      if [ "$?" != 0 ]; then
                          echo "unable to add counter to $LINE record in file ${TgtDir}/${TgtFileName}"
                          rm -f ${TgtDir}/${SrcFileLstName}
                          rm -f ${TgtDir}/${TgtFileName}_Temp
                          exit 2;
                      fi
    
               done < $FNAME

             echo "${cnt}|F||||||||||||||||||||||||||||||" >> ${TgtDir}/${TgtFileName}
             TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
             echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
             echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog}
             In_FileName=`echo "$FNAME"|sed 's/.*\///'`
             echo "AUDIT_LOG~${In_FileName}~${TgtFileName}"

          done < ${TgtDir}/${SpltFileLstName}

      else
          TgtFileName=${File_Pattern}.409
          echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} \n"
          echo "$Header" > ${TgtDir}/${TgtFileName}
          echo "0|F||||||||||||||||||||||||||||||" >> ${TgtDir}/${TgtFileName}
          TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
          echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
          echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog}

      fi

      rm -f ${TgtDir}/${TgtFileName}_Temp

elif [ "$Int_Val" = "I003" ]; then

     if [ "$File_Pattern" = "NIKEID" ]; then
           File_Pattern=SALESID
     fi


      if [ -s ${TgtDir}/${SpltFileLstName} ]; then

         var_sec=0

              while read FNAME
              do
                   sleep 1        
                   ext=`date "+%Y%m%d%H%M%S"`
                   TgtFileName=${File_Pattern}${ext}.EXP
                   echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} from Split file $FNAME \n"

#                  DtTime=`head -1 $FNAME|cut -c9-22`
                   var_sec=$(( $var_sec + 1 ))
                           
                       if [ $var_sec -lt 10 ]; then
                            sec=0${var_sec}
                       else
                            sec=$var_sec
                       fi
                  
                   DtTime=`date "+%Y%m%d%H%M"`
                   DtTime=${DtTime}${sec}
                   
                   Ln_seq_no=1
                   Msg_seq_no=0
                   Header="     ${Ln_seq_no}FH${DtTime}            ${Msg_seq_no}"

                   rec_length=`echo "$Header"|wc -c`

                       while [ $rec_length -lt 632 ]
                       do
                             Header="${Header} "
                             rec_length=$(( $rec_length + 1 ))
                       done
     
                   Header="${Header}     ${Msg_seq_no}     ${Ln_seq_no}"

                   echo "$Header" > ${TgtDir}/${TgtFileName}


                   oIFS=$IFS
                   IFS='\n'

                   while read LINE
                   do

                        HdrIdnt=`echo "$LINE"|cut -c7-8|tr -d ' '`

                        if [ "$HdrIdnt" = "TH" ]; then
                           Msg_seq_no=$(( $Msg_seq_no + 1 ))

                                if [ $Msg_seq_no -lt 10 ]; then
                                      Msg_seq_val="     $Msg_seq_no"
                                elif [ $Msg_seq_no -gt 9 ] && [ $Msg_seq_no -lt 100 ]; then
                                      Msg_seq_val="    $Msg_seq_no"             
                                elif [ $Msg_seq_no -gt 99 ] && [ $Msg_seq_no -lt 1000 ]; then
                                      Msg_seq_val="   $Msg_seq_no"
                                elif [ $Msg_seq_no -gt 999 ] && [ $Msg_seq_no -lt 10000 ]; then
                                      Msg_seq_val="  $Msg_seq_no"
                                elif [ $Msg_seq_no -gt 9999 ] && [ $Msg_seq_no -lt 100000 ]; then
                                      Msg_seq_val=" $Msg_seq_no"
                                else
                                      Msg_seq_val="$Msg_seq_no"
                                fi

                        fi

                        Ln_seq_no=$(( $Ln_seq_no + 1 ))

                        if [ $Ln_seq_no -lt 10 ]; then
                             Ln_seq_val="     $Ln_seq_no"
                        elif [ $Ln_seq_no -gt 9 ] && [ $Ln_seq_no -lt 100 ]; then
                             Ln_seq_val="    $Ln_seq_no"             
                        elif [ $Ln_seq_no -gt 99 ] && [ $Ln_seq_no -lt 1000 ]; then
                             Ln_seq_val="   $Ln_seq_no"
                        elif [ $Ln_seq_no -gt 999 ] && [ $Ln_seq_no -lt 10000 ]; then
                             Ln_seq_val="  $Ln_seq_no"
                        elif [ $Ln_seq_no -gt 9999 ] && [ $Ln_seq_no -lt 100000 ]; then
                             Ln_seq_val=" $Ln_seq_no"
                        else
                             Ln_seq_val="$Ln_seq_no"
                        fi
   
                        part0=`echo "$LINE"|cut -c7-8`
                        part1=`echo "$LINE"|cut -c23-29`
                        part2=`echo "$LINE"|cut -c36-631`
                        rec="${Ln_seq_val}${part0}${DtTime}${part1}${Msg_seq_val}${part2}${Msg_seq_val}${Ln_seq_val}"
                        echo "$rec" >> ${TgtDir}/${TgtFileName}

                   done < $FNAME

                   IFS=$oIFS



                   Ln_seq_no=$(( $Ln_seq_no + 1 ))

                   if [ $Ln_seq_no -lt 10 ]; then
	                  Ln_seq_val="     $Ln_seq_no"
                   elif [ $Ln_seq_no -gt 9 ] && [ $Ln_seq_no -lt 100 ]; then
	                  Ln_seq_val="    $Ln_seq_no"             
                   elif [ $Ln_seq_no -gt 99 ] && [ $Ln_seq_no -lt 1000 ]; then
	                  Ln_seq_val="   $Ln_seq_no"
                   elif [ $Ln_seq_no -gt 999 ] && [ $Ln_seq_no -lt 10000 ]; then
	                  Ln_seq_val="  $Ln_seq_no"
                   elif [ $Ln_seq_no -gt 9999 ] && [ $Ln_seq_no -lt 100000 ]; then
	                  Ln_seq_val=" $Ln_seq_no"
                   else
	                  Ln_seq_val="$Ln_seq_no"
                   fi

                   Footer="${Ln_seq_val}FF${DtTime}       ${Msg_seq_val}"

                   rec_length=`echo "$Footer"|wc -c`

                   while [ $rec_length -lt 632 ]
                   do
                        Footer="${Footer} "
                        rec_length=$(( $rec_length + 1 ))
                   done
     
                   Footer="${Footer}${Msg_seq_val}${Ln_seq_val}"
                   echo "$Footer" >> ${TgtDir}/${TgtFileName}
                   TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
                   echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
                   echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog}
                   In_FileName=`echo "$FNAME"|sed 's/.*\///'`
                   echo "AUDIT_LOG~${In_FileName}~${TgtFileName}"


          done < ${TgtDir}/${SpltFileLstName}


      else
          echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} \n"
          DtTime=`date "+%Y%m%d%H%M%S"`    
          TgtFileName="${File_Pattern}${DtTime}.EXP"
          Ln_seq_no=1
          Msg_seq_no=0         
          DfltRec="${DtTime}            ${Msg_seq_no}"

          rec_length=`echo "$DfltRec"|wc -c`

             while [ $rec_length -lt 624 ]
             do
                   DfltRec="${DfltRec} "
                   rec_length=$(( $rec_length + 1 ))
             done
          
          Header="     ${Ln_seq_no}FH${DfltRec}     ${Msg_seq_no}     ${Ln_seq_no}"
          echo "$Header" >  ${TgtDir}/${TgtFileName}        
         
          Ln_seq_no=2
          Footer="     ${Ln_seq_no}FF${DfltRec}     ${Msg_seq_no}     ${Ln_seq_no}"

          echo "$Footer" >> ${TgtDir}/${TgtFileName}
          TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
          echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
          echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog} 
        
      fi      

elif [ "$Int_Val" = "I004" ]; then

     if [ -s ${TgtDir}/${SpltFileLstName} ]; then
          ext=`date "+%Y%m%d%H%M%S"`
          

          while read FNAME
          do
      
              echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} from Split file $FNAME \n"
              TgtFileName=${File_Pattern}_${ext}.TXT
              sleep 1
              ext=`date "+%Y%m%d%H%M%S"`
              DtTime=`head -1 $FNAME|cut -c8-21`
              DtTimeCnct=`echo "$DtTime"|tr -d ' :'`

              header="TRNH 1${DtTimeCnct} FFL N ${DtTime} ORD MARC HOST         0         0         0         0         0         0         0"

              echo "$header" > ${TgtDir}/${TgtFileName}
              cat $FNAME >> ${TgtDir}/${TgtFileName}
              RcrdCnt=0
              MsgCnt=0
              Total_Rec_Cnt=0
              Total_Msg_Cnt=0
                  while read LINE
                  do

                       TrlrInd=`echo "$LINE"|cut -c1-4`

                       if [ "$TrlrInd" = "ENDT" ]; then
                             RcrdCnt=`echo "$LINE"|cut -c27-36|tr -d ' '`
                             MsgCnt=`echo "$LINE"|cut -c37-46|tr -d ' '`
                             Total_Rec_Cnt=$(( $Total_Rec_Cnt + $RcrdCnt ))
                             Total_Msg_Cnt=$(( $Total_Msg_Cnt + $MsgCnt ))
                       fi            

                       if [ "$?" != 0 ]; then
                             echo "unable to copy source file $LINE content to ${TgtDir}/${TgtFileName}"
                             rm -f ${TgtDir}/${SrcFileLstName}
                             rm -f ${TgtDir}/${TgtFileName}_Temp
                             exit 2;
                       fi
               
                  done < $FNAME



              Rec_Cnt_Length=`echo "$Total_Rec_Cnt"|wc -c`
              Rec_Cnt_Space=$(( 11 - $Rec_Cnt_Length ))

              i=0

                  while [ $i -lt $Rec_Cnt_Space ]
                  do
                       Total_Rec_Cnt=" ${Total_Rec_Cnt}"
                       i=$(( $i + 1 ))
                  done
      
              i=0
              Msg_Cnt_Length=`echo "$Total_Msg_Cnt"|wc -c`
              Msg_Cnt_Space=$(( 11 - $Msg_Cnt_Length ))

                  while [ $i -lt $Msg_Cnt_Space ]
                  do
                       Total_Msg_Cnt=" ${Total_Msg_Cnt}"
                       i=$(( $i + 1 ))
                  done

              echo "Total_Rec_Cnt =$Total_Rec_Cnt and Total_Msg_Cnt=$Total_Msg_Cnt"

              Trailer="TRLR 1${DtTimeCnct}${Total_Rec_Cnt}${Total_Msg_Cnt}         "
              echo "$Trailer" >> ${TgtDir}/${TgtFileName}
              TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
              echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
              echo "${TgtDir}/${TgtFileName}" >> ${Log_Dir}/${LastRunLog}
              In_FileName=`echo "$FNAME"|sed 's/.*\///'`
              echo "AUDIT_LOG~${In_FileName}~${TgtFileName}"
    
          done < ${TgtDir}/${SpltFileLstName}

     else
          echo "No source files are available for processing"
          exit 1
     fi

elif [ "$Int_Val" = "I005" ]; then

     if [ -s ${TgtDir}/${SpltFileLstName} ]; then
          
          while read FNAME
          do
              ext=`date "+%Y%m%d%H%M%S"`
              echo `date`": Starting to create Target file ${TgtDir}/${TgtFileName} from Split file $FNAME \n"
              TgtFileName=${File_Pattern}.${ext}
              sleep 1
              cat $FNAME >> ${TgtDir}/${TgtFileName}
              TgtFileSize=`ls -l ${TgtDir}/${TgtFileName}|awk '{print $5}'`
              echo `date`": completed creating Target file ${TgtDir}/${TgtFileName} and its size is $TgtFileSize \n"
              In_FileName=`echo "$FNAME"|sed 's/.*\///'`
              echo "AUDIT_LOG~${In_FileName}~${TgtFileName}"

          done < ${TgtDir}/${SpltFileLstName}

     else
          echo "No source files are available for processing"
          exit 1
     fi

fi 


    echo `date`
    echo "File Creation completed"

echo "STATUS=SUCCESS" >> ${Log_Dir}/${log_file}



########################################################################################
## Delete source files after successful transfer
########################################################################################


	while read LINE
	do
	   rm -f $LINE
          
              if [ "$?" != 0 ]; then
                 echo "unable to delete source file $LINE"
                 exit 2;
              fi
       
	done < ${TgtDir}/${SrcFileLstName}







###############################################################################################################################################
## delete files created as part of previous failure which are older than 5 days
###############################################################################################################################################
find ${Log_Dir} -type f -name "lg_${prefix}*.log"  -mtime +10 -print|xargs rm -f
find ${TgtDir} -type f -name "Arch_${File_Pattern}_*" -mtime +15 -print|xargs rm -f


exit 0






