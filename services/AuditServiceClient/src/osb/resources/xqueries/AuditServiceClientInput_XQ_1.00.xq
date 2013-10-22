(:: pragma bea:global-element-return element="ns0:AuditServiceRequest" location="../wsdls/AuditService_1.00.wsdl" ::)

declare namespace ns0 = "http://www.nike.com/AuditService/";
declare namespace xf = "http://tempuri.org/AuditServiceClient/src/osb/resources/xquery/AuditServiceClientInput_XQ_1.00_1/";

declare function xf:AuditServiceClientInput_XQ_1($Platform as xs:string,
    $ServiceName as xs:string,
    $ServiceId as xs:string,
    $TransactionId as xs:string,
    $BusinessKey as xs:string,
    $SystemId as xs:string,
    $RecievedRecordsCount as xs:string,
    $ErrorRecordsCount as xs:string,
    $ProcessStartTimeStamp as xs:dateTime,
    $InstanceId as xs:string,
    $Domain as xs:string,
    $FileName as xs:string)
    as element(ns0:AuditServiceRequest) {
        <ns0:AuditServiceRequest>
            <Platform>{ $Platform }</Platform>
            <ServiceName>{ $ServiceName }</ServiceName>
            <ServiceId>{ $ServiceId }</ServiceId>
            <TransactionId>{ $TransactionId }</TransactionId>
            <BusinessKey>{ $BusinessKey }</BusinessKey>
            <SystemId>{ $SystemId }</SystemId>
            <RecievedRecordsCount>{ $RecievedRecordsCount }</RecievedRecordsCount>
            <ErrorRecordsCount>{ $ErrorRecordsCount }</ErrorRecordsCount>
            <ProcessStartTimeStamp>
                {
                    if (fn:boolean("true")) then
                        ($ProcessStartTimeStamp)
                    else 
                        ()
                }
</ProcessStartTimeStamp>
            <InstanceId>{ $InstanceId }</InstanceId>
            <Domain>{ $Domain }</Domain>
            <FileName>{ $FileName }</FileName>
        </ns0:AuditServiceRequest>
};

declare variable $Platform as xs:string external;
declare variable $ServiceName as xs:string external;
declare variable $ServiceId as xs:string external;
declare variable $TransactionId as xs:string external;
declare variable $BusinessKey as xs:string external;
declare variable $SystemId as xs:string external;
declare variable $RecievedRecordsCount as xs:string external;
declare variable $ErrorRecordsCount as xs:string external;
declare variable $ProcessStartTimeStamp as xs:dateTime external;
declare variable $InstanceId as xs:string external;
declare variable $Domain as xs:string external;
declare variable $FileName as xs:string external;

xf:AuditServiceClientInput_XQ_1($Platform,
    $ServiceName,
    $ServiceId,
    $TransactionId,
    $BusinessKey,
    $SystemId,
    $RecievedRecordsCount,
    $ErrorRecordsCount,
    $ProcessStartTimeStamp,
    $InstanceId,
    $Domain,
    $FileName)