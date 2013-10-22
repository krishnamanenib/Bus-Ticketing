(:: pragma bea:global-element-parameter parameter="$alertMessage1" element="ns0:AlertMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AlertMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AlertMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AlertMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace xf = "http://tempuri.org/OSB%20Project%201/CommonserviceAlertProcTrimXQ_1.00/";

declare function xf:CommonserviceAlertProcTrimXQ_1($alertMessage1 as element(ns0:AlertMessage))
    as element(ns0:AlertMessage) {
        <ns0:AlertMessage>
            <ns0:Header>
                <ns0:PlatformName>{ substring(fn-bea:trim(data($alertMessage1/ns0:Header/ns0:PlatformName)),1,20) }</ns0:PlatformName>
                <ns0:ServiceName>{ substring(fn-bea:trim(data($alertMessage1/ns0:Header/ns0:ServiceName)),1,50) }</ns0:ServiceName>
                {
                    for $ServiceID in $alertMessage1/ns0:Header/ns0:ServiceID
                    return
                        if (fn:string-length($ServiceID) != 0) then
                        <ns0:ServiceID>{ data($ServiceID) }</ns0:ServiceID>
                        else
                        ()
                }
            </ns0:Header>
            <ns0:Body>
                {
                    for $LinkID in $alertMessage1/ns0:Body/ns0:LinkID
                    return
                        if (fn:string-length($LinkID) != 0) then
                        <ns0:LinkID>{ data($LinkID) }</ns0:LinkID>
                        else()
                }
                {
                    for $SenderText in $alertMessage1/ns0:Body/ns0:SenderText
                    return
                        <ns0:SenderText>{ substring(fn-bea:trim(data($SenderText)),1,50) }</ns0:SenderText>
                }
                <ns0:ServerName>{ substring(fn-bea:trim(data($alertMessage1/ns0:Body/ns0:ServerName)),1,20) }</ns0:ServerName>
                <ns0:ServerTimestamp>{ data($alertMessage1/ns0:Body/ns0:ServerTimestamp) }</ns0:ServerTimestamp>
                {
                    for $TrackingIDText in $alertMessage1/ns0:Body/ns0:TrackingIDText
                    return
                        <ns0:TrackingIDText>{ substring(fn-bea:trim(data($TrackingIDText)),1,255) }</ns0:TrackingIDText>
                }
                <ns0:BusinessKeyName>{ substring(fn-bea:trim(data($alertMessage1/ns0:Body/ns0:BusinessKeyName)),1,200) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ substring(fn-bea:trim(data($alertMessage1/ns0:Body/ns0:BusinessKeyText)),1,200) }</ns0:BusinessKeyText>
                {
                    for $FileName in $alertMessage1/ns0:Body/ns0:FileName
                    return
                        <ns0:FileName>{ substring(fn-bea:trim(data($FileName)),1,80) }</ns0:FileName>
                }
                {
                    for $ErrorCode in $alertMessage1/ns0:Body/ns0:ErrorCode
                    return
                        <ns0:ErrorCode>{ substring(fn-bea:trim(data($ErrorCode)),1,50) }</ns0:ErrorCode>
                }
                {
                    for $BusinessEvent in $alertMessage1/ns0:Body/ns0:BusinessEvent
                    return
                        <ns0:BusinessEvent>{ substring(fn-bea:trim(data($BusinessEvent)),1,20) }</ns0:BusinessEvent>
                }
                <ns0:AlertTypeCode>{ substring(fn-bea:trim(data($alertMessage1/ns0:Body/ns0:AlertTypeCode)),1,20) }</ns0:AlertTypeCode>
                {
                    for $Message in $alertMessage1/ns0:Body/ns0:Message
                    return
                        <ns0:Message>{ substring(fn-bea:trim(data($Message)),1,4000) }</ns0:Message>
                }
                {
                    for $StageName in $alertMessage1/ns0:Body/ns0:StageName
                    return
                        <ns0:StageName>{ substring(fn-bea:trim(data($StageName)),1,50) }</ns0:StageName>
                }
                {
                    for $RetryCount in $alertMessage1/ns0:Body/ns0:RetryCount
                    return
                    if (fn:string-length($RetryCount) != 0) then
                        <ns0:RetryCount>{ data($RetryCount) }</ns0:RetryCount>
                        else()
                }
            </ns0:Body>
        </ns0:AlertMessage>
};

declare variable $alertMessage1 as element(ns0:AlertMessage) external;

xf:CommonserviceAlertProcTrimXQ_1($alertMessage1)