(:: pragma bea:global-element-parameter parameter="$logMessage1" element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace xf = "http://tempuri.org/CommonserviceLogProc_1.00/src/osb/resources/xqueries/CommonserviceLogProcTrimXQ_1.00/";

declare function xf:CommonserviceLogProcTrimXQ_1($logMessage1 as element(ns0:LogMessage))
    as element(ns0:LogMessage) {
        <ns0:LogMessage>
            <ns0:Header>
                <ns0:PlatformName>{ substring(fn-bea:trim(data($logMessage1/ns0:Header/ns0:PlatformName)),1,20) }</ns0:PlatformName>
                <ns0:ServiceName>{ substring(fn-bea:trim(data($logMessage1/ns0:Header/ns0:ServiceName)),1,50) }</ns0:ServiceName>
                {
                         if (fn:string-length($logMessage1/ns0:Header/ns0:ServiceID) != 0) then
                            <ns0:ServiceID>{ fn-bea:trim(data($logMessage1/ns0:Header/ns0:ServiceID)) }</ns0:ServiceID>
                            else
                            ()
                }
            </ns0:Header>
            <ns0:Body>
                {
                                if (fn:string-length($logMessage1/ns0:Body/ns0:LinkID) != 0) then
                        <ns0:LinkID>{ fn-bea:trim(data($logMessage1/ns0:Body/ns0:LinkID)) }</ns0:LinkID>
                        else
                        ()
                }
                <ns0:ServerName>{ substring(fn-bea:trim(data($logMessage1/ns0:Body/ns0:ServerName)),1,20) }</ns0:ServerName>
                <ns0:ServerTimestamp>{ fn-bea:trim(data($logMessage1/ns0:Body/ns0:ServerTimestamp)) }</ns0:ServerTimestamp>
                {
                    for $TrackingIDText in $logMessage1/ns0:Body/ns0:TrackingIDText
                    return
                        <ns0:TrackingIDText>{ substring(fn-bea:trim(data($TrackingIDText)),1,255) }</ns0:TrackingIDText>
                }
                <ns0:BusinessKeyName>{ substring(fn-bea:trim(data($logMessage1/ns0:Body/ns0:BusinessKeyName)),1,200) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ substring(fn-bea:trim(data($logMessage1/ns0:Body/ns0:BusinessKeyText)),1,200) }</ns0:BusinessKeyText>
                <ns0:MessageText>{ substring(fn-bea:trim(data($logMessage1/ns0:Body/ns0:MessageText)),1,4000) }</ns0:MessageText>
                <ns0:LogLevelCode>{ substring(fn-bea:trim(data($logMessage1/ns0:Body/ns0:LogLevelCode)),1,10) }</ns0:LogLevelCode>
                {
                    for $StackTraceText in $logMessage1/ns0:Body/ns0:StackTraceText
                    return
                        <ns0:StackTraceText>{ substring(fn-bea:trim(data($StackTraceText)),1,4000) }</ns0:StackTraceText>
                }
            </ns0:Body>
        </ns0:LogMessage>
};

declare variable $logMessage1 as element(ns0:LogMessage) external;

xf:CommonserviceLogProcTrimXQ_1($logMessage1)