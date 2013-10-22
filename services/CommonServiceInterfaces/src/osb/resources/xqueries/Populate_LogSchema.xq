(:: pragma bea:global-element-return element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/src/osb/resources/xqueries/Populate_LogSchema/";

declare function xf:Populate_LogSchema($PlatformName as xs:string,
    $ServiceName as xs:string,
    $ServiceID as xs:string,
    $LinkID as xs:string,
    $ServerName as xs:string,
    $TrackingIDText as xs:string,
    $BKeyName as xs:string,
    $BKeyText as xs:string,
    $MessageText as xs:string,
    $LogLevelCode as xs:string,
    $StackTraceText as xs:string)
    as element(ns0:LogMessage) {
        <ns0:LogMessage>
            <ns0:Header>
                <ns0:PlatformName>{ $PlatformName }</ns0:PlatformName>
                <ns0:ServiceName>{ $ServiceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $ServiceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{ $LinkID }</ns0:LinkID>
                <ns0:ServerName>{ $ServerName }</ns0:ServerName>
                <ns0:ServerTimestamp>{fn:current-dateTime()}</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{ $TrackingIDText }</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{ $BKeyName }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ $BKeyText }</ns0:BusinessKeyText>
                <ns0:MessageText>{ $MessageText }</ns0:MessageText>
                <ns0:LogLevelCode>{ $LogLevelCode }</ns0:LogLevelCode>
                <ns0:StackTraceText>{ $StackTraceText }</ns0:StackTraceText>
            </ns0:Body>
        </ns0:LogMessage>
};

declare variable $PlatformName as xs:string external;
declare variable $ServiceName as xs:string external;
declare variable $ServiceID as xs:string external;
declare variable $LinkID as xs:string external;
declare variable $ServerName as xs:string external;
declare variable $TrackingIDText as xs:string external;
declare variable $BKeyName as xs:string external;
declare variable $BKeyText as xs:string external;
declare variable $MessageText as xs:string external;
declare variable $LogLevelCode as xs:string external;
declare variable $StackTraceText as xs:string external;

xf:Populate_LogSchema($PlatformName,
    $ServiceName,
    $ServiceID,
    $LinkID,
    $ServerName,
    $TrackingIDText,
    $BKeyName,
    $BKeyText,
    $MessageText,
    $LogLevelCode,
    $StackTraceText)