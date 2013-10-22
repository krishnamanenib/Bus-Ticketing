(:: pragma bea:global-element-parameter parameter="$errorMessage1" element="ns0:ErrorMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/ErrorMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns1:LogMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/LogMessageXSD_1.00.xsd" ::)

declare namespace ns1 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace xf = "http://tempuri.org/CommonserviceErrorProc_1.00/src/osb/resources/xqueries/CommonserviceErrorProcLogXQ_1.00/";

declare function xf:CommonserviceErrorProcLogXQ_1($errorMessage1 as element(ns0:ErrorMessage),
    $logLevelCode as xs:string)
    as element(ns1:LogMessage) {
        <ns1:LogMessage>
            <ns1:Header>
                <ns1:PlatformName>{ data($errorMessage1/ns0:Header/ns0:PlatformName) }</ns1:PlatformName>
                <ns1:ServiceName>{ data($errorMessage1/ns0:Header/ns0:ServiceName) }</ns1:ServiceName>
                {
                    for $ServiceID in $errorMessage1/ns0:Header/ns0:ServiceID
                    return
                        <ns1:ServiceID>{ data($ServiceID) }</ns1:ServiceID>
                }
            </ns1:Header>
            <ns1:Body>
                {
                    for $LinkID in $errorMessage1/ns0:Body/ns0:LinkID
                    return
                        <ns1:LinkID>{ data($LinkID) }</ns1:LinkID>
                }
                <ns1:ServerName>{ data($errorMessage1/ns0:Body/ns0:ServerName) }</ns1:ServerName>
                <ns1:ServerTimestamp>{ data($errorMessage1/ns0:Body/ns0:ServerTimestamp) }</ns1:ServerTimestamp>
                {
                    for $TrackingIDText in $errorMessage1/ns0:Body/ns0:TrackingIDText
                    return
                        <ns1:TrackingIDText>{ data($TrackingIDText) }</ns1:TrackingIDText>
                }
                <ns1:BusinessKeyName>{ data($errorMessage1/ns0:Body/ns0:BusinessKeyName) }</ns1:BusinessKeyName>
                <ns1:BusinessKeyText>{ data($errorMessage1/ns0:Body/ns0:BusinessKeyText) }</ns1:BusinessKeyText>
                <ns1:MessageText>{ data($errorMessage1/ns0:Body/ns0:MessageText) }</ns1:MessageText>
                <ns1:LogLevelCode>{ $logLevelCode }</ns1:LogLevelCode>
                {
                    for $StackTraceText in $errorMessage1/ns0:Body/ns0:StackTraceText
                    return
                        <ns1:StackTraceText>{ data($StackTraceText) }</ns1:StackTraceText>
                }
            </ns1:Body>
        </ns1:LogMessage>
};

declare variable $errorMessage1 as element(ns0:ErrorMessage) external;
declare variable $logLevelCode as xs:string external;

xf:CommonserviceErrorProcLogXQ_1($errorMessage1,
    $logLevelCode)