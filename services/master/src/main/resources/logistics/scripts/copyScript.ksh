#!/bin/ksh

if [ $# -ne 1 ]; then
   echo "Incorrect number of Parameters Passed "
   echo "One paramter to be passed. Format is : copyScript.ksh <Property_File>"
   exit 99
fi
Property_File=!!osb.file.logistics.netapp.propertyFileDir!!/$1

ext=`date "+%Y%m%d%H%M%S"`

#echo "Param_Cnt: " $Param_Cnt
#echo "Property_File: " $Property_File

Source_Dir=`sed -n "s/Source_Dir=//gp" $Property_File`
Log_Dir=`sed -n "s/Log_Dir=//gp" $Property_File`
Log_File=`sed -n "s/Log_File=//gp" $Property_File`
Stage_File_Pattern=`sed -n "s/Stage_File_Pattern=//gp" $Property_File`
Source_File_Pattern=`sed -n "s/Source_File_Pattern=//gp" $Property_File`
Stage_Dir=`sed -n "s/Stage_Dir=//gp" $Property_File`
Delete_Source=`sed -n "s/Delete_Source=//gp" $Property_File`
Unzip=`sed -n "s/Unzip=//gp" $Property_File`
File_Permission=`sed -n "s/File_Permission=//gp" $Property_File`
Log_Detailed=`sed -n "s/Log_Detailed=//gp" $Property_File`
Has_Stage="Y"
File_TMP=".tmp"
#echo "log dir:"$Log_Dir
if [ "$Log_Detailed" = "" ]; then
		Log_Detailed="TRUE"
fi
if [ "$Log_File" = "" ]; then
		Log_File=Log_${ext}.log
fi

 if [[ ! -w $Log_Dir ]] 
 then
	 echo "ERROR: Log Directory not present or not writable: $Log_Dir"
	 exit 99;
 fi

Log_File_Name=${Log_Dir}/${Log_File}
exec >>${Log_File_Name}
echo "Process started at `date`"
if [ "$File_Permission" = "" ]; then
		File_Permission="664"
fi
if [ "$Source_Dir" = "" ]; then
		echo "ERROR: Source_Dir is empty"
		#exec >>${Log_File_Name}
		exit 99;
fi
if [ "$Source_File_Pattern" = "" ]; then
		echo "ERROR: Source_File_Pattern is empty"
		#exec >>${Log_File_Name}
		exit 99;
fi
if [ "$Stage_File_Pattern" = "" ]; then
	Stage_File_Pattern=$Source_File_Pattern
fi

while read LINE
do
    Destination_Dir=`echo $LINE | grep -i Target_Dir | cut -d"=" -f2`
    Destination_Dir=`eval echo $Destination_Dir`
    if [ "$Destination_Dir" != "" ]
    then
         if [[ ! -w $Destination_Dir ]] 
         then
             echo "ERROR: Target Directory not present or not writable: $Destination_Dir"
             exit 99;
         fi
    fi
done < $Property_File

Src_File_Count=`find $Source_Dir -name \$Source_File_Pattern | wc -l`
echo "INFO: Number of files in the source location -"$Src_File_Count
if [ "$Stage_Dir" = "" ] && [ $Src_File_Count = 0 ]; then
        echo "INFO: No files in the location -"$Source_Dir
        exit 1;
fi
if [ "$Stage_Dir" != "" ]; then

     Stg_File_Count=`find $Stage_Dir -name \$Stage_File_Pattern | wc -l`

     if [ $Src_File_Count = 0 ] && [ $Stg_File_Count = 0 ]; then
        echo "INFO: No files in either $Source_Dir or $Stage_Dir"
        exit 1;
     fi
     
     echo "$Source_Dir/$Source_File_Pattern $Stage_Dir"

     if [ $Src_File_Count -ne 0 ]; then 
          cp $Source_Dir/$Source_File_Pattern $Stage_Dir/
          if [ $? -ne 0 ]; then
               echo "ERROR: Could not copy files to the location -"$Stage_Dir
               exit 99;
          fi

          if [ "$Delete_Source" = "Y" ]; then
              rm -f $Source_Dir/$Source_File_Pattern
              if [ $? -ne 0 ]; then
              echo "ERROR: Could not remove files from the location -"$Source_Dir
              exec >>${Log_File_Name}
              exit 99;
              fi
          fi
     fi
else
     Stage_Dir=$Source_Dir
     Has_Stage="N"
fi

#if ["$File_Count" == "0" ]; then
#	echo "INFO: No files in the location -"$Stage_Dir
#	#exec >>${Log_File_Name}
#	exit 1;
#fi
if [ "$Unzip" = "Y" ]; then
	for z in $Stage_Dir/$Source_File_Pattern; do 
		unzip -o -qq $z -d $Stage_Dir/; 
		if [ $? != 0 ]; then
			echo "ERROR: Could not unzip files in the location -"$Stage_Dir
			#exec >>${Log_File_Name}
			exit 99;
		fi
		if [ "$Delete_Source" = "Y" ] || [ "$Has_Stage" = "Y" ]; then
			rm -f $z
			if [ $? != 0 ]; then
				echo "ERROR: Could not delete the file -"$z
				#exec >>${Log_File_Name}
				exit 99;
			fi	
		fi
	done
fi
if [ "$Log_Detailed" = "TRUE" ]; then
	echo "INFO: Following files are copied to destinations "
fi
for sfile in $Stage_Dir/$Stage_File_Pattern; do
	if [ "$Log_Detailed" = "TRUE" ]; then
		echo "INFO: ${sfile} "
	fi
	while read LINE
	do
		Destination_Dir=`echo $LINE | sed -n "s/Target_Dir=//gp"`
		if [ "$Destination_Dir" != "" ]; then			
			cp $Stage_Dir/$(basename $sfile) $Destination_Dir/$(basename $sfile)$File_TMP
			status=$?			
			if [ $status != 0 ]; then
				echo "ERROR: Could not copy the file -"$Stage_Dir/$(basename $sfile)
				#exec >>${Log_File_Name}
				exit 99;
			fi
			
			mv $Destination_Dir/$(basename $sfile)$File_TMP $Destination_Dir/$(basename $sfile)
			status=$?
			if [ $status != 0 ]; then
				echo "ERROR: Could not rename the file-"$Destination_Dir/$(basename $sfile)$File_TMP
				#exec >>${Log_File_Name}
				exit 99;
			fi	
			chmod $File_Permission $Destination_Dir/$(basename $sfile)
			#exec >>${Log_File_Name}
		fi
	done < $Property_File
	if [ "$Has_Stage" = "Y" ]; then
		rm -f $sfile
		if [ $? != 0 ]; then
			echo "ERROR: Could not delete the file -${sfile}"
			#exec >>${Log_File_Name}
			exit 99;
		fi	
	fi
	if [ "$Delete_Source" = "Y" ] && [ "$Has_Stage" = "N" ]; then
			rm -f $sfile
			if [ $? != 0 ]; then
				echo "ERROR: Could not delete file  -${sfile}"
				#exec >>${Log_File_Name}
				exit 99
			fi			
			#exec >>${Log_File_Name}
	fi	
done


echo "Process ended successfully at "`date`
#exec >>${Log_File_Name}
exit 0;