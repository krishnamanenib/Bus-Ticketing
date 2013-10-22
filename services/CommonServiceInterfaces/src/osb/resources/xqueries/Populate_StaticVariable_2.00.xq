(:: pragma bea:schema-type-return type="ns0:StaticFields" location="../schemas/StaticVariable.xsd" ::)

declare namespace ns0 = "http://www.nike.com/StaticVariables";
declare namespace xf = "http://tempuri.org/ImplementingFET/PopulateHeaderStatic/";

declare function xf:PopulateHeaderStatic(
	$platformName as xs:string,
    $serviceName as xs:string,
    $linkID as xs:string?,
    $trackID as xs:string,
    $businessKeyName as xs:string,
    $businessKeyText as xs:string?,
    $sendingApplicationText as xs:string?,
    $targetApplicationText as xs:string?,
    $senderText as xs:string?,
    $fileName as xs:string ?)
    as element() {
        <ns0:StaticFields>
            <ns0:PlatformName>{ $platformName }</ns0:PlatformName>
            <ns0:ServiceName>{ $serviceName }</ns0:ServiceName>
            <ns0:LinkID>{ $linkID }</ns0:LinkID>
            <ns0:TrackID>{ $trackID }</ns0:TrackID>
            <ns0:BKeyName>{ $businessKeyName }</ns0:BKeyName>
            <ns0:BKeyText>{$businessKeyText}</ns0:BKeyText>
            <ns0:SendingApplicationText>{$sendingApplicationText}</ns0:SendingApplicationText>
            <ns0:TargetApplicationText>{$targetApplicationText}</ns0:TargetApplicationText>
            <ns0:SenderText>{$senderText}</ns0:SenderText>
            <ns0:FileName>{$fileName}</ns0:FileName>
        </ns0:StaticFields>
};

declare variable $platformName as xs:string external;
declare variable $serviceName as xs:string external;
declare variable $linkID as xs:string external;
declare variable $trackID as xs:string external;
declare variable $businessKeyName as xs:string external;
declare variable $businessKeyText as xs:string external;
declare variable $sendingApplicationText as xs:string external;
declare variable $targetApplicationText as xs:string external;
declare variable $senderText as xs:string external;
declare variable $fileName as xs:string external;

xf:PopulateHeaderStatic($platformName,
    $serviceName,
    $linkID,
    $trackID,
    $businessKeyName,
    $businessKeyText,
    $sendingApplicationText,
    $targetApplicationText,
    $senderText,
    $fileName)