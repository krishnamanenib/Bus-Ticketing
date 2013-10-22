(:: pragma bea:global-element-parameter parameter="$middlewareCommonAlertCollection1" element="ns1:MiddlewareCommonAlertCollection" location="../schema/CommonserviceAlertProcDBPoll_1_00_table.xsd" ::)
(:: pragma bea:global-element-return element="ns0:AlertMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AlertMessageXSD_1.00.xsd" ::)

declare namespace ns1 = "http://xmlns.oracle.com/pcbpel/adapter/db/top/CommonserviceAlertProcDBPoll_1/00";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace xf = "http://tempuri.org/CommonservicesAlertProc/src/osb/resources/xqueries/CommonserviceAlertProcConstructAlertMessageXQ_1.00/";

declare function xf:CommonserviceAlertProcConstructAlertMessageXQ_1($middlewareCommonAlertCollection1 as element(ns1:MiddlewareCommonAlertCollection))
    as element(ns0:AlertMessage) {
        <ns0:AlertMessage>
            <ns0:Header>
                <ns0:PlatformName>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:platformName) }</ns0:PlatformName>
                <ns0:ServiceName>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:serviceName) }</ns0:ServiceName>
                <ns0:ServiceID>{ 
                if (fn:string-length($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:serviceId) != 0) then
                fn-bea:decimal-round(data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:serviceId))
                else
                ()
             }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{
                    if (fn:string-length($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:linkId) != 0) then
                fn-bea:decimal-round(data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:linkId))
                else
                ()
                }</ns0:LinkID>
                {
                    for $senderText in $middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:senderText
                    return
                        <ns0:SenderText>{ data($senderText) }</ns0:SenderText>
                }
                <ns0:ServerName>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:serverName) }</ns0:ServerName>
                <ns0:ServerTimestamp>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:serverTimestamp) }</ns0:ServerTimestamp>
                {
                    for $trackingidText in $middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:trackingidText
                    return
                        <ns0:TrackingIDText>{ data($trackingidText) }</ns0:TrackingIDText>
                }
                <ns0:BusinessKeyName>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:businesskeyName) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:businesskeyText) }</ns0:BusinessKeyText>
                {
                    for $filename in $middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:filename
                    return
                        <ns0:FileName>{ data($filename) }</ns0:FileName>
                }
                {
                    for $errorCode in $middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:errorCode
                    return
                        <ns0:ErrorCode>{ data($errorCode) }</ns0:ErrorCode>
                }                
                <ns0:AlertTypeCode>{ data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:alerttypeCode) }</ns0:AlertTypeCode>
                {
                    for $messageText in $middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:messageText
                    return
                        <ns0:Message>{ data($messageText) }</ns0:Message>
                }
                {
                    for $stageName in $middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:stageName
                    return
                        <ns0:StageName>{ data($stageName) }</ns0:StageName>
                }
                <ns0:RetryCount>{ 
                    if (fn:string-length($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:retryCount) != 0) then
                fn-bea:decimal-round(data($middlewareCommonAlertCollection1/ns1:MiddlewareCommonAlert[1]/ns1:retryCount))
                else
                ()
                 }</ns0:RetryCount>
            </ns0:Body>
        </ns0:AlertMessage>
};

declare variable $middlewareCommonAlertCollection1 as element(ns1:MiddlewareCommonAlertCollection) external;

xf:CommonserviceAlertProcConstructAlertMessageXQ_1($middlewareCommonAlertCollection1)