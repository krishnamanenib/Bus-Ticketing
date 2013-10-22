(:: pragma bea:global-element-parameter parameter="$outputParameters1" element="ns1:OutputParameters" location="../schemas/LogConfigDB_1_00.xsd" ::)
(:: pragma bea:global-element-parameter parameter="$logMessage1" element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)

declare namespace ns1 = "http://xmlns.oracle.com/pcbpel/adapter/db/schema/GET_LOG_CONFIG/";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/src/osb/resources/xqueries/LogProcLogDetailXQ_1.00/";

declare function xf:LogProcLogDetailXQ_1($outputParameters1 as element(ns1:OutputParameters),
    $logMessage1 as element(ns0:LogMessage))
    as xs:string {
        if (($outputParameters1/ns1:LOGFILENAME = '!!osb.file.cs.logfilename!!' or $outputParameters1/ns1:LOGFILENAME = '')) then
            (fn:concat($outputParameters1/ns1:LOGFILEPATH,
            '$$',$logMessage1/ns0:Header/ns0:ServiceName,'.log'))
        else 
            fn:concat($outputParameters1/ns1:LOGFILEPATH,'$$',
            $outputParameters1/ns1:LOGFILENAME)
};

declare variable $outputParameters1 as element(ns1:OutputParameters) external;
declare variable $logMessage1 as element(ns0:LogMessage) external;

xf:LogProcLogDetailXQ_1($outputParameters1,
    $logMessage1)
