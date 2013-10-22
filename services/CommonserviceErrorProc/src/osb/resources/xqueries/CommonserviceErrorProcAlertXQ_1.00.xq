(:: pragma bea:global-element-parameter parameter="$errorMessage1" element="ns0:ErrorMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/ErrorMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns1:AlertMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AlertMessageXSD_1.00.xsd" ::)

declare namespace ns1 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace xf = "http://tempuri.org/CommonserviceErrorProc_1.00/src/osb/resources/xqueries/CommonserviceErrorProcAlertXQ_1.00/";

declare function xf:CommonserviceErrorProcAlertXQ_1($errorMessage1 as element(ns0:ErrorMessage),
    $alertType as xs:string)
    as element(ns1:AlertMessage) {
        <ns1:AlertMessage>
            <ns1:Header>
                <ns1:PlatformName>{ data($errorMessage1/ns0:Header/ns0:PlatformName) }</ns1:PlatformName>
                <ns1:ServiceName>{ data($errorMessage1/ns0:Header/ns0:ServiceName) }</ns1:ServiceName>
                {
                    for $ServiceID in $errorMessage1/ns0:Header/ns0:ServiceID
                    return
                        <ns1:ServiceID>{ data($ServiceID) }</ns1:ServiceID>
                }
            </ns1:Header>
            <ns1:Body>
                {
                    for $LinkID in $errorMessage1/ns0:Body/ns0:LinkID
                    return
                        <ns1:LinkID>{ data($LinkID) }</ns1:LinkID>
                }
                {
                    for $SenderText in $errorMessage1/ns0:Body/ns0:SenderText
                    return
                        <ns1:SenderText>{ data($SenderText) }</ns1:SenderText>
                }
                <ns1:ServerName>{ data($errorMessage1/ns0:Body/ns0:ServerName) }</ns1:ServerName>
                <ns1:ServerTimestamp>{ data($errorMessage1/ns0:Body/ns0:ServerTimestamp) }</ns1:ServerTimestamp>
                {
                    for $TrackingIDText in $errorMessage1/ns0:Body/ns0:TrackingIDText
                    return
                        <ns1:TrackingIDText>{ data($TrackingIDText) }</ns1:TrackingIDText>
                }
                <ns1:BusinessKeyName>{ data($errorMessage1/ns0:Body/ns0:BusinessKeyName) }</ns1:BusinessKeyName>
                <ns1:BusinessKeyText>{ data($errorMessage1/ns0:Body/ns0:BusinessKeyText) }</ns1:BusinessKeyText>
                {
                    for $Filename in $errorMessage1/ns0:Body/ns0:Filename
                    return
                        <ns1:FileName>{ data($Filename) }</ns1:FileName>
                }
                <ns1:ErrorCode>{ data($errorMessage1/ns0:Body/ns0:ErrorCode) }</ns1:ErrorCode>
                <ns1:AlertTypeCode>{ $alertType }</ns1:AlertTypeCode>
                <ns1:Message>{ data($errorMessage1/ns0:Body/ns0:MessageText) }</ns1:Message>
                {
                    for $StageName in $errorMessage1/ns0:Body/ns0:StageName
                    return
                        <ns1:StageName>{ data($StageName) }</ns1:StageName>
                }
                {
                    
		                      if(fn:string-length(data($errorMessage1/ns0:JMSHeader/ns0:JMSDeliveryCount))>0) then
		                      for $JMSDeliveryCount in $errorMessage1/ns0:JMSHeader/ns0:JMSDeliveryCount
		                      return
		                      		                     
		                          <ns1:RetryCount>{ data($JMSDeliveryCount) }</ns1:RetryCount>
		                          else 
		                          <ns1:RetryCount>0</ns1:RetryCount>
                }
            </ns1:Body>
        </ns1:AlertMessage>
};

declare variable $errorMessage1 as element(ns0:ErrorMessage) external;
declare variable $alertType as xs:string external;

xf:CommonserviceErrorProcAlertXQ_1($errorMessage1,
    $alertType)