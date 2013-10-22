xquery version "1.0" encoding "Cp1252";
declare namespace xf = "http://tempuri.org/Errorhandler_Listener_Sub_1.00/src/osb/resources/xqueries/writeLocation/";
declare function xf:dvmLookup($protocolType as xs:string)
    as xs:string {
    	let $dvmData := doc("!!osb.file.confdir.enterprise!!/FileWriteLocations.dvm")
    	let $value := $dvmData/*:dvm/*:rows/*:row[*:cell[1]=$protocolType]/*:cell[2]    	
    	return
    	if (fn:string-length($value) > 0) then
    	$value
    	else
    	$dvmData/*:dvm/*:rows/*:row[*:cell[1]='Default']/*:cell[2]
};

declare function xf:writeLocation($protocolType as xs:string)
    as xs:string {
        xf:dvmLookup($protocolType)
};

declare variable $protocolType as xs:string external;
xf:writeLocation($protocolType)