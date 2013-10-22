(:: pragma bea:global-element-parameter parameter="$auditMessage1" element="ns0:AuditMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AuditMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns1:MiddlewareCommonAuditCollection" location="../schemas/CommonserviceAuditProcDBAdp_1.00.xsd" ::)

declare namespace ns1 = "http://xmlns.oracle.com/pcbpel/adapter/db/top/CommonserviceAuditProcConfigDB1_1/00";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/audit/v1";
declare namespace xf = "http://tempuri.org/CommonserviceAuditProc_1.00/src/osb/resources/xqueries/CommonserviceAuditProcXQ_1.00/";

declare function xf:CommonserviceAuditProcXQ_1($auditMessage1 as element(ns0:AuditMessage))
    as element(ns1:MiddlewareCommonAuditCollection) {
        <ns1:MiddlewareCommonAuditCollection>
            <ns1:MiddlewareCommonAudit>
                <ns1:platformName>{ data($auditMessage1/ns0:Header/ns0:PlatformName) }</ns1:platformName>
                <ns1:serviceName>{ data($auditMessage1/ns0:Header/ns0:ServiceName) }</ns1:serviceName>
                <ns1:serviceId>{   if (fn:string-length(data($auditMessage1/ns0:Header/ns0:ServiceID)) != 0) then
                xs:decimal(data($auditMessage1/ns0:Header/ns0:ServiceID)) 
               else
               ()}</ns1:serviceId>
                <ns1:linkId>
{  
                  if (fn:string-length(data($auditMessage1/ns0:Body/ns0:LinkID)) != 0) then
                 xs:decimal(data($auditMessage1/ns0:Body/ns0:LinkID)) 
                 else()
                 }</ns1:linkId>
                {
                    for $SenderText in $auditMessage1/ns0:Body/ns0:SenderText
                    return
                        <ns1:senderText>{ data($SenderText) }</ns1:senderText>
                }
                {
                    for $SendingApplicationText in $auditMessage1/ns0:Body/ns0:SendingApplicationText
                    return
                        <ns1:sendingApplicationText>{ data($SendingApplicationText) }</ns1:sendingApplicationText>
                }
                {
                    for $TargetApplicationText in $auditMessage1/ns0:Body/ns0:TargetApplicationText
                    return
                        <ns1:targetApplicationText>{ data($TargetApplicationText) }</ns1:targetApplicationText>
                }
                <ns1:serverName>{ data($auditMessage1/ns0:Body/ns0:ServerName) }</ns1:serverName>
                <ns1:serverTimestamp>{ data($auditMessage1/ns0:Body/ns0:ServerTimestamp) }</ns1:serverTimestamp>
                {
                    for $TrackingIDText in $auditMessage1/ns0:Body/ns0:TrackingIDText
                    return
                        <ns1:trackingidText>{ data($TrackingIDText) }</ns1:trackingidText>
                }
                <ns1:businesskeyName>{ data($auditMessage1/ns0:Body/ns0:BusinessKeyName) }</ns1:businesskeyName>
                <ns1:businesskeyText>{ data($auditMessage1/ns0:Body/ns0:BusinessKeyText) }</ns1:businesskeyText>
                {
                    for $Filename in $auditMessage1/ns0:Body/ns0:Filename
                    return
                        <ns1:filename>{ data($Filename) }</ns1:filename>
                }
                {
                    for $ErrorCode in $auditMessage1/ns0:Body/ns0:ErrorCode
                    return
                        <ns1:errorCode>{ data($ErrorCode) }</ns1:errorCode>
                }
                <ns1:eventTypeCode>{ data($auditMessage1/ns0:Body/ns0:EventTypeCode) }</ns1:eventTypeCode>
            </ns1:MiddlewareCommonAudit>
        </ns1:MiddlewareCommonAuditCollection>
};

declare variable $auditMessage1 as element(ns0:AuditMessage) external;

xf:CommonserviceAuditProcXQ_1($auditMessage1)