(:: pragma bea:global-element-return element="ns0:AlertMessage" location="../schemas/AlertMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/AlertService/src/osb/resources/xquery/Populate_AlertSchema/";
declare namespace sour = "http://www.nike.com/StaticVariables";

declare function xf:Populate_AlertSchema(
    $serviceName as xs:string,
    $serviceID as xs:string,
    $serverName as xs:string,
    $errorCode as xs:string?,
    $businessEvent as xs:string?,
    $alertTypeCode as xs:string,
    $message as xs:string?,
    $stageName as xs:string,
    $retryCount as xs:string,
    $staticVariable as element()
    )
    as element(ns0:AlertMessage) {
        <ns0:AlertMessage>
            <ns0:Header>
                <ns0:PlatformName>{data($staticVariable/sour:PlatformName)}</ns0:PlatformName>
                <ns0:ServiceName>{ $serviceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $serviceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{ data($staticVariable/sour:LinkID) }</ns0:LinkID>
                <ns0:SenderText>{ data($staticVariable/sour:SenderText) }</ns0:SenderText>
                <ns0:ServerName>{ $serverName }</ns0:ServerName>
                <ns0:ServerTimestamp>{ fn:current-dateTime() }</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{ data($staticVariable/sour:TrackID) }</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{data($staticVariable/sour:BKeyName)}</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{data($staticVariable/sour:BKeyText) }</ns0:BusinessKeyText>
                <ns0:FileName>{ data($staticVariable/sour:FileName)  }</ns0:FileName>
                <ns0:ErrorCode>{ $errorCode }</ns0:ErrorCode>
                <ns0:BusinessEvent>{ $businessEvent }</ns0:BusinessEvent>
                <ns0:AlertTypeCode>{ $alertTypeCode }</ns0:AlertTypeCode>
                <ns0:Message>{ $message }</ns0:Message>
                <ns0:StageName>{ $stageName }</ns0:StageName>
                <ns0:RetryCount>{ $retryCount }</ns0:RetryCount>
            </ns0:Body>
        </ns0:AlertMessage>
};


declare variable $serviceName as xs:string external;
declare variable $serviceID as xs:string external;
declare variable $serverName as xs:string external;
declare variable $errorCode as xs:string external;
declare variable $businessEvent as xs:string external;
declare variable $alertTypeCode as xs:string external;
declare variable $message as xs:string external;
declare variable $stageName as xs:string external;
declare variable $retryCount as xs:string external;
declare variable $staticVariable as element() external;

xf:Populate_AlertSchema(
	$serviceName,
    $serviceID,
    $serverName,
    $errorCode,
    $businessEvent,
    $alertTypeCode,
    $message,
    $stageName,
    $retryCount,
    $staticVariable
    )