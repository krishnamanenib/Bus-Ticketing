(:: pragma bea:global-element-parameter parameter="$errorMessage1" element="ns1:ErrorMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/ErrorMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AuditMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AuditMessageXSD_1.00.xsd" ::)

declare namespace ns1 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/audit/v1";
declare namespace xf = "http://tempuri.org/CommonserviceErrorProc_1.00/src/osb/resources/xqueries/CommonserviceErrorProcAuditXQ_1.00/";

declare function xf:CommonserviceErrorProcAuditXQ_1($errorMessage1 as element(ns1:ErrorMessage),
    $eventType as xs:string)
    as element(ns0:AuditMessage) {
        <ns0:AuditMessage>
            <ns0:Header>
                <ns0:PlatformName>{ data($errorMessage1/ns1:Header/ns1:PlatformName) }</ns0:PlatformName>
                <ns0:ServiceName>{ data($errorMessage1/ns1:Header/ns1:ServiceName) }</ns0:ServiceName>
                {
                    for $ServiceID in $errorMessage1/ns1:Header/ns1:ServiceID
                    return
                        <ns0:ServiceID>{ data($ServiceID) }</ns0:ServiceID>
                }
            </ns0:Header>
            <ns0:Body>
                {
                    for $LinkID in $errorMessage1/ns1:Body/ns1:LinkID
                    return
                        <ns0:LinkID>{ data($LinkID) }</ns0:LinkID>
                }
                {
                    for $SenderText in $errorMessage1/ns1:Body/ns1:SenderText
                    return
                        <ns0:SenderText>{ data($SenderText) }</ns0:SenderText>
                }
                {
                    for $SendingApplicationText in $errorMessage1/ns1:Body/ns1:SendingApplicationText
                    return
                        <ns0:SendingApplicationText>{ data($SendingApplicationText) }</ns0:SendingApplicationText>
                }
                {
                    for $TargetApplicationText in $errorMessage1/ns1:Body/ns1:TargetApplicationText
                    return
                        <ns0:TargetApplicationText>{ data($TargetApplicationText) }</ns0:TargetApplicationText>
                }
                <ns0:ServerName>{ data($errorMessage1/ns1:Body/ns1:ServerName) }</ns0:ServerName>
                <ns0:ServerTimestamp>{ data($errorMessage1/ns1:Body/ns1:ServerTimestamp) }</ns0:ServerTimestamp>
                {
                    for $TrackingIDText in $errorMessage1/ns1:Body/ns1:TrackingIDText
                    return
                        <ns0:TrackingIDText>{ data($TrackingIDText) }</ns0:TrackingIDText>
                }
                <ns0:BusinessKeyName>{ data($errorMessage1/ns1:Body/ns1:BusinessKeyName) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ data($errorMessage1/ns1:Body/ns1:BusinessKeyText) }</ns0:BusinessKeyText>
                {
                    for $Filename in $errorMessage1/ns1:Body/ns1:Filename
                    return
                        <ns0:Filename>{ data($Filename) }</ns0:Filename>
                }
                <ns0:ErrorCode>{ data($errorMessage1/ns1:Body/ns1:ErrorCode) }</ns0:ErrorCode>
                <ns0:EventTypeCode>{ $eventType }</ns0:EventTypeCode>
            </ns0:Body>
        </ns0:AuditMessage>
};

declare variable $errorMessage1 as element(ns1:ErrorMessage) external;
declare variable $eventType as xs:string external;

xf:CommonserviceErrorProcAuditXQ_1($errorMessage1,
    $eventType)