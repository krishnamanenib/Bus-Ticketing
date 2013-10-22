(:: pragma bea:global-element-return element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace xf = "http://nike.org/CommonServiceInterfaces/src/osb/resources/xqueries/Populate_LogSchema/";
declare namespace sour = "http://www.nike.com/StaticVariables";

declare function xf:Populate_LogSchema(
    $serviceName as xs:string,
    $serviceID as xs:string,
    $serverName as xs:string,
    $messageText as xs:string,
    $logLevelCode as xs:string,
    $stackTraceText as xs:string?,
    $staticVariable as element()
    )
    as element(ns0:LogMessage) {
        <ns0:LogMessage>
            <ns0:Header>
                <ns0:PlatformName>{  data($staticVariable/sour:PlatformName) }</ns0:PlatformName>
                <ns0:ServiceName>{ $serviceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $serviceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{  data($staticVariable/sour:LinkID) }</ns0:LinkID>
                <ns0:ServerName>{ $serverName }</ns0:ServerName>
                <ns0:ServerTimestamp>{fn:current-dateTime()}</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{  data($staticVariable/sour:TrackID)}</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{ data($staticVariable/sour:BKeyName)}</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ data($staticVariable/sour:BKeyText)  }</ns0:BusinessKeyText>
                <ns0:MessageText>{ $messageText }</ns0:MessageText>
                <ns0:LogLevelCode>{ $logLevelCode }</ns0:LogLevelCode>
                <ns0:StackTraceText>{ $stackTraceText }</ns0:StackTraceText>
            </ns0:Body>
        </ns0:LogMessage>
};
declare variable $serviceName as xs:string external;
declare variable $serviceID as xs:string external;
declare variable $serverName as xs:string external;
declare variable $messageText as xs:string external;
declare variable $logLevelCode as xs:string external;
declare variable $stackTraceText as xs:string external;
declare variable $staticVariable as element() external;

xf:Populate_LogSchema(
    $serviceName,
    $serviceID,
    $serverName,
    $messageText,
    $logLevelCode,
    $stackTraceText,
    $staticVariable
    )