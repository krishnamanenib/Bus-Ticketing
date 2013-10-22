declare namespace xf = "http://tempuri.org/CommonXQueries/src/osb/resources/xqueries/HRMS_ServiceErrorMessageMapping_XQ_1.00/";

declare function xf:HRMS_ServiceErrorMessageMapping_XQ_1($location as xs:string)
    as xs:string {
        if ($location="stage-ReadHeaders")then
         "Error in reading the header data from AutoSys."
        else if($location="stage-LoadConfiguration") then
         "Error in loading the configuration values."
        else if($location="stage-ReadSourceFileName" or $location="stage-ReadTargetFileName") then
         "Error occurred in FileUtil operation."
        else if($location="stage-SyncRead") then
         "Unable to read the file or Empty File."
        else if($location="stage-GetListOfFiles") then
         "Unable to get the list of files." 
        else if($location="stage-CallProcessor") then
         "Error in invoking Processor Service."             
        else if($location="stage-HeaderValidation") then
         "Invalid header or header not found."           
        else if($location="stage-TrailerValidation") then
         "Invalid trailer or trailer not found"  
        else if($location="stage-TransformNonXMLToXML" or $location="stage-TransformXMLToNonXML" or $location="stage-TransformNonXMLToNonXML" or $location="stage-TransformXMLToXML") then
         "Failed to Transform message."
        else if($location="RouteNode-WriteOperation") then
         "Unable to write outbound file."
        else if($location="stage-PublishFile") then
         "Unable to write outbound file."         
        else if($location="stage-Encryption") then
         "Unable to Encrypt the file."        
        else if($location="stage-Decryption") then
         "Unable to Decrypt the file."
        else if($location="stage-AutoSysResponse") then
         "Unable to connect to JMS resource."        
        else if($location="stage-ZipTargetFiles") then
         "Unable to Zip the Target Files."       
        else if($location="stage-ServiceEntryLogging") then
         "Failed in Service Entry Logging action."        
        else if($location="stage-ServiceExitLoggingAuditing") then
         "Failed in Service Exit Logging and Auditing action." 
        else
         "Error processing the request"   
};

declare variable $location as xs:string external;

xf:HRMS_ServiceErrorMessageMapping_XQ_1($location)