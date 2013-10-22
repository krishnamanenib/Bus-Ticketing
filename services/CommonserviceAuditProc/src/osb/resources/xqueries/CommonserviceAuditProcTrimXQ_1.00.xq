(:: pragma bea:global-element-parameter parameter="$auditMessage1" element="ns0:AuditMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AuditMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AuditMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AuditMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/audit/v1";
declare namespace xf = "http://tempuri.org/CommonserviceAuditProc_1.00/src/osb/resources/xqueries/CommonserviceAuditProcTrimXQ_1.00/";

declare function xf:CommonserviceAuditProcTrimXQ_1($auditMessage1 as element(ns0:AuditMessage))
    as element(ns0:AuditMessage) {
        <ns0:AuditMessage>
            <ns0:Header>
                <ns0:PlatformName>{substring(fn-bea:trim(data($auditMessage1/ns0:Header/ns0:PlatformName)),1,20) }</ns0:PlatformName>
                <ns0:ServiceName>{substring(fn-bea:trim(data($auditMessage1/ns0:Header/ns0:ServiceName)),1,50) }</ns0:ServiceName>
                {
                    for $ServiceID in $auditMessage1/ns0:Header/ns0:ServiceID
                    return
                        if (fn:string-length($ServiceID) != 0) then
                           <ns0:ServiceID>{ data($ServiceID) }</ns0:ServiceID>
                           else
                           ()
                }
            </ns0:Header>
            <ns0:Body>
                {
                    for $LinkID in $auditMessage1/ns0:Body/ns0:LinkID
                    return
                                if (fn:string-length($LinkID) != 0) then
                                 <ns0:LinkID>{ data($LinkID) }</ns0:LinkID>
                                 else
                                 ()
                }
                {
                    for $SenderText in $auditMessage1/ns0:Body/ns0:SenderText
                    return
                        <ns0:SenderText>{ substring(fn-bea:trim(data($SenderText)),1,50) }</ns0:SenderText>
                }
                {
                    for $SendingApplicationText in $auditMessage1/ns0:Body/ns0:SendingApplicationText
                    return
                        <ns0:SendingApplicationText>{ substring(fn-bea:trim(data($SendingApplicationText)),1,50) }</ns0:SendingApplicationText>
                }
                {
                    for $TargetApplicationText in $auditMessage1/ns0:Body/ns0:TargetApplicationText
                    return
                        <ns0:TargetApplicationText>{ substring(fn-bea:trim(data($TargetApplicationText)),1,50) }</ns0:TargetApplicationText>
                }
                <ns0:ServerName>{ substring(fn-bea:trim(data($auditMessage1/ns0:Body/ns0:ServerName)),1,20) }</ns0:ServerName>
                <ns0:ServerTimestamp>{ data($auditMessage1/ns0:Body/ns0:ServerTimestamp) }</ns0:ServerTimestamp>
                {
                    for $TrackingIDText in $auditMessage1/ns0:Body/ns0:TrackingIDText
                    return
                        <ns0:TrackingIDText>{ substring(fn-bea:trim(data($TrackingIDText)),1,255) }</ns0:TrackingIDText>
                }
                <ns0:BusinessKeyName>{ substring(fn-bea:trim(data($auditMessage1/ns0:Body/ns0:BusinessKeyName)),1,200) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ substring(fn-bea:trim(data($auditMessage1/ns0:Body/ns0:BusinessKeyText)),1,200) }</ns0:BusinessKeyText>
                {
                    for $Filename in $auditMessage1/ns0:Body/ns0:Filename
                    return
                        <ns0:Filename>{ substring(fn-bea:trim(data($Filename)),1,80) }</ns0:Filename>
                }
                {
                    for $ErrorCode in $auditMessage1/ns0:Body/ns0:ErrorCode
                    return
                        <ns0:ErrorCode>{ substring(fn-bea:trim(data($ErrorCode)),1,50) }</ns0:ErrorCode>
                }
                <ns0:EventTypeCode>{ substring(fn-bea:trim(data($auditMessage1/ns0:Body/ns0:EventTypeCode)),1,20) }</ns0:EventTypeCode>
            </ns0:Body>
        </ns0:AuditMessage>
};

declare variable $auditMessage1 as element(ns0:AuditMessage) external;

xf:CommonserviceAuditProcTrimXQ_1($auditMessage1)