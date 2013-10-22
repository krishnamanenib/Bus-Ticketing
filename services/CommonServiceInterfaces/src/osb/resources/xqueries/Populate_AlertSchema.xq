(:: pragma bea:global-element-return element="ns0:AlertMessage" location="../schemas/AlertMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/AlertService/src/osb/resources/xquery/Populate_AlertSchema/";

declare function xf:Populate_AlertSchema($PlatformName as xs:string,
    $ServiceName as xs:string,
    $ServiceID as xs:string,
    $LinkID as xs:string,
    $SenderText as xs:string,
    $ServerName as xs:string,
    $TrackingIDText as xs:string,
    $BKeyName as xs:string,
    $BkeyText as xs:string,
    $FileName as xs:string,
    $ErrorCode as xs:string,
    $BusinessEvent as xs:string,
    $AlertTypeCode as xs:string,
    $Message as xs:string,
    $StageName as xs:string,
    $RetryCount as xs:string)
    as element(ns0:AlertMessage) {
        <ns0:AlertMessage>
            <ns0:Header>
                <ns0:PlatformName>{ $PlatformName }</ns0:PlatformName>
                <ns0:ServiceName>{ $ServiceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $ServiceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{ $LinkID }</ns0:LinkID>
                <ns0:SenderText>{ $SenderText }</ns0:SenderText>
                <ns0:ServerName>{ $ServerName }</ns0:ServerName>
                <ns0:ServerTimestamp>{ fn:current-dateTime() }</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{ $TrackingIDText }</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{ $BKeyName }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ $BkeyText }</ns0:BusinessKeyText>
                <ns0:FileName>{ $FileName }</ns0:FileName>
                <ns0:ErrorCode>{ $ErrorCode }</ns0:ErrorCode>
                <ns0:BusinessEvent>{ $BusinessEvent }</ns0:BusinessEvent>
                <ns0:AlertTypeCode>{ $AlertTypeCode }</ns0:AlertTypeCode>
                <ns0:Message>{ $Message }</ns0:Message>
                <ns0:StageName>{ $StageName }</ns0:StageName>
                <ns0:RetryCount>{ $RetryCount }</ns0:RetryCount>
            </ns0:Body>
        </ns0:AlertMessage>
};

declare variable $PlatformName as xs:string external;
declare variable $ServiceName as xs:string external;
declare variable $ServiceID as xs:string external;
declare variable $LinkID as xs:string external;
declare variable $SenderText as xs:string external;
declare variable $ServerName as xs:string external;
declare variable $TrackingIDText as xs:string external;
declare variable $BKeyName as xs:string external;
declare variable $BkeyText as xs:string external;
declare variable $FileName as xs:string external;
declare variable $ErrorCode as xs:string external;
declare variable $BusinessEvent as xs:string external;
declare variable $AlertTypeCode as xs:string external;
declare variable $Message as xs:string external;
declare variable $StageName as xs:string external;
declare variable $RetryCount as xs:string external;

xf:Populate_AlertSchema($PlatformName,
    $ServiceName,
    $ServiceID,
    $LinkID,
    $SenderText,
    $ServerName,
    $TrackingIDText,
    $BKeyName,
    $BkeyText,
    $FileName,
    $ErrorCode,
    $BusinessEvent,
    $AlertTypeCode,
    $Message,
    $StageName,
    $RetryCount)