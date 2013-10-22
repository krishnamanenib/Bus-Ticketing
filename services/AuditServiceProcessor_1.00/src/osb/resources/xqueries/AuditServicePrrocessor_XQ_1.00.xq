(:: pragma bea:global-element-parameter parameter="$auditServiceRequest1" element="ns1:AuditServiceRequest" location="../wsdls/AuditService_1.00.wsdl" ::)
(:: pragma bea:global-element-return element="ns0:NkeMiddlewareAuditLogCollection" location="../schemas/AuditService_DB_Write_Table_1.00.xsd" ::)

declare namespace ns1 = "http://www.nike.com/AuditService/";
declare namespace ns0 = "http://xmlns.oracle.com/pcbpel/adapter/db/top/AuditDB";
declare namespace xf = "http://tempuri.org/AuditServiceProcessor_1.00/src/osb/resources/xqueries/AuditServicePrrocessor_XQ_1.00/";

declare function xf:AuditServicePrrocessor_XQ_1($auditServiceRequest1 as element(ns1:AuditServiceRequest))
    as element(ns0:NkeMiddlewareAuditLogCollection) {
        <ns0:NkeMiddlewareAuditLogCollection>
            <ns0:NkeMiddlewareAuditLog>
                <ns0:auditLogSeq>
                    {
                        fn-bea:execute-sql('jdbc/osbAudit',
                        'AUDIT_LOG_SEQ',
                        'SELECT NKE_MIDDLEWARE_AUDIT_LOG_SEQ.NEXTVAL SEQ FROM DUAL')/SEQ/text()
                    }
				</ns0:auditLogSeq>
                <ns0:platform>{ data($auditServiceRequest1/Platform) }</ns0:platform>
                <ns0:serviceName>{ data($auditServiceRequest1/ServiceName) }</ns0:serviceName>
                <ns0:serviceId>{ data($auditServiceRequest1/ServiceId) }</ns0:serviceId>
                <ns0:transactionId>{ data($auditServiceRequest1/TransactionId) }</ns0:transactionId>
                {
                    for $BusinessKey in $auditServiceRequest1/BusinessKey
                    return
                        <ns0:businessKey>{ data($BusinessKey) }</ns0:businessKey>
                }
                {
                    for $SystemId in $auditServiceRequest1/SystemId
                    return
                        <ns0:systemId>{ data($SystemId) }</ns0:systemId>
                }
                <ns0:receivedRecordsCount>{
				if(exists($auditServiceRequest1/RecievedRecordsCount) and data($auditServiceRequest1/RecievedRecordsCount)!="") then
				xs:decimal($auditServiceRequest1/RecievedRecordsCount)
				else 0 }</ns0:receivedRecordsCount>
                <ns0:errorRecordsCount>{ 
				if(exists($auditServiceRequest1/ErrorRecordsCount) and data($auditServiceRequest1/ErrorRecordsCount)!="") then
                 xs:decimal($auditServiceRequest1/ErrorRecordsCount) 
                else 0}</ns0:errorRecordsCount>
                <ns0:processStartTimestamp>{ 
                if(exists($auditServiceRequest1/ProcessStartTimeStamp) and data($auditServiceRequest1/ProcessStartTimeStamp)!="") then
                xs:dateTime($auditServiceRequest1/ProcessStartTimeStamp)
                else() }</ns0:processStartTimestamp>
                {
                    for $InstanceId in $auditServiceRequest1/InstanceId
                    return
                        <ns0:instanceId>{ data($InstanceId) }</ns0:instanceId>
                }
                <ns0:domain>{ data($auditServiceRequest1/Domain) }</ns0:domain>
                {
                    for $FileName in $auditServiceRequest1/FileName
                    return
                        <ns0:fileName>{ data($FileName) }</ns0:fileName>
                }
                <ns0:logDttm>{ fn:current-dateTime() }</ns0:logDttm>
            </ns0:NkeMiddlewareAuditLog>
        </ns0:NkeMiddlewareAuditLogCollection>
};

declare variable $auditServiceRequest1 as element(ns1:AuditServiceRequest) external;

xf:AuditServicePrrocessor_XQ_1($auditServiceRequest1)