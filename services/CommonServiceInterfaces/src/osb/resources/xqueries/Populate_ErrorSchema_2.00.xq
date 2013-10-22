(:: pragma bea:global-element-return element="ns0:ErrorMessage" location="../schemas/ErrorMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace xf = "http://tempuri.org/ImplementingFET/populateError/";
declare namespace ctx = "http://www.bea.com/wli/sb/context";
declare namespace tp = "http://www.bea.com/wli/sb/transports";
declare namespace jms = "http://www.bea.com/wli/sb/transports/jms";
declare namespace sour = "http://www.nike.com/StaticVariables";



declare function xf:errorSchema(
    $serviceName as xs:string,
    $serviceID as xs:string,
    $serverName as xs:string,
    $messageText as xs:string,
    $errTypeCode as xs:string,
    $payLoadText as xs:string,
    $errCode as xs:string,
    $stackTraceText as xs:string,
    $stageName as xs:string,
    $staticVariable as element(),
    $inbound as element()? )
    as element(ns0:ErrorMessage) {
        <ns0:ErrorMessage>
            <ns0:Header>
                <ns0:PlatformName>{ data($staticVariable/sour:PlatformName) }</ns0:PlatformName>
                <ns0:ServiceName>{ $serviceName }</ns0:ServiceName>
                <ns0:ServiceID>{ $serviceID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{ data($staticVariable/sour:LinkID) }</ns0:LinkID>
                <ns0:SenderText>{ data($staticVariable/sour:SenderText) }</ns0:SenderText>
                <ns0:SendingApplicationText>{data($staticVariable/sour:SendingApplicationText) }</ns0:SendingApplicationText>
                <ns0:TargetApplicationText>{ data($staticVariable/sour:TargetApplicationText) }</ns0:TargetApplicationText>
                <ns0:ServerName>{ $serverName }</ns0:ServerName>
                <ns0:ServerTimestamp>{ fn:current-dateTime() }</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{ data($staticVariable/sour:TrackID) }</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{data($staticVariable/sour:BKeyName) }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ data($staticVariable/sour:BKeyText) }</ns0:BusinessKeyText>
                <ns0:MessageText>{ $messageText }</ns0:MessageText>
                <ns0:ErrorTypeCode>{ $errTypeCode }</ns0:ErrorTypeCode>
                <ns0:PayloadText>{ $payLoadText }</ns0:PayloadText>
                <ns0:ErrorCode>{ $errCode }</ns0:ErrorCode>
                <ns0:Filename>{ data($staticVariable/sour:FileName) }</ns0:Filename>
                <ns0:StackTraceText>{ $stackTraceText }</ns0:StackTraceText>
                <ns0:StageName>{ $stageName }</ns0:StageName>
            </ns0:Body>
            { 
            if (exists($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSMessageID)) then 
            <ns0:JMSHeader>
                <ns0:JMSDestinationText>{ data($inbound/ctx:transport/ctx:uri) }</ns0:JMSDestinationText>
                <ns0:JMSDeliveryModeText>{ data($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSDeliveryMode) }</ns0:JMSDeliveryModeText>
                <ns0:JMSMessageID>{data($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSMessageID) }</ns0:JMSMessageID>
                <ns0:JMSTimestamp>{ data($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSTimestamp) }</ns0:JMSTimestamp>
                <ns0:JMSExpirationTime>{ $inbound/ctx:transport/ctx:request/tp:headers/jms:JMSExpiration/text() }</ns0:JMSExpirationTime>
                <ns0:JMSRedeliveredFlag>{ data($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSRedelivered) }</ns0:JMSRedeliveredFlag>
                <ns0:JMSPriorityCode>{  $inbound/ctx:transport/ctx:request/tp:headers/jms:JMSPriority/text() }</ns0:JMSPriorityCode>
                <ns0:JMSType>{data($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSType) }</ns0:JMSType>
                <ns0:JMSCorrelationID>{ data($inbound/ctx:transport/ctx:request/tp:headers/jms:JMSCorrelationID) }</ns0:JMSCorrelationID>
                <ns0:JMSReplyToText />
                <ns0:JMSDeliveryTime/>
                <ns0:JMSRedeliveryLimit>{ data($inbound/ctx:transport/ctx:request/tp:headers/tp:user-header[@name='JMS_BEA_RedeliveryLimit']/@value) }</ns0:JMSRedeliveryLimit>
                <ns0:JMSDeliveryCount>{ $inbound/ctx:transport/ctx:request/tp:headers/jms:JMSXDeliveryCount/text()  }</ns0:JMSDeliveryCount>
                {
                
			  	if (exists($inbound/ctx:transport/ctx:request/tp:headers/tp:user-header)) then 
				   for $user-header in $inbound/ctx:transport/ctx:request/tp:headers/tp:user-header return
	                <ns0:UserDefinedProperties>
	                    <ns0:UserDefinedPropertyName>{ data($user-header/@name)  }</ns0:UserDefinedPropertyName>
	                    <ns0:UserDefinedPropertyText>{data($user-header/@value) }</ns0:UserDefinedPropertyText>
	                </ns0:UserDefinedProperties>
                 else ()
   				 }
            </ns0:JMSHeader>
            else () 
            }
        </ns0:ErrorMessage>
};

declare variable $serviceName as xs:string external;
declare variable $serviceID as xs:string external;
declare variable $serverName as xs:string external;
declare variable $trackID as xs:string external;
declare variable $messageText as xs:string external;
declare variable $errTypeCode as xs:string external;
declare variable $payLoadText as xs:string external;
declare variable $errCode as xs:string external;
declare variable $stackTraceText as xs:string external;
declare variable $stageName as xs:string external;
declare variable $staticVariable as element() external;
declare variable $inbound as element() external;

xf:errorSchema(
    $serviceName,
    $serviceID,
    $serverName,
    $messageText,
    $errTypeCode,
    $payLoadText,
    $errCode,
    $stackTraceText,
    $stageName,
    $staticVariable,
    $inbound)