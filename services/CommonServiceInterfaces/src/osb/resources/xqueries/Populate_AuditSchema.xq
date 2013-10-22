(:: pragma bea:global-element-return element="ns0:AuditMessage" location="../schemas/AuditMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/audit/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/src/osb/resources/xqueries/Populate_AuditSchema/";

declare function xf:Populate_AuditSchema($PlatformName as xs:string,
    $ServiceName as xs:string,
    $ServiceID as xs:string,
    $LinkID as xs:string,
    $SenderText as xs:string,
    $SendingApplicationText as xs:string,
    $TargetApplicationText as xs:string,
    $ServerName as xs:string,
    $TrackingIDText as xs:string,
    $BKeyName as xs:string,
    $BKeyText as xs:string,
    $Filename as xs:string,
    $ErrorCode as xs:string,
    $EventTypeCode as xs:string)
    as element(ns0:AuditMessage) {
        <ns0:AuditMessage>
            <ns0:Header>
                <ns0:PlatformName>{ $PlatformName }</ns0:PlatformName>
                <ns0:ServiceName>{ $ServiceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $ServiceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{ $LinkID }</ns0:LinkID>
                <ns0:SenderText>{ $SenderText }</ns0:SenderText>
                <ns0:SendingApplicationText>{ $SendingApplicationText }</ns0:SendingApplicationText>
                <ns0:TargetApplicationText>{ $TargetApplicationText }</ns0:TargetApplicationText>
                <ns0:ServerName>{ $ServerName }</ns0:ServerName>
                <ns0:ServerTimestamp>{fn:current-dateTime()}</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{ $TrackingIDText }</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{ $BKeyName }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ $BKeyText }</ns0:BusinessKeyText>
                <ns0:Filename>{ $Filename }</ns0:Filename>
                <ns0:ErrorCode>{ $ErrorCode }</ns0:ErrorCode>
                <ns0:EventTypeCode>{ $EventTypeCode }</ns0:EventTypeCode>
            </ns0:Body>
        </ns0:AuditMessage>
};

declare variable $PlatformName as xs:string external;
declare variable $ServiceName as xs:string external;
declare variable $ServiceID as xs:string external;
declare variable $LinkID as xs:string external;
declare variable $SenderText as xs:string external;
declare variable $SendingApplicationText as xs:string external;
declare variable $TargetApplicationText as xs:string external;
declare variable $ServerName as xs:string external;
declare variable $TrackingIDText as xs:string external;
declare variable $BKeyName as xs:string external;
declare variable $BKeyText as xs:string external;
declare variable $Filename as xs:string external;
declare variable $ErrorCode as xs:string external;
declare variable $EventTypeCode as xs:string external;

xf:Populate_AuditSchema($PlatformName,
    $ServiceName,
    $ServiceID,
    $LinkID,
    $SenderText,
    $SendingApplicationText,
    $TargetApplicationText,
    $ServerName,
    $TrackingIDText,
    $BKeyName,
    $BKeyText,
    $Filename,
    $ErrorCode,
    $EventTypeCode)