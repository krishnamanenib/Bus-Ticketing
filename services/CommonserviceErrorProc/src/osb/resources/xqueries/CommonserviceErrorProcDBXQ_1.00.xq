(:: pragma bea:global-element-parameter parameter="$errorMessage1" element="ns1:ErrorMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/ErrorMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:MiddlewareCommonErrorCollection" location="../schemas/CommonserviceErrorProcDBAdpXsd_1.00.xsd" ::)

declare namespace ns1 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace ns0 = "http://xmlns.oracle.com/pcbpel/adapter/db/top/CommonserviceErrorProcConfigDB_1/00";
declare namespace xf = "http://tempuri.org/CommonserviceErrorProc_1.00/src/osb/resources/xqueries/CommonserviceErrorProcErrorDBXQ_1.00/";

declare function xf:CommonserviceErrorProcErrorDBXQ_1($errorMessage1 as element(ns1:ErrorMessage),$payload as xs:string)
    as element(ns0:MiddlewareCommonErrorCollection) {
        <ns0:MiddlewareCommonErrorCollection>
            <ns0:MiddlewareCommonError>
                <ns0:platformName>{ data($errorMessage1/ns1:Header/ns1:PlatformName) }</ns0:platformName>
                <ns0:serviceName>{ data($errorMessage1/ns1:Header/ns1:ServiceName) }</ns0:serviceName>
                <ns0:serviceId>
                 {   if (fn:string-length(data($errorMessage1/ns1:Header/ns1:ServiceID)) != 0) then
                xs:decimal(data($errorMessage1/ns1:Header/ns1:ServiceID)) 
               else
               ()}
               </ns0:serviceId>
                
                
                <ns0:linkId> 
                 {  
                  if (fn:string-length(data($errorMessage1/ns1:Body/ns1:LinkID)) != 0) then
                 xs:decimal(data($errorMessage1/ns1:Body/ns1:LinkID)) 
                 else()
                 }
                 </ns0:linkId>
                {
                    for $SenderText in $errorMessage1/ns1:Body/ns1:SenderText
                    return
                        <ns0:senderText>{ data($SenderText) }</ns0:senderText>
                }
                {
                    for $SendingApplicationText in $errorMessage1/ns1:Body/ns1:SendingApplicationText
                    return
                        <ns0:sendingApplicationText>{ data($SendingApplicationText) }</ns0:sendingApplicationText>
                }
                {
                    for $TargetApplicationText in $errorMessage1/ns1:Body/ns1:TargetApplicationText
                    return
                        <ns0:targetApplicationText>{ data($TargetApplicationText) }</ns0:targetApplicationText>
                }
                <ns0:serverName>{ data($errorMessage1/ns1:Body/ns1:ServerName) }</ns0:serverName>
                <ns0:serverTimestamp>{ data($errorMessage1/ns1:Body/ns1:ServerTimestamp) }</ns0:serverTimestamp>
                {
                    for $TrackingIDText in $errorMessage1/ns1:Body/ns1:TrackingIDText
                    return
                        <ns0:trackingidText>{ data($TrackingIDText) }</ns0:trackingidText>
                }
                <ns0:businesskeyName>{ data($errorMessage1/ns1:Body/ns1:BusinessKeyName) }</ns0:businesskeyName>
                <ns0:businesskeyText>{ data($errorMessage1/ns1:Body/ns1:BusinessKeyText) }</ns0:businesskeyText>
                <ns0:messageText>{ data($errorMessage1/ns1:Body/ns1:MessageText) }</ns0:messageText>
                <ns0:errorTypeCode>{ data($errorMessage1/ns1:Body/ns1:ErrorTypeCode) }</ns0:errorTypeCode>
                 <ns0:payloadText>{$payload}</ns0:payloadText>
                  <ns0:errorCode>{ data($errorMessage1/ns1:Body/ns1:ErrorCode) }</ns0:errorCode>
                {
                      for $Filename in $errorMessage1/ns1:Body/ns1:Filename
                     return
                         <ns0:filename>{ data($Filename) }</ns0:filename>
                 }
                 {
                     for $StackTraceText in $errorMessage1/ns1:Body/ns1:StackTraceText
                    return
                        <ns0:stacktraceText>{ data($StackTraceText) }</ns0:stacktraceText>
                 }
                 {
                     for $StageName in $errorMessage1/ns1:Body/ns1:StageName
                     return
                         <ns0:stageName>{ data($StageName) }</ns0:stageName>
                }
                           {
                     for $JMSDestinationText in $errorMessage1/ns1:JMSHeader/ns1:JMSDestinationText
                     return
                         <ns0:jmsDestinationText>{ data($JMSDestinationText) }</ns0:jmsDestinationText>
                 }
                 {
                     for $JMSDeliveryModeText in $errorMessage1/ns1:JMSHeader/ns1:JMSDeliveryModeText
                     return
                         <ns0:jmsDeliverymodeText>{ data($JMSDeliveryModeText) }</ns0:jmsDeliverymodeText>
                 }
                 {
                     for $JMSMessageID in $errorMessage1/ns1:JMSHeader/ns1:JMSMessageID
                     return
                         <ns0:jmsMessageId>{ data($JMSMessageID) }</ns0:jmsMessageId>
                 }
                 {
                     for $JMSTimestamp in $errorMessage1/ns1:JMSHeader/ns1:JMSTimestamp
                     return
                         <ns0:jmsTimestamp>{ data($JMSTimestamp) }</ns0:jmsTimestamp>
                }
                 <ns0:jmsExpirationTime>{
                    if (fn:string-length(data($errorMessage1/ns1:JMSHeader/ns1:JMSExpirationTime)) != 0) then
                  xs:decimal(data($errorMessage1/ns1:JMSHeader/ns1:JMSExpirationTime)) 
                  else()
                  }</ns0:jmsExpirationTime>
                 {
                     for $JMSRedeliveredFlag in $errorMessage1/ns1:JMSHeader/ns1:JMSRedeliveredFlag
                     return
                         <ns0:jmsRedeliveredFlag>{ data($JMSRedeliveredFlag) }</ns0:jmsRedeliveredFlag>
                 }
                <ns0:jmsPriorityCode>{
                 if (fn:string-length(data($errorMessage1/ns1:JMSHeader/ns1:JMSPriorityCode)) != 0) then
                  xs:decimal(data($errorMessage1/ns1:JMSHeader/ns1:JMSPriorityCode)) 
                  else()
                  }</ns0:jmsPriorityCode>
                 {
                     for $JMSType in $errorMessage1/ns1:JMSHeader/ns1:JMSType
                     return
                         <ns0:jmsType>{ data($JMSType) }</ns0:jmsType>
                }
                {
                    for $JMSCorrelationID in $errorMessage1/ns1:JMSHeader/ns1:JMSCorrelationID
                    return
                        <ns0:jmsCorrelationid>{ data($JMSCorrelationID) }</ns0:jmsCorrelationid>
                }
                {
                    for $JMSReplyToText in $errorMessage1/ns1:JMSHeader/ns1:JMSReplyToText
                    return
                        <ns0:jmsReplytoText>{ data($JMSReplyToText) }</ns0:jmsReplytoText>
                }
                {
                    for $JMSDeliveryTime in $errorMessage1/ns1:JMSHeader/ns1:JMSDeliveryTime
                    return
                        <ns0:jmsDeliveryTime>{ data($JMSDeliveryTime) }</ns0:jmsDeliveryTime>
                }
                <ns0:jmsRedeliveryLimit>{ 
                  if (fn:string-length(data($errorMessage1/ns1:JMSHeader/ns1:JMSRedeliveryLimit)) != 0) then
                  xs:decimal(data($errorMessage1/ns1:JMSHeader/ns1:JMSRedeliveryLimit)) 
                  else()
                  }</ns0:jmsRedeliveryLimit>
                <ns0:jmsDeliveryCount>{ 
                  if (fn:string-length(data($errorMessage1/ns1:JMSHeader/ns1:JMSDeliveryCount)) != 0) then
                  xs:decimal(data($errorMessage1/ns1:JMSHeader/ns1:JMSDeliveryCount)) 
                  else()
                  }</ns0:jmsDeliveryCount>
                <ns0:userDefinedProperties>
                    {
                        for $for-var1  in (1 to count($errorMessage1/ns1:JMSHeader/ns1:UserDefinedProperties))  
                        let $let-var1  := ($errorMessage1/ns1:JMSHeader/ns1:UserDefinedProperties[$for-var1])  
                        return
                            (fn:concat('<UserDefinedPropertyName>',data($let-var1/ns1:UserDefinedPropertyName),'</UserDefinedPropertyName>','<UserDefinedPropertyText>',data($let-var1/ns1:UserDefinedPropertyText),'</UserDefinedPropertyText>'))
                    }
</ns0:userDefinedProperties>
            </ns0:MiddlewareCommonError>
        </ns0:MiddlewareCommonErrorCollection>
};

declare variable $errorMessage1 as element(ns1:ErrorMessage) external;
declare variable $payload as xs:string external;


xf:CommonserviceErrorProcErrorDBXQ_1($errorMessage1,$payload)