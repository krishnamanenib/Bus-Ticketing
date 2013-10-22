(:: pragma bea:schema-type-return type="ns0:StaticFields" location="../schemas/StaticVariable.xsd" ::)

declare namespace ns0 = "http://www.example.org/Source";
declare namespace xf = "http://tempuri.org/ImplementingFET/PopulateHeaderStatic/";

declare function xf:PopulateHeaderStatic($platformName as xs:string,
    $serviceName as xs:string,
    $linkID as xs:string,
    $trackID as xs:string,
    $BKeyName as xs:string,
    $BKeyText as xs:string,
    $SendingApplicationText as xs:string,
    $TargetApplicationText as xs:string,
    $SenderText as xs:string,
    $FileName as xs:string)
    as element() {
        <ns0:StaticFields>
            <ns0:PlatformName>{ $platformName }</ns0:PlatformName>
            <ns0:ServiceName>{ $serviceName }</ns0:ServiceName>
            <ns0:LinkID>{ $linkID }</ns0:LinkID>
            <ns0:TrackID>{ $trackID }</ns0:TrackID>
            <ns0:BKeyName>{ $BKeyName }</ns0:BKeyName>
            <ns0:BKeyText>{$BKeyText}</ns0:BKeyText>
            <ns0:SendingApplicationText>{$SendingApplicationText}</ns0:SendingApplicationText>
            <ns0:TargetApplicationText>{$TargetApplicationText}</ns0:TargetApplicationText>
            <ns0:SenderText>{$SenderText}</ns0:SenderText>
            <ns0:FileName>{$FileName}</ns0:FileName>
        </ns0:StaticFields>
};

declare variable $platformName as xs:string external;
declare variable $serviceName as xs:string external;
declare variable $linkID as xs:string external;
declare variable $trackID as xs:string external;
declare variable $BKeyName as xs:string external;
declare variable $BKeyText as xs:string external;
declare variable $SendingApplicationText as xs:string external;
declare variable $TargetApplicationText as xs:string external;
declare variable $SenderText as xs:string external;
declare variable $FileName as xs:string external;

xf:PopulateHeaderStatic($platformName,
    $serviceName,
    $linkID,
    $trackID,
    $BKeyName,
    $BKeyText,
    $SendingApplicationText,
    $TargetApplicationText,
    $SenderText,
    $FileName)
