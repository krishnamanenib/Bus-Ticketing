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

ScriptDir=`dirname $0`
ext=`date "+%Y%m%d%H%M%S"`


email_id="!!osb.email.list.icc.recon!!"
email_id_1="kiran.kumar@nike.com"

usage () {
echo " "
echo "\nMissing required parameters: "
echo "Usage: ${ME} [option]

Where the required parameter is:
   -P <Property File Path and Name> e.g. $GSPROPERTIES/Invoice.property
  and optional parameters are:
   -S <Recon Start date time format YYYYMMDDHH24MISS> e.g 20120506020000
   -E <Recon End date time format YYYYMMDDHH24MISS> e.g 20120507020000"

echo " "
   exit 2
}

Total_Parm=$#
echo "Total_Parameters :$Total_Parm"

if [ "$Total_Parm" -ne 2 ]  && [ "$Total_Parm" -ne 6 ]; then
   usage
fi

while [ $# != 0 ]
   do case "$1" in
      -p|-P)
	 shift
	Property_File=$1
	 ;;
      -s|-S)
	 shift
	 SDate=$1
	 ;;
      -e|-E)
	 shift
	 EDate=$1
	 ;;
      -*|*)
         echo "Illegal option $1"
         usage
         ;;
       esac
      shift
   done



################################################################################################
#### Function to get last day of previous month
################################################################################################

Get_LstDayofPrevMonth() {
          CURMTH=`date "+%m"`
          CURYR=`date "+%Y"`

            if [ $CURMTH -eq 1 ]; then
                 PRVMTH=12
                 PRVYR=$(( $CURYR - 1 ))
            else
                 PRVMTH=$(( $CURMTH - 1 ))
                 PRVYR=$CURYR
            fi


         LASTDY=`cal $PRVMTH $PRVYR | egrep "28|29|30|31" |tail -1 |awk '{print $NF}'`

         PrvMonthDate=${PRVYR}${PRVMTH}${LASTDY}

}

################################################################################################
#### Function to get back date time from current date time minus number of hours.
#### Input to the function is number of hours
#### example if current data time is 10/10/2012 13:01:35 and input parameter is 4 then the output
#### of this function is 20121010 110000
################################################################################################

Get_BackDateVal() {

Flag=$1
In_Days=$2
In_Hours=$3

C_Day=`date "+%d"`
C_Hour=`date "+%H"`
C_Year=`date "+%Y"`
C_Month=`date "+%m"`

if [ "$Flag" = "D" ]; then

     T_Hours=$(( $In_Hours + $(( $In_Days * 24 )) ))
     x=$(( $T_Hours - $C_Hour ))

               if [ "$x" -lt "0" ]; then
                    Days=0
                    Hours=$(( $C_Hour - $T_Hours ))
                else
                    Days=1
                    Days=$(( $Days + $(( $x / 24 )) ))
                    Hours=$(( 24 - $(( $x % 24 )) ))
               fi

               if [ $Hours -lt 10 ]; then
                   Hours=0${Hours}
               fi

            y=$(( $C_Day - $Days ))

               if [ $y -lt 0 ]; then
                    Get_LstDayofPrevMonth
                    Return_Dt=$(( $PrvMonthDate + $y ))
                    Return_Tm=${Hours}0000
               else
                      if [ $y -lt 10 ]; then
                          DD=0${y}
                      else
                          DD=$y
                      fi 


                    Return_Dt=${C_Year}${C_Month}${DD}
                    Return_Tm=${Hours}0000
               fi

elif [ "$Flag" = "S" ]; then

     x=$(( $C_Day - $In_Days ))

               if [ $In_Hours -lt 10 ]; then
                   Hours=0${In_Hours}
               else
                   Hours=$In_Hours
               fi

               if [ $x -lt 0 ]; then
                    Get_LstDayofPrevMonth
                    Return_Dt=$(( $PrvMonthDate + $x ))
                    Return_Tm=${Hours}0000
               else
                      if [ $x -lt 10 ]; then
                          DD=0${x}
                      else
                          DD=$x
                      fi 
                    Return_Dt=${C_Year}${C_Month}${DD}
                    Return_Tm=${Hours}0000
               fi
fi
}


AuditLog_Unzip() {

###########################################################################################################
#### Handling zipped Audit logs
###########################################################################################################

AuditLogPath=$1
AuditLogFilePattern=$2
AuditLogFilePattern_Uzip=${AuditLogFilePattern}_Uzip

ls -ltr ${AuditLogPath}/*${AuditLogFilePattern}*gz|awk '{print $9}' > ${LogDir}/${AuditLogFilePattern_Uzip}


  if [ -s "${LogDir}/${AuditLogFilePattern_Uzip}" ]; then

         while read FileNm
         do

            TempAuditLogFileName=$(basename $FileNm)
            TempAuditLogFileName=`echo "$TempAuditLogFileName"|sed -n "s/\.gz$//p"`
            TempAuditLogFileName=`echo ${TempAuditLogFileName}_GZ`

            echo "Renaming zipped file $FileNm to ${TempAuditLogFileName}.gz"

            mv -f $FileNm ${AuditLogPath}/${TempAuditLogFileName}.gz

            if [ "$?" -ne "0" ]; then
               echo "unable to rename file ${FileNm} to ${TempAuditLogFileName}.gz"
               exit 2
            fi

            echo "unzipping file ${TempAuditLogFileName}.gz to $TempAuditLogFileName"

            gunzip ${AuditLogPath}/${TempAuditLogFileName}.gz

            if [ "$?" -ne "0" ]; then
               echo "unable to unzip file $FileNm"
               exit 2
            fi



         done < ${LogDir}/${AuditLogFilePattern_Uzip}
  else
        echo "No zipped file found in path $AuditLogPath with pattern $AuditLogFilePattern"
  fi


rm -f ${LogDir}/${AuditLogFilePattern_Uzip}

###########################################################################################################



}

AuditLog_zip() {

###########################################################################################################
#### Handling zipped Audit logs
###########################################################################################################

AuditLogPath=$1
AuditLogFilePattern=$2
AuditLogFilePattern_zip=${AuditLogFilePattern}_zip

ls -ltr ${AuditLogPath}/*${AuditLogFilePattern}*_GZ|awk '{print $9}' > ${LogDir}/${AuditLogFilePattern_zip}


  if [ -s "${LogDir}/${AuditLogFilePattern_zip}" ]; then

         while read FileNm
         do

            TempAuditLogFileName=$(basename $FileNm)
            TempAuditLogFileName=`echo "$TempAuditLogFileName"|sed -n "s/\_GZ.*//p"`

            echo "zipping file $FileNm"

            gzip $FileNm

            if [ "$?" -ne "0" ]; then
               echo "unable to zip file $FileNm"
               exit 2
            fi

            echo "Renaming zipped file ${FileNm}.gz to ${AuditLogPath}/${TempAuditLogFileName}.gz"
 
            mv -f ${FileNm}.gz ${AuditLogPath}/${TempAuditLogFileName}.gz

            if [ "$?" -ne "0" ]; then
               echo "unable to rename file ${FileNm}.gz to ${TempAuditLogFileName}.gz"
               exit 2
            fi


         done < ${LogDir}/${AuditLogFilePattern_zip}
  else
        echo "No file found to zip in path $AuditLogPath with pattern ${AuditLogFilePattern}_GZ"
  fi


rm -f ${LogDir}/${AuditLogFilePattern_zip}

###########################################################################################################

}


#############################################################################################################################
#### Get Message log details from Audit logs Between start and end time 
#### six input parameters need to be passed, 1. Audit log path 2.Audit log file pattern 3.Start Date 4.Start Time 5.End Date 
####   and 6.End Time
#############################################################################################################################

GetMsg_CrtBtwStrtEndTime() {

AuditFileListName="Adt_File_List_${File_Pattern}"
Exit_AuditFileLogPath="$LogFilePath_1"
Exit_AuditFileLogPattern="$LogFilePattern_1"
Exit_AuditFileListName="Exit_Adt_File_List_${File_Pattern}"
StgFileName="ConAdtFile_${File_Pattern}.log"
ExitAuditLogFile="ExitAdtFile_${File_Pattern}.log"
AuditFileLogPath=$1
AuditFileLogPattern=$2
StartDt=$3
StartHR=$4
EndDt=$5
EndHR=$6
ext=`date "+%Y%m%d%H%M%S"`

rm -f $StgFileName
rm -f $ExitAuditLogFile

   if [ "$InterfaceType" = "OS" ]; then

         ls -ltr ${Exit_AuditFileLogPath}/*${Exit_AuditFileLogPattern}*|awk '{print $9}' > ${LogDir}/${Exit_AuditFileListName}
         echo "List of Exit Log files :"
         cat ${Exit_AuditFileListName} >> ${LogDir}/${log_file}

         if [ ! -s "${LogDir}/${Exit_AuditFileListName}" ]; then
              echo "Exit Audit files with file pattern ${Exit_AuditFileLogPattern} do not exist for Order Status"
              exit 2
         fi

         echo `date`": starting to read Exit Audit logs from file list and consolidate into one single file"

         while read EFNAME
         do
            Exit_SFlag=N
            Exit_EFlag=N

            echo "Searching for StartDate $StartDt in Exit Audit log file $EFNAME"
            Exit_DF=0
            Exit_SDt="$StartDt"
            Exit_YY=`echo "$StartDt"|cut -c7-10`
            Exit_MM=`echo "$StartDt"|cut -c4-5`
            Exit_DD=`echo "$StartDt"|cut -c1-2`
            Exit_Init_StartDt="${Exit_YY}${Exit_MM}${Exit_DD}"
            Exit_CrntDate="${Exit_YY}${Exit_MM}${Exit_DD}"

            Exit_DB=0
            Exit_EDt="$EndDt"
            Exit_YY=`echo "$Exit_EDt"|cut -c7-10`
            Exit_MM=`echo "$Exit_EDt"|cut -c4-5`
            Exit_DD=`echo "$Exit_EDt"|cut -c1-2`
            Exit_Crnt_EndDt="${Exit_YY}${Exit_MM}${Exit_DD}"
            Exit_EDt=`date -d "${Exit_Crnt_EndDt} next day" +%d-%m-%Y`
            Exit_YY=`echo "$Exit_EDt"|cut -c7-10`
            Exit_MM=`echo "$Exit_EDt"|cut -c4-5`
            Exit_DD=`echo "$Exit_EDt"|cut -c1-2`
            Exit_Crnt_EndDt="${Exit_YY}${Exit_MM}${Exit_DD}"


            while [ "$Exit_SFlag" = "N" ]
            do

                    cnt=`grep "$Exit_SDt" ${EFNAME}|wc -l`

                    if [ "$Exit_CrntDate" -gt "$Exit_Crnt_EndDt" ]; then
                          echo "No Messages generated for this interface from $StartDt and $Exit_EDt in Exit Audit Log file ${EFNAME}"
                          Exit_StrtLnNo=0
                          break                    
                    fi

                    if [ $cnt -gt 0 ]; then
                         Exit_StrtLnNo=`grep -n "$Exit_SDt" ${EFNAME}|head -1|cut -d":" -f1`
                         Exit_SFlag=Y
                         break
                    else
                         Exit_SDt=`date -d "${Exit_CrntDate} next day" +%d-%m-%Y`
                         Exit_SYear=`echo "$Exit_SDt"|cut -c7-10`
                         Exit_SMonth=`echo "$Exit_SDt"|cut -c4-5`
                         Exit_SDay=`echo "$Exit_SDt"|cut -c1-2`
                         Exit_CrntDate="${Exit_SYear}${Exit_SMonth}${Exit_SDay}"
                         echo "Current start date in Exit log is $Exit_CrntDate"

                    fi

            done

            echo "Searching for EndDate $Exit_EDt in Exit Audit log file $EFNAME"
            
            while [ "$Exit_EFlag" = "N" ]
            do                               
                    cnt=`grep "$Exit_EDt" ${EFNAME}|wc -l`


                    if [ $cnt -gt 0 ]; then
                          Exit_EndLnNo=`grep -n "$Exit_EDt" ${EFNAME}|tail -1|cut -d":" -f1`
                          Exit_EndLnNo=$(( $Exit_EndLnNo + 8 ))
                          Exit_EFlag=Y
                          break
                    else
                          Exit_EDt=`date -d "$Exit_Crnt_EndDt next day" +%d-%m-%Y`
                          Exit_DB=$(( $Exit_DB + 1 ))
                          Exit_EYear=`echo "$Exit_EDt"|cut -c7-10`
                          Exit_EMonth=`echo "$Exit_EDt"|cut -c4-5`
                          Exit_EDay=`echo "$Exit_EDt"|cut -c1-2`
                          Exit_Crnt_EndDt="${Exit_EYear}${Exit_EMonth}${Exit_EDay}"
                          echo "Current Exit date is $Exit_EDt"


                              if [ $Exit_DB -gt 2 ]; then
                                   echo "No Messages generated for this interface between ${EndDt} and ${Exit_EDt} in Exit Audit Log file ${FNAME}"
                                   break
                              fi
                    fi

            done

               if [ "$Exit_SFlag" = "Y" ] && [ "$Exit_EFlag" = "Y" ]; then
                     echo "sed -n ${Exit_StrtLnNo},${Exit_EndLnNo}p $EFNAME"
                     sed -n "$Exit_StrtLnNo","$Exit_EndLnNo"p $EFNAME >> ${LogDir}/${ExitAuditLogFile}_Temp
               elif [ "$Exit_SFlag" = "Y" ] && [ "$Exit_EFlag" = "N" ]; then
                     Exit_EndLnNo=`wc -l  < $EFNAME`
                     sed -n "$Exit_StrtLnNo","$Exit_EndLnNo"p $EFNAME >> ${LogDir}/${ExitAuditLogFile}_Temp
               elif [ "$Exit_SFlag" = "N" ] && [ "$Exit_EFlag" = "Y" ]; then
                     Exit_StrtLnNo=1
                     sed -n "$Exit_StrtLnNo","$Exit_EndLnNo"p $EFNAME >> ${LogDir}/${ExitAuditLogFile}_Temp
               fi
 
               echo -e "For File $EFNAME Start line is: $Exit_StrtLnNo and End Line is: $Exit_EndLnNo \n"

         done < ${LogDir}/${Exit_AuditFileListName}

         grep -i -A 1 "Proxy Flow" ${LogDir}/${ExitAuditLogFile}_Temp > ${LogDir}/${ExitAuditLogFile}

         rm -f ${LogDir}/${ExitAuditLogFile}_Temp

   fi

ls -ltr ${AuditFileLogPath}/*${AuditFileLogPattern}*|awk '{print $9}' > ${LogDir}/${AuditFileListName}

echo "List of Audit files :"
cat ${AuditFileListName} >> ${LogDir}/${log_file}

   if [ ! -s "${LogDir}/${AuditFileListName}" ]; then
       echo "Audit files with file pattern ${AuditFileLogPattern} do not exist"
       exit 2
   fi

###########################################################################################################################
### starting to read Audit logs from file list and consolidate into one single file
###########################################################################################################################

echo `date`": starting to read Audit logs from file list and consolidate into one single file"
         while read FNAME
         do
            SFlag=N
            EFlag=N


            echo "Audit log file name is $FNAME"
            MsgCnt=`zgrep -c '<Record>' ${FNAME}`


               if [ $? -ne 0 ] && [ -s "$FNAME" ]; then
                  echo "String <Record> not found in Audit file $FNAME"
                  exit 2
               fi
 
                    j=`echo "$StartHR"|cut -c1`

                    if [ "$j" -eq 0 ]; then
                         i=`echo "$StartHR"|cut -c2`
                    else
                    i=$StartHR
                    fi

                   
                    if [ "$i" -lt 10 ]; then                   
                          StrtDtTime="${StartDt} 0${i}"
                    else
                    StrtDtTime="${StartDt} ${i}"
                    fi

                         echo "Searching for StartDate $StartDt in file $FNAME"
                         DF=0
                         SDt="$StartDt"
                         SDtTm="$StrtDtTime"
                         YY=`echo "$StartDt"|cut -c7-10`
                         MM=`echo "$StartDt"|cut -c4-5`
                         DD=`echo "$StartDt"|cut -c1-2`
                         Init_StartDt="${YY}${MM}${DD}"
                         

                         while [ "$SFlag" = "N" ]
                         do
                                                                                        

                                cnt=`zgrep "$SDt" ${FNAME}|wc -l`

                                if [ $cnt -gt 0 ]; then
                                                                
                             
                                      cnt=`zgrep "$SDtTm" ${FNAME}|wc -l`
                         
                                if [ $cnt -gt 0 ]; then
                                             StrtLnNo=`grep -n "$SDtTm" ${FNAME}|head -1|cut -d":" -f1`
                                     SFlag=Y
                                     break
                                else
                                     i=$(( $i + 1 ))
                                     if [ "$i" -lt 10 ]; then
                                                   SDtTm="${SDt} 0${i}"
                                     else
                                                   SDtTm="${SDt} ${i}"
                                     fi
                             
                                fi

                                if [ $i -gt 23 ]; then
                                          i=0
                                          SYear=`echo "$SDt"|cut -c7-10`
                                          SMonth=`echo "$SDt"|cut -c4-5`
                                          SDay=`echo "$SDt"|cut -c1-2`
                                          CrntDate="${SYear}${SMonth}${SDay}"
                                          SDt=`date -d "$CrntDate next day" +%d-%m-%Y`
                                          SDtTm="${SDt} 0${i}"        
                                fi

                                else
                                      DF=$(( $DF + 1 ))
                                      i=0
                                      SYear=`echo "$SDt"|cut -c7-10`
                                      SMonth=`echo "$SDt"|cut -c4-5`
                                      SDay=`echo "$SDt"|cut -c1-2`
                                      CrntDate="${SYear}${SMonth}${SDay}"
                                      echo "current date is $CrntDate"
                                      SDt=`date -d "${CrntDate} next day" +%d-%m-%Y`
                                      SDtTm="${SDt} 0${i}"

                                      if [ $DF -gt 10 ]; then
                                         echo "No Messages generated for this interface from $StartDt $StartHR and $SDt $StartHR plus 14 days in file ${FNAME}"
                                         break
                                fi
                                fi
                         done
                     


                    j=`echo "$EndHR"|cut -c1`

                    if [ "$j" -eq 0 ]; then
                         i=`echo "$EndHR"|cut -c2`
                    else
                         i=$EndHR
                    fi


                    if [ "$i" -lt 10 ]; then
                         EndDtTime="${EndDt} 0${i}"
                    else
                    EndDtTime="${EndDt} ${i}"
                    fi


                         echo "Searching for EndDate $EndDt in file $FNAME"
                         DB=0
                         EDt="$EndDt"
                         EDtTm="$EndDtTime"

                         while [ "$EFlag" = "N" ]
                         do                               
                                cnt=`zgrep "$EDt" ${FNAME}|wc -l`

                                YY=`echo "$EDt"|cut -c7-10`
                                MM=`echo "$EDt"|cut -c4-5`
                                DD=`echo "$EDt"|cut -c1-2`
                                Crnt_EndDt="${YY}${MM}${DD}"

                                echo "current end date ${Crnt_EndDt} is and Initial start date is ${Init_StartDt}"

                                if [ "$Crnt_EndDt" -lt "$Init_StartDt" ]; then
                                    StrtLnNo=0
                                    EndLnNo=0
                                    break
                                fi


                    if [ $cnt -gt 0 ]; then
                                                                    
                         
                                     cnt=`zgrep "$EDtTm" ${FNAME}|wc -l`
                         
                                if [ $cnt -gt 0 ]; then
                                          EndLnNo=`grep -n "$EDtTm" ${FNAME}|tail -1|cut -d":" -f1`
                                          EndLnNo=$(( $EndLnNo + 8 ))
                                     EFlag=Y
                                     break
                                else
                                     i=$(( $i - 1 ))
                                     if [ "$i" -lt 10 ]; then
                                               EDtTm="${EDt} 0${i}"
                                     else
                                               EDtTm="${EDt} ${i}"
                                     fi                             
                                fi

                                if [ $i -lt 1 ]; then
                                          i=23
                                          EYear=`echo "$EDt"|cut -c7-10`
                                          EMonth=`echo "$EDt"|cut -c4-5`
                                          EDay=`echo "$EDt"|cut -c1-2`
                                          CrntDate="${EYear}${EMonth}${EDay}"
                                          EDt=`date -d "${CrntDate} 1 day ago" +%d-%m-%Y`
                                          EDtTm="${EDt} ${i}"                     
                                fi
                                else
                                     DB=$(( $DB + 1 ))
                                     i=23
                                     EYear=`echo "$EDt"|cut -c7-10`
                                     EMonth=`echo "$EDt"|cut -c4-5`
                                     EDay=`echo "$EDt"|cut -c1-2`
                                     CrntDate="${EYear}${EMonth}${EDay}"
                                     echo "current date is $CrntDate"
                                     EDt=`date -d "$CrntDate 1 day ago" +%d-%m-%Y`
                                     EDtTm="${EDt} ${i}"

                                      if [ $DB -gt 10 ]; then
                                         echo "No Messages generated for this interface between ${EndDt} ${EndHR} and ${EDt} ${EndHR} in file ${FNAME}"
                                         break
                                fi
                                fi
                         done                       



            echo "StartFlag = $SFlag and EndFlag = $EFlag for File $FNAME"

               if [ "$SFlag" = "Y" ] && [ "$EFlag" = "Y" ]; then
                     echo "sed -n ${StrtLnNo},${EndLnNo}p $FNAME"
                     sed -n "$StrtLnNo","$EndLnNo"p $FNAME >> $StgFileName

                               if [ "$InterfaceType" = "SR" ] || [ "$InterfaceType" = "SC" ]; then
                                    ELnNo=`wc -l < $FNAME`
                                    sed -n "$StrtLnNo","$ELnNo"p $FNAME|grep -iG -A 5 "Proxy Flow E[xr].*" >> ${LogDir}/${ExitAuditLogFile}
                               fi

               elif [ "$SFlag" = "Y" ] && [ "$EFlag" = "N" ]; then
                    EndLnNo=`wc -l  < $FNAME`
                    echo "sed -n ${StrtLnNo},${EndLnNo}p $FNAME"
                    sed -n "$StrtLnNo","$EndLnNo"p $FNAME >> $StgFileName

                               if [ "$InterfaceType" = "SR" ] || [ "$InterfaceType" = "SC" ]; then
                                    sed -n "$StrtLnNo","$EndLnNo"p $FNAME|grep -iG -A 5 "Proxy Flow E[xr].*" >> ${LogDir}/${ExitAuditLogFile}
                               fi

               elif [ "$SFlag" = "N" ] && [ "$EFlag" = "Y" ]; then
                    StrtLnNo=1
                    echo "sed -n ${StrtLnNo},${EndLnNo}p $FNAME"
                    sed -n "$StrtLnNo","$EndLnNo"p $FNAME >> $StgFileName

                               if [ "$InterfaceType" = "SR" ] || [ "$InterfaceType" = "SC" ]; then
                                    ELnNo=`wc -l < $FNAME`
                                    sed -n "$StrtLnNo","$ELnNo"p $FNAME|grep -iG -A 5 "Proxy Flow E[xr].*" >> ${LogDir}/${ExitAuditLogFile}
                               fi

               fi

  
            echo -e "For File $FNAME Start line is: $StrtLnNo and End Line is: $EndLnNo \n"



         done < ${LogDir}/${AuditFileListName}

if [ -s "$StgFileName" ]; then
echo `date`": Completed creating one single file, with list of messages from Audit logs for date range ${StartDt} ${StartHR} to ${EndDt} ${EndHR}"
else
echo `date`"No messages found within the given time range StartTime:$StartDt $StartHR and  EndTime:$EndDt $EndHR"
exit 0
fi

}


Chk_ExitLog() {


Exit_AuditFileLogPath=$1
Exit_AuditFileLogPattern=$2
In_StgFileName=$3
File_MsgEntryLnNo="MsgEntryLnNo_${File_Pattern}.list"
RcnFileName_0="Rcn_${File_Pattern}_${ext}_L1.log"
RcnFileName="Rcn_${File_Pattern}_${ext}_L2.csv"

File_MsgStatuslist="MsgStatFilelst_${File_Pattern}.lst"

grep -in '<aud:BusinessMessage>Proxy flow Entry</aud:BusinessMessage>' $In_StgFileName|cut -d":" -f1 > ${File_MsgEntryLnNo}
Total_MsgEntry=`wc -l ${File_MsgEntryLnNo}|cut -d' ' -f1`

rm -f $RcnFileName
rm -f $RcnFileName_0
#printf "%-60s%-60s%-30s%-50s%-20s \n" "Service Name" "Message ID" "Business Key" "Business Value" "STATUS" > ${RcnFileName}
var_Success=0
var_Error=0
var_Unknown=0
RptHdrItrn=0
echo `date`": starting to create reconciliation log files"
echo "Total message entries found are $Total_MsgEntry"


               while read LINE
               do
                    k=$LINE
                    i=0
#                    echo `date`"Reading Message entry"                    

                    while [ $i -le 4 ]
                    do
                        i=$(( $i + 1 ))
                        k=$(( $k + 1 ))
                        val=`sed -n "$k"p $In_StgFileName|cut -d">" -f1|tr [a-z] [A-Z]|tr -d ' '`

                           if [ "$InterfaceType" = "SR" ]; then

                                  if [ "$RptHdrItrn" -eq "0" ]; then
#                                        echo "Starting to create Reconciliation summary report"
                                        echo "Service_Name,Message_ID,Business_Key,Business Value,Fusion_STATUS,FileName,ScriptMsgStatus" > ${RcnFileName}
                                        RptHdrItrn=$(( $RptHdrItrn + 1 ))
                                        Menlo_PrvOutFileNm=''
                                        Menlo_CrntOutFileNm=''
                                        BRD_PrvOutFileNm=''
                                        BRD_CrntOutFileNm=''
                                        MenloOutFileLst="Menlo_${File_Pattern}_${ext}_FileList"
                                        BRDOutFileLst="BRD_${File_Pattern}_${ext}_FileList"
                                  fi  

                                  if [ "$val" =  "<AUD:MESSAGEID" ]; then
                                        MsgID=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1`
                                  elif [ "$val" = "<AUD:SERVICENAME" ]; then
                                        SrvNm=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1|tr "," " "`
                                  elif [ "$val" = "<AUD:BUSINESSKEY" ]; then
                                        BKey=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1`
                                  elif [ "$val" = "<AUD:BUSINESSVALUE" ]; then
                                        BVal=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1`
                                  fi

                           elif [ "$InterfaceType" = "SC" ]; then

                                  if [ "$RptHdrItrn" -eq "0" ]; then
#                                        echo "Starting to create Reconciliation summary report"
                                        echo "Service_Name,Message_ID,Fusion_Input_File,Business_Key,Business_Value,Fusion_STATUS" > ${RcnFileName}
                                        RptHdrItrn=$(( $RptHdrItrn + 1 ))
                                  fi  

                                  if [ "$val" =  "<AUD:MESSAGEID" ]; then
                                        MsgID=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1`
                                  elif [ "$val" = "<AUD:SERVICENAME" ]; then
                                        SrvNm=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1|tr "," " "`
                                  elif [ "$val" = "<AUD:BUSINESSKEY" ]; then
                                        BKey=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"|" -f1`
                                  elif [ "$val" = "<AUD:BUSINESSVALUE" ]; then
                                        FusInpFileNm=`sed -n "$k"p $In_StgFileName|cut -d"|" -f2|cut -d"<" -f1`
                                        BVal=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"|" -f1`
                                  fi

                           elif [ "$InterfaceType" = "OS" ]; then

                                  if [ "$RptHdrItrn" -eq "0" ]; then
#                                        echo "Starting to create Reconciliation summary report"
                                        echo "Service_Name,Message_ID,Business_Key,Business_Value,EventName,Fusion_STATUS" > ${RcnFileName}
                                        RptHdrItrn=$(( $RptHdrItrn + 1 ))
                                  fi  

                                  if [ "$val" =  "<AUD:MESSAGEID" ]; then
                                        MsgID=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1`
                                  elif [ "$val" = "<AUD:SERVICENAME" ]; then
                                        SrvNm=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1|tr "," " "`
                                  elif [ "$val" = "<AUD:BUSINESSKEY" ]; then
                                        BKey=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"|" -f1`
                                  elif [ "$val" = "<AUD:BUSINESSVALUE" ]; then
                                        BVal=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1|tr "|" ","`
                                  elif [ "$val" = "<AUD:DIGITALORDERFLAG" ]; then
                                        DOFlag=`sed -n "$k"p $In_StgFileName|cut -d">" -f2|cut -d"<" -f1|tr [a-z] [A-Z]`
                                  fi

                           fi
                    done
                    echo `date`"Message ID :$MsgID"


                    if [ "$InterfaceType" = "SR" ] || [ "$InterfaceType" = "SC" ]; then
                           zgrep -nH "$MsgID" ${LogDir}/${ExitAuditLogFile}|cut -d":" -f1,2|tail -1 > $File_MsgStatuslist
                           STATUS=''
                    elif [ "$InterfaceType" = "OS" ] && [ "$DOFlag" = "Y" ]; then

                            StatVal=`grep -i -m 1 -B 1 "$MsgID" ${LogDir}/${ExitAuditLogFile}|head -1|cut -d">" -f2|cut -d"<" -f1|tr [a-z] [A-Z]`

                            if [ "$StatVal" = "PROXY FLOW EXIT" ]; then
                                  STATUS="SUCCESS"
                            elif [ "$StatVal" = "PROXY FLOW ERROR" ]; then
                                  STATUS="ERROR"
                    else
                                  STATUS="DROPPED"
                    fi

                           echo "${SrvNm},${MsgID},${BKey},${BVal},${STATUS}" >> ${RcnFileName}
                    fi


                    if [ -s "$File_MsgStatuslist" ] && [ "$InterfaceType" != "OS" ]; then

                          cat $File_MsgStatuslist >> ${LogDir}/${log_file}

                          while read LIST
                          do
                               FlNm=`echo $LIST|cut -d":" -f1`
                               LnNo=`echo $LIST|cut -d":" -f2`
                               LnNo=$(( $LnNo - 1 ))
                               BVal_LnNo=$(( $LnNo + 4 ))


                               val=`sed -n "$LnNo"p  $FlNm`
                               stat_val=`echo "$val"|cut -d">" -f2|cut -d"<" -f1|tr [a-z] [A-Z]`



                               if [ "$InterfaceType" = "SR" ]; then

                                       MsgStatus=NA
                                  
                                       if [ "$stat_val" = "PROXY FLOW ENTRY" ]; then
                                             STATUS="DROPPED"
                                             BFileName=NA
                                             echo "${SrvNm},${MsgID},${BKey},${BVal},${STATUS},${BFileName},${MsgStatus}" >> ${RcnFileName}_Temp
                                       elif [ "$stat_val" = "PROXY FLOW EXIT" ]; then
                                             STATUS="SUCCESS"

                                             BFileName=`sed -n "$BVal_LnNo"p $FlNm|cut -d"|" -f2|cut -d"<" -f1`
                                             BM_Value=`echo $BFileName| cut -c1-4`

                                             echo "${SrvNm},${MsgID},${BKey},${BVal},${STATUS},${BFileName}," >> ${RcnFileName}_Temp

                                                  if [ "$BM_Value" = "E850" ]; then
                                                       Menlo_CrntOutFileNm="$BFileName"

                                                              if [ "$Menlo_CrntOutFileNm" != "$Menlo_PrvOutFileNm" ]; then
                                                                    echo "$BFileName" >> $MenloOutFileLst
                                                              fi
                                                       Menlo_PrvOutFileNm="$Menlo_CrntOutFileNm"
                                                  
                                                  else
                                                       BRD_CrntOutFileNm="$BFileName"

                                                              if [ "$BRD_CrntOutFileNm" != "$BRD_PrvOutFileNm" ]; then
                                                                    echo "$BFileName" >> $BRDOutFileLst
                                                              fi

                                                       BRD_PrvOutFileNm="$BRD_CrntOutFileNm"
                                                  fi

                                       elif [ "$stat_val" = "PROXY FLOW ERROR" ]; then
                                             STATUS="ERROR"
                                             BFileName=NA
                                             echo "${SrvNm},${MsgID},${BKey},${BVal},${STATUS},${BFileName},${MsgStatus}" >> ${RcnFileName}_Temp
                                       fi


                                       echo `date`"############################# $MsgID check completed ########################"                                

                               elif [ "$InterfaceType" = "SC" ]; then
                                       if [ "$stat_val" = "PROXY FLOW ENTRY" ]; then
                                             STATUS=""
                                       elif [ "$stat_val" = "PROXY FLOW EXIT" ]; then
                                             STATUS="SUCCESS"
                                             var_Success=$(( $var_Success + 1 ))
                                       elif [ "$stat_val" = "PROXY FLOW ERROR" ]; then
                                             STATUS="ERROR"
                                       fi

                                       if [ -z "$STATUS" ]; then
                                             STATUS='DROPPED'

                                       fi

                                       if [ "$STATUS" != "ENTRY" ]; then
                                             echo "${SrvNm},${MsgID},${FusInpFileNm},${BKey},${BVal},${STATUS}" >> ${RcnFileName}
                                       fi



                                       fi

  

                          done < ${File_MsgStatuslist}

                    else
                               if [ "$InterfaceType" = "SR" ]; then
                                   STATUS='DROPPED'
                                   BFileName='NA'
                                   MsgStatus='NA'
                                   echo "${SrvNm},${MsgID},${BKey},${BVal},${STATUS},${BFileName},${MsgStatus}" >> ${RcnFileName}_Temp

                               elif [ "$InterfaceType" = "SC" ]; then

                                       STATUS='DROPPED'
                                       echo "${SrvNm},${MsgID},${FusInpFileNm},${BKey},${BVal},${STATUS}" >> ${RcnFileName}

                               fi

                               
                    fi

                    


               done < ${File_MsgEntryLnNo}


               if [ "$InterfaceType" = "SR" ]; then

                       MnloArchFileList="MnloArch_${File_Pattern}_${ext}_FileList"
                       BRDArchFileList="BRDArch_${File_Pattern}_${ext}_FileList"
                       ArchDataFile=ArchData_${File_Pattern}_${ext}_FileList

                       if [ -s "$MenloOutFileLst" ]; then

                             FileArchLoc="${FileArchivePath_1}/"

                             while read Fname
                             do
                                ScriptLogPattern=`echo "$LogFilePattern_2"|cut -d"|" -f2`
                                zgrep -iH "$Fname" ${LogFilePath_2}/${ScriptLogPattern}*|cut -d':' -f1|xargs zgrep -i "AUDIT_LOG~Splt_*"|cut -d '~' -f3|xargs -i find ${FileArchLoc} -name {}* -type f -print >> ${MnloArchFileList}_Temp
                             done < ${MenloOutFileLst}

                             if [ -s ${MnloArchFileList}_Temp ]; then

                                    sort -u ${MnloArchFileList}_Temp >> ${MnloArchFileList}
                                    rm -f ${MnloArchFileList}_Temp

                                    while read Line
                                    do               
                                        gunzip $Line &> /dev/null

                                        if [ "$?" -eq 0 ]; then
                                             var=`echo "$Line"|sed -n "s/\.gz$//p"`
                                             grep -i 'H1' "${var}"|cut -c36-48 >> $ArchDataFile
#                                            cat "${var}" >> $ArchDataFile
                                        else
                                             grep -i 'H1' "${Line}"|cut -c36-48 >> $ArchDataFile
#                                             cat "${Line}" >> $ArchDataFile
                                        fi

                                   
                                    done < ${MnloArchFileList}
                             fi

                       fi

                       if [ -s "$BRDOutFileLst" ]; then

                             FileArchLoc="${FileArchivePath_0}/"

                             while read Fname
                             do
                                ScriptLogPattern=`echo "$LogFilePattern_2"|cut -d"|" -f1`
                                zgrep -iH "$Fname" ${LogFilePath_2}/${ScriptLogPattern}*|cut -d':' -f1|xargs zgrep -i "AUDIT_LOG~Splt_*"|cut -d '~' -f3|sed -n "s/\.TXT$//p"|xargs -i find ${FileArchLoc} -name {}* -type f -print >> ${BRDArchFileList}_Temp
                             done < ${BRDOutFileLst}

                             if [ -s ${BRDArchFileList}_Temp ]; then

                                    sort -u ${BRDArchFileList}_Temp >> ${BRDArchFileList}
                                    rm -f ${BRDArchFileList}_Temp

                                    while read Line
                                    do               
                                        gunzip $Line &> /dev/null

                                        if [ "$?" -eq 0 ]; then
                                             var=`echo "$Line"|sed -n "s/\.gz$//p"`
                                             grep -i 'ORDH' "${var}"|cut -c65-77 >> $ArchDataFile
#                                             cat "${var}" >> $ArchDataFile
                                        else
                                             grep -i 'ORDH' "${Line}"|cut -c65-77 >> $ArchDataFile
#                                            cat "${Line}" >> $ArchDataFile
                                        fi

                                   
                                    done < ${BRDArchFileList}
                             fi


                       fi


                       while read RPT
                       do


                          BValue=`echo "$RPT"|cut -d"," -f4`

                          grep -il "$BValue" ${ArchDataFile} &> /dev/null

                             if [ "$?" -eq 0 ]; then
                                MsgStatus="SUCCESS"
                                echo "${RPT}${MsgStatus}" >> ${RcnFileName}

                             else
                                MsgStatus="DROPPED"
                                echo "${RPT}${MsgStatus}" >> ${RcnFileName}
                             fi


                       done < ${RcnFileName}_Temp

            
                       Total_MsgEntry=`cat ${RcnFileName}|wc -l `
                       Total_MsgEntry=$(( $Total_MsgEntry - 1 ))
                       Total_Success=`cut -d"," -f7 ${RcnFileName}|zgrep -i "SUCCESS"|wc -l`                
                       Total_Error=`cut -d"," -f7 ${RcnFileName}|zgrep -i "ERROR"|wc -l`
                       Total_Dropped=`cut -d"," -f7 ${RcnFileName}|zgrep -i "DROPPED"|wc -l`


                       echo "Message Status count for Interface $File_Pattern" > ${RcnFileName_0}
                       echo "Reconciliation done for timeperiod" >> ${RcnFileName_0}
                       echo "StartDateTime: ${StartDate} ${StartHour}:00 and EndDateTime: ${EndDate} ${EndHour}:00" >> ${RcnFileName_0}
                       echo "Total Messages :$Total_MsgEntry" >> ${RcnFileName_0}
                       echo "Total Success :$Total_Success" >> ${RcnFileName_0}
                       echo "Total Error :$Total_Error" >> ${RcnFileName_0}
                       echo "Total Dropped :$Total_Dropped" >> ${RcnFileName_0} 


               elif [ "$InterfaceType" = "SC" ] || [ "$InterfaceType" = "OS" ]; then

                       Total_MsgEntry=`cat ${RcnFileName}|wc -l `
                       Total_MsgEntry=$(( $Total_MsgEntry - 1 ))
                       Total_Success=`cut -d"," -f6 ${RcnFileName}|zgrep -i "SUCCESS"|wc -l`
                       Total_Error=`cut -d"," -f6 ${RcnFileName}|zgrep -i "ERROR"|wc -l`
                       Total_Dropped=`cut -d"," -f6 ${RcnFileName}|zgrep -i "DROPPED"|wc -l`

                       echo "Message Status count for Interface $File_Pattern" > ${RcnFileName_0}
                       echo "Reconciliation done for timeperiod" >> ${RcnFileName_0}
                       echo "StartDateTime: ${StartDate} ${StartHour}:00 and EndDateTime: ${EndDate} ${EndHour}:00" >> ${RcnFileName_0}
                       echo "Total Messages :$Total_MsgEntry" >> ${RcnFileName_0}
                       echo "Total Success :$Total_Success" >> ${RcnFileName_0}
                       echo "Total Error :$Total_Error" >> ${RcnFileName_0}
                       echo "Total Dropped :$Total_Dropped" >> ${RcnFileName_0}

               fi


}



Email_GSS() {

reason="Attached is the Reconciliation summary for interface ${InterfaceType}"

{
echo "To: $email_id, $email_id_1"
#echo "To: $email_id"
echo "Subject:Recon summary  for ${InterfaceType}"
echo "Hi,
$reason

Thank you
ICC."|sed 's/^[ ]*//'
uuencode ${LogDir}/${RcnFileName_0} ${RcnFileName_0}
}| sendmail -t $email_id


}


echo "Starting execution of the script"
echo `date`

if [ ! -r "$Property_File" ]; then
echo "User $USER does not have proper access on property file ${Property_File} OR property file does not exist. \n"
exit 99;
fi


##############################################################################################
## Extracting contents of property file
##############################################################################################

var=`grep -i "LogFilePath" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string LogFilePath in property file : $Property_File"
   exit 2;
fi

LogDir=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

var=`grep -i "FilePattern" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string FilePattern in property file : $Property_File"
   exit 2;
fi

File_Pattern=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`



#############################################################################
#####  To check if the user has access to Log Directory
############################################################################

if [ ! -d "$LogDir" -o ! -x "$LogDir" -o ! -r "$LogDir" -o ! -w "$LogDir" ]; then

echo "User $USER does not have proper access (Read, Write or Execute) on Log file Directory ${LogDir} or
the Directory does not exist."

exit 2

fi

cd $LogDir

log_file=RcnScript_${File_Pattern}_${ext}.log

exec >> ${LogDir}/${log_file}



############################################################################

var=`grep -i "LogFile_Type_0" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string LogFile_Type_0 in property file : $Property_File"
   exit 2;
fi

LogFileType_0=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'|tr '[a-z]' '[A-Z]'`

if [ "$LogFileType_0" != "FUSION_ENTRY_LOG" ]; then
    echo "Parameter LogFile_Type_0 should have value as Fusion_Entry_Log"
    exit 2
fi

     if [ -n "$LogFileType_0" ]; then 

           var=`grep -i "LogFile_Path_0" $Property_File`

           if [ "$?" != 0 ]; then
                 echo "unable to find string LogFile_Path_0 in property file : $Property_File"
                 exit 2
           fi

           LogFilePath_0=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

           if [ ! -d "$LogFilePath_0" -o ! -x "$LogFilePath_0" -o ! -r "$LogFilePath_0" ]; then

                 echo "User $USER does not have proper access (Read or Execute) on Log file Directory ${LogFilePath_0} or
                       the Directory does not exist."

                 exit 2

           fi

           var=`grep -i "LogFile_Pattern_0" $Property_File`

           if [ "$?" != 0 ]; then
                 echo "unable to find string LogFile_Pattern_0 in property file : $Property_File"
                 exit 2
           fi

           LogFilePattern_0=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

     fi

var=`grep -i "LogFile_Type_1" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string LogFile_Type_1 in property file : $Property_File"
   exit 2;
fi

LogFileType_1=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'|tr '[a-z]' '[A-Z]'`

if [ "$LogFileType_1" != "FUSION_EXIT_LOG" ]; then
    echo "Parameter LogFile_Type_1 should have value as Fusion_Exit_Log"
    exit 2
fi

     if [ -n "$LogFileType_1" ]; then 

           var=`grep -i "LogFile_Path_1" $Property_File`

           if [ "$?" != 0 ]; then
                 echo "unable to find string LogFile_Path_1 in property file : $Property_File"
                 exit 2
           fi

           LogFilePath_1=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

           if [ ! -d "$LogFilePath_1" -o ! -x "$LogFilePath_1" -o ! -r "$LogFilePath_1" ]; then

                 echo "User $USER does not have proper access (Read or Execute) on Log file Directory ${LogFilePath_1} or
                       the Directory does not exist."

                 exit 2

           fi

           var=`grep -i "LogFile_Pattern_1" $Property_File`

           if [ "$?" != 0 ]; then
                 echo "unable to find string LogFile_Pattern_1 in property file : $Property_File"
                 exit 2
           fi

           LogFilePattern_1=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

     fi

var=`grep -i "LogFile_Type_2" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string LogFile_Type_2 in property file : $Property_File"
   exit 2;
fi

LogFileType_2=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'|tr '[a-z]' '[A-Z]'`

if [ "$LogFileType_2" != "SCRIPT_LOG" ]; then
    echo "Parameter LogFile_Type_2 should have value as Script_Log"
fi

     if [ -n "$LogFileType_2" ]; then 

           var=`grep -i "LogFile_Path_2" $Property_File`

           if [ "$?" != 0 ]; then
                 echo "unable to find string LogFile_Path_2 in property file : $Property_File"
                 exit 2
           fi

           LogFilePath_2=`eval echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

           if [ ! -d "$LogFilePath_2" -o ! -x "$LogFilePath_2" -o ! -r "$LogFilePath_2" ]; then

                 echo "User $USER does not have proper access (Read or Execute) on Log file Directory ${LogFilePath_2} or
                       the Directory does not exist."

                 exit 2

           fi

           var=`grep -i "LogFile_Pattern_2" $Property_File`

           if [ "$?" != 0 ]; then
                 echo "unable to find string LogFile_Pattern_2 in property file : $Property_File"
                 exit 2
           fi

           LogFilePattern_2=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

     fi





if [ "$Total_Parm" -eq "2" ]; then

       var=`grep -i "DateTimeFlag" $Property_File`

       if [ "$?" != 0 ]; then
               echo "unable to find string DateTimeFlag in property file : $Property_File"
               exit 2
       fi

       DTFlag=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'|tr '[a-z]' '[A-Z]'`

       var=`grep -i "StartHour" $Property_File`

       if [ "$?" != 0 ]; then
            echo "unable to find string StartHour in property file : $Property_File"
            exit 2
       fi

       Start_Hour=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`


       var=`grep -i "StartDay" $Property_File`

       if [ "$?" != 0 ]; then
            echo "unable to find string StartDay in property file : $Property_File"
            exit 2
       fi

       Start_Day=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

       var=`grep -i "EndHour" $Property_File`

       if [ "$?" != 0 ]; then
            echo "unable to find string EndHour in property file : $Property_File"
            exit 2
       fi

       End_Hour=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

       var=`grep -i "EndDay" $Property_File`

       if [ "$?" != 0 ]; then
            echo "unable to find string EndDay in property file : $Property_File"
            exit 2
       fi

       End_Day=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`





#####################################################################################################
#### Check if the value for StartDay is less than EndDay and if both StartDay is equal to EndDay
#### then check StartHour should be greater than EndHour, if any of the conditions is not satisfied
#### then exit the script with failure
#####################################################################################################


if [ "$$DTFlag" = "D" ]; then

       if [ $Start_Day -lt $End_Day ]; then
            echo "StartDay should be greater than End Day"
            echo "StartDay=${Start_Day} and EndDay=${End_Day}"
            exit 2
       elif [ $Start_Day -eq $End_Day ] && [ $Start_Hour -lt $End_Hour ]; then
            echo "when StartDay and EndDay are equal, StartHour should be greater than EndHour"
            echo "StartHour=${Start_Hour} and EndHour=${End_Hour}"
            exit 2
       fi

elif [ "$$DTFlag" = "S" ]; then

       if [ $Start_Day -lt $End_Day ]; then
            echo "StartDay should be greater than End Day"
            echo "StartDay=${Start_Day} and EndDay=${End_Day}"
            exit 2
       elif [ $Start_Day -eq $End_Day ] && [ $End_Hour -lt $Start_Hour ]; then
            echo "if DateTimeFlag=S and StartDay is equal to EndDay, EndHour should be greater than StartHour"
            echo "StartHour=${Start_Hour} and EndHour=${End_Hour}"
            exit 2
       fi

fi
       


##################################################################################################
### Calculate Start and End date by calling function Get_BackDateVal
##################################################################################################

#       Get_BackDateVal $DTFlag $Start_Day $Start_Hour

#       SDate=$Return_Dt
#       STime=$Return_Tm

       SDate=`date -d "$Start_Day day ago" +%Y%m%d`
       STime=$Start_Hour

       Total_Hours=$(( $End_Day * 24 ))
       Total_Hours=$(( $Total_Hours + $End_Hour ))

#       Get_BackDateVal $DTFlag $End_Day $End_Hour

#       EDate=$Return_Dt
#       ETime=$Return_Tm

       EDate=`date -d "$End_Day day ago" +%Y%m%d`
       ETime=$End_Hour



       echo "Start date time is ${SDate} ${STime}"

       echo "End date time is ${EDate} ${ETime}"


       StartYear=`echo "$SDate"|cut -c1-4`
       StartMonth=`echo "$SDate"|cut -c5-6`
       StartDay=`echo "$SDate"|cut -c7-8`
       StartDate="${StartDay}-${StartMonth}-${StartYear}"
       StartHour=`echo "$STime"|cut -c1-2`

       EndYear=`echo "$EDate"|cut -c1-4`
       EndMonth=`echo "$EDate"|cut -c5-6`
       EndDay=`echo "$EDate"|cut -c7-8`
       EndDate="${EndDay}-${EndMonth}-${EndYear}"
       EndHour=`echo "$ETime"|cut -c1-2`

##################################################################################################################

elif [ "$Total_Parm" -eq "6" ]; then

if [ "$SDate" -gt "$EDate" ]; then
    echo "Value in SDate $SDate can not contain latest date value than EDate $EDate"
    exit 2
fi

SD_NC=`echo "$SDate"|wc -c`
ED_NC=`echo "$EDate"|wc -c`

if [ "$SD_NC" -ne "15" ] || [ "$ED_NC" -ne "15" ]; then
    echo "Invalid datetime parameters passed, check -S $SDate or -E $EDate"
    usage
fi


StartYear=`echo "$SDate"|cut -c1-4`
StartMonth=`echo "$SDate"|cut -c5-6`
StartDay=`echo "$SDate"|cut -c7-8`
StartDate="${StartDay}-${StartMonth}-${StartYear}"
StartHour=`echo "$SDate"|cut -c9-10`
#StartTime=`echo "$SDate"|cut -c9-14`
EndYear=`echo "$EDate"|cut -c1-4`
EndMonth=`echo "$EDate"|cut -c5-6`
EndDay=`echo "$EDate"|cut -c7-8`
EndDate="${EndDay}-${EndMonth}-${EndYear}"
EndHour=`echo "$EDate"|cut -c9-10`
#EndTime=`echo "$EDate"|cut -c9-14`

fi


var=`grep -i "Interface_Type" $Property_File`

if [ "$?" != 0 ]; then
   echo "unable to find string Interface_Type in property file : $Property_File"
   exit 2;
fi

InterfaceType=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'|tr '[a-z]' '[A-Z]'`


trap "rm -f ${LogDir}/MsgStatFilelst_${File_Pattern}.lst ${LogDir}/MsgEntryLnNo_${File_Pattern}.list ${LogDir}/Adt_File_List_${File_Pattern} ${LogDir}/ExitAdtFile_${File_Pattern}.log ${LogDir}/ConAdtFile_${File_Pattern}.log ${LogDir}/ArchData_${File_Pattern}_${ext}_FileList; exit" 0

if [ "$InterfaceType" = "SR" ]; then

       var=`grep -i "File_Archive_Path_0" $Property_File`

             if [ "$?" != 0 ]; then
                  echo "unable to find string File_Archive_Path_0 in property file : $Property_File"
                  exit 2
             fi

       FileArchivePath_0=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

             if [ ! -d "$FileArchivePath_0" -o ! -x "$FileArchivePath_0" -o ! -r "$FileArchivePath_0" ]; then

                 echo "User $USER does not have proper access (Read or Execute) on Archive file Directory ${FileArchivePath_0} or
                       the Directory does not exist."

                 exit 2

             fi

       var=`grep -i "File_Archive_Path_1" $Property_File`

             if [ "$?" != 0 ]; then
                  echo "unable to find string File_Archive_Path_1 in property file : $Property_File"
                  exit 2
             fi

       FileArchivePath_1=`echo $var|cut -d'=' -f2| sed -e 's/^ *//' -e 's/ *$//'`

             if [ ! -d "$FileArchivePath_1" -o ! -x "$FileArchivePath_1" -o ! -r "$FileArchivePath_1" ]; then

                 echo "User $USER does not have proper access (Read or Execute) on Archive file Directory ${FileArchivePath_1} or
                       the Directory does not exist."

                 exit 2

             fi

######################################################################################################################
##### step 0 unzip Audit entry and exit log files
######################################################################################################################

       AuditLog_Unzip $LogFilePath_0 $LogFilePattern_0

            if [ "$LogFilePattern_0" != "$LogFilePattern_1" ]; then
                  AuditLog_Unzip $LogFilePath_1 $LogFilePattern_1     
            fi


######################################################################################################################
##### step 1 capture message logs from Audit logs with in given time frame
######################################################################################################################
             echo `date`":Starting to create stage file with messages logs created between given time frame"
             echo "GetMsg_CrtBtwStrtEndTime $LogFilePath_0 $LogFilePattern_0 $StartDate $StartHour $EndDate $EndHour"

             GetMsg_CrtBtwStrtEndTime $LogFilePath_0 $LogFilePattern_0 $StartDate $StartHour $EndDate $EndHour
             echo `date`":completed creating stage file with message log information into file $StgFileName"
######################################################################################################################
##### step 2 Check message status in Audit exit log files
######################################################################################################################
             echo "Chk_ExitLog $LogFilePath_1 $LogFilePattern_1 $StgFileName"
             Chk_ExitLog $LogFilePath_1 $LogFilePattern_1 $StgFileName


######################################################################################################################
##### step 3 zip Audit entry and exit log files
######################################################################################################################

       AuditLog_zip $LogFilePath_0 $LogFilePattern_0

            if [ "$LogFilePattern_0" != "$LogFilePattern_1" ]; then
                  AuditLog_zip $LogFilePath_1 $LogFilePattern_1     
            fi



elif [ "$InterfaceType" = "SC" ]; then


######################################################################################################################
##### step 0 unzip Audit entry and exit log files
######################################################################################################################

       AuditLog_Unzip $LogFilePath_0 $LogFilePattern_0

            if [ "$LogFilePattern_0" != "$LogFilePattern_1" ]; then
                  AuditLog_Unzip $LogFilePath_1 $LogFilePattern_1     
            fi

######################################################################################################################
##### step 1 capture message logs from Audit logs with in given time frame
######################################################################################################################

             echo "Starting to create stage file with messages logs created between given time frame"
             echo "GetMsg_CrtBtwStrtEndTime $LogFilePath_0 $LogFilePattern_0 $StartDate $StartHour $EndDate $EndHour"
             GetMsg_CrtBtwStrtEndTime $LogFilePath_0 $LogFilePattern_0 $StartDate $StartHour $EndDate $EndHour
             echo "completed creating stage file with message log information into file $StgFileName"

######################################################################################################################
##### step 2 Check message status in Audit exit log files
######################################################################################################################

             echo "Chk_ExitLog $LogFilePath_1 $LogFilePattern_1 $StgFileName"
             Chk_ExitLog $LogFilePath_1 $LogFilePattern_1 $StgFileName

######################################################################################################################
##### step 3 zip Audit entry and exit log files
######################################################################################################################

       AuditLog_zip $LogFilePath_0 $LogFilePattern_0

            if [ "$LogFilePattern_0" != "$LogFilePattern_1" ]; then
                  AuditLog_zip $LogFilePath_1 $LogFilePattern_1     
            fi



elif [ "$InterfaceType" = "OS" ]; then

######################################################################################################################
##### step 0 unzip Audit entry and exit log files
######################################################################################################################

       AuditLog_Unzip $LogFilePath_0 $LogFilePattern_0

            if [ "$LogFilePattern_0" != "$LogFilePattern_1" ]; then
                  AuditLog_Unzip $LogFilePath_1 $LogFilePattern_1     
            fi

######################################################################################################################
##### step 1 capture message logs from Audit logs with in given time frame
######################################################################################################################

             echo "Starting to create stage file with messages logs created between given time frame"
             echo "GetMsg_CrtBtwStrtEndTime $LogFilePath_0 $LogFilePattern_0 $StartDate $StartHour $EndDate $EndHour"
             GetMsg_CrtBtwStrtEndTime $LogFilePath_0 $LogFilePattern_0 $StartDate $StartHour $EndDate $EndHour
             echo "completed creating stage file with message log information into file $StgFileName"

######################################################################################################################
##### step 2 Check message status in Audit exit log files
######################################################################################################################

             echo "Chk_ExitLog $LogFilePath_1 $LogFilePattern_1 $StgFileName"
             Chk_ExitLog $LogFilePath_1 $LogFilePattern_1 $StgFileName

######################################################################################################################
##### step 3 zip Audit entry and exit log files
######################################################################################################################

       AuditLog_zip $LogFilePath_0 $LogFilePattern_0

            if [ "$LogFilePattern_0" != "$LogFilePattern_1" ]; then
                  AuditLog_zip $LogFilePath_1 $LogFilePattern_1     
            fi

      echo "completed zipping files"



fi



echo "Email Recon summary file"
Email_GSS

if [ "$?" -ne 0 ]; then
     echo "Recon summary file email failure"
fi

rm -f ${RcnFileName}_Temp
rm -f ${MnloArchFileList}
rm -f ${BRDArchFileList}

###############################################################################################################################################
## delete files created as part of previous failure which are older than 5 days
###############################################################################################################################################
## find ${LogDir} -type f -name "Rcn_${File_Pattern}_*"  -mtime +10 -print|xargs rm -f

find ${LogDir} -type f -name "RcnScript_${File_Pattern}_*" -mtime +10 -print|xargs rm -f

echo `date`": completed processing"

exit 0


















