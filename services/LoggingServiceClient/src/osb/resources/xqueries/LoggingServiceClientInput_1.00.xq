(:: pragma bea:global-element-return element="ns0:LoggingServiceRequest" location="../wsdls/LoggingService_1.00.wsdl" ::)

declare namespace ns0 = "http://www.nike.com/LoggingService/";
declare namespace xf = "http://tempuri.org/LoggingServiceClient/src/osb/resources/xquery/LoggingServiceClientInput_1.00/";

declare function xf:LoggingServiceClientInput_1($Platform as xs:string,
    $ServiceName as xs:string,
    $ServiceId as xs:string,
    $Description as xs:string,
    $Trace as xs:string,
    $Severity as xs:string,
    $SystemId as xs:string,
    $InstanceId as xs:string,
    $Domain as xs:string,
    $FileName as xs:string,
    $BusinessKey as xs:string,
    $TransactionId as xs:string,
    $SubjectArea as xs:string)
    as element(ns0:LoggingServiceRequest) {
        <ns0:LoggingServiceRequest>
            <Platform>{ $Platform }</Platform>
            <ServiceName>{ $ServiceName }</ServiceName>
            <ServiceId>{ $ServiceId }</ServiceId>
            <Description>{ $Description }</Description>
            <Trace>{ $Trace }</Trace>
            <Severity>{ $Severity }</Severity>
            <SystemId>{ $SystemId }</SystemId>
            <InstanceId>{ $InstanceId }</InstanceId>
            <Domain>{ $Domain }</Domain>
            <FileName>{ $FileName }</FileName>
            <BusinessKey>{ $BusinessKey }</BusinessKey>
            <TransactionId>{ $TransactionId }</TransactionId>
            <SubjectArea>{ $SubjectArea }</SubjectArea>
        </ns0:LoggingServiceRequest>
};

declare variable $Platform as xs:string external;
declare variable $ServiceName as xs:string external;
declare variable $ServiceId as xs:string external;
declare variable $Description as xs:string external;
declare variable $Trace as xs:string external;
declare variable $Severity as xs:string external;
declare variable $SystemId as xs:string external;
declare variable $InstanceId as xs:string external;
declare variable $Domain as xs:string external;
declare variable $FileName as xs:string external;
declare variable $BusinessKey as xs:string external;
declare variable $TransactionId as xs:string external;
declare variable $SubjectArea as xs:string external;

xf:LoggingServiceClientInput_1($Platform,
    $ServiceName,
    $ServiceId,
    $Description,
    $Trace,
    $Severity,
    $SystemId,
    $InstanceId,
    $Domain,
    $FileName,
    $BusinessKey,
    $TransactionId,
    $SubjectArea)