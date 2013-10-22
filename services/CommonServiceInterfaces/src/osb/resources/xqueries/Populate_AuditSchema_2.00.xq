(:: pragma bea:global-element-return element="ns0:AuditMessage" location="../schemas/AuditMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/audit/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/src/osb/resources/xqueries/Populate_AuditSchema/";
declare namespace sour = "http://www.nike.com/StaticVariables";

declare function xf:Populate_AuditSchema(
    $serviceName as xs:string,
    $serviceID as xs:string,
    $serverName as xs:string,
    $errorCode as xs:string?,
    $eventTypeCode as xs:string,
	$staticVariable as element()
    )
    as element(ns0:AuditMessage) {
    
        <ns0:AuditMessage>
            <ns0:Header>
                <ns0:PlatformName>{  data($staticVariable/sour:PlatformName) }</ns0:PlatformName>
                <ns0:ServiceName>{ $serviceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $serviceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{  data($staticVariable/sour:LinkID)  }</ns0:LinkID>
                <ns0:SenderText>{ data($staticVariable/sour:SenderText) }</ns0:SenderText>
                <ns0:SendingApplicationText>{ data($staticVariable/sour:SendingApplicationText) }</ns0:SendingApplicationText>
                <ns0:TargetApplicationText>{ data($staticVariable/sour:TargetApplicationText)  }</ns0:TargetApplicationText>
                <ns0:ServerName>{ $serverName }</ns0:ServerName>
                <ns0:ServerTimestamp>{fn:current-dateTime()}</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{data($staticVariable/sour:TrackID)}</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{data($staticVariable/sour:BKeyName) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ data($staticVariable/sour:BKeyText)   }</ns0:BusinessKeyText>
                <ns0:Filename>{ data($staticVariable/sour:FileName)  }</ns0:Filename>
                <ns0:ErrorCode>{ $errorCode }</ns0:ErrorCode>
                <ns0:EventTypeCode>{ $eventTypeCode }</ns0:EventTypeCode>
            </ns0:Body>
        </ns0:AuditMessage>
};


declare variable $serviceName as xs:string external;
declare variable $serviceID as xs:string external;
declare variable $serverName as xs:string external;
declare variable $errorCode as xs:string external;
declare variable $eventTypeCode as xs:string external;
declare variable $staticVariable as element() external;



xf:Populate_AuditSchema(
    $serviceName,
    $serviceID,
    $serverName,
    $errorCode,
    $eventTypeCode,
    $staticVariable)