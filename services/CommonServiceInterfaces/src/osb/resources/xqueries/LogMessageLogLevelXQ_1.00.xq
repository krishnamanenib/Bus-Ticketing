(:: pragma bea:global-element-parameter parameter="$logMessage1" element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace xf = "http://tempuri.org/CommonserviceLogProc_1.00/src/osb/resources/xqueries/CommonserviceLogProcAppLogLevelXQ_1.00/";

declare function xf:CommonserviceLogProcAppLogLevelXQ_1($logMessage1 as element(ns0:LogMessage))
    as xs:string {
        if ($logMessage1/ns0:Body/ns0:LogLevelCode = 'Error') then
            (xs:string('1'))
        else 
            if ($logMessage1/ns0:Body/ns0:LogLevelCode = 'Info') then
                (xs:string('2'))
            else 
                if ($logMessage1/ns0:Body/ns0:LogLevelCode = 'Debug') then
                    (xs:string('3'))
                else 
                (xs:string('Invalid Details'))
};

declare variable $logMessage1 as element(ns0:LogMessage) external;

xf:CommonserviceLogProcAppLogLevelXQ_1($logMessage1)