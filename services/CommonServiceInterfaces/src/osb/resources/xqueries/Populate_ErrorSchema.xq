(:: pragma bea:global-element-return element="ns0:ErrorMessage" location="../schemas/ErrorMessageXSD_1.00.xsd" ::)

declare namespace ns1 = "http://www.example.org/Source";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace xf = "http://tempuri.org/ImplementingFET/sdfs/";


declare function xf:errorSchema($platform as xs:string,
    $servName as xs:string,
    $servID as xs:string,
    $LinkID as xs:string,
    $senderText as xs:string,
    $senderAppln as xs:string,
    $targetAppln as xs:string,
    $serverName as xs:string,
    $trackID as xs:string,
    $BkeyName as xs:string,
    $BkeyText as xs:string,
    $messageText as xs:string,
    $errTypeCode as xs:string,
    $payLoadText as xs:string,
    $errCode as xs:string,
    $fileName as xs:string,
    $stackTraceText as xs:string,
    $stageName as xs:string,
    $JMSDestinationText1 as xs:string,
    $JMSDeliveryModeText1 as xs:string,
    $JMSMessageID1 as xs:string,
    $JMSExpirationTime1 as xs:string,
    $JMSTimestamp1 as xs:string,
    $JMSRedeliveredFlag1 as xs:string,
    $JMSPriorityCode1 as xs:string,
    $JMSType1 as xs:string,
    $JMSCorrelationID1 as xs:string,
    $JMSReplyToText1 as xs:string,
    $JMSDeliveryTime1 as xs:string,
    $JMSRedeliveryLimit1 as xs:string,
    $JMSDeliveryCount1 as xs:string,
    $UserDefinedPropName as xs:string,
    $UserDefinedPropText as xs:string)
    as element(ns0:ErrorMessage) {
        <ns0:ErrorMessage>
            <ns0:Header>
                <ns0:PlatformName>{ $platform }</ns0:PlatformName>
                <ns0:ServiceName>{ $servName }</ns0:ServiceName>
                <ns0:ServiceID>{ $servID }</ns0:ServiceID>
            </ns0:Header>
            <ns0:Body>
                <ns0:LinkID>{ data($LinkID) }</ns0:LinkID>
                <ns0:SenderText>{ $senderText }</ns0:SenderText>
                <ns0:SendingApplicationText>{ $senderAppln }</ns0:SendingApplicationText>
                <ns0:TargetApplicationText>{ $targetAppln }</ns0:TargetApplicationText>
                <ns0:ServerName>{ $serverName }</ns0:ServerName>
                <ns0:ServerTimestamp>{ fn:current-dateTime() }</ns0:ServerTimestamp>
                <ns0:TrackingIDText>{ $trackID }</ns0:TrackingIDText>
                <ns0:BusinessKeyName>{ $BkeyName }</ns0:BusinessKeyName>
                <ns0:BusinessKeyText>{ $BkeyText }</ns0:BusinessKeyText>
                <ns0:MessageText>{ $messageText }</ns0:MessageText>
                <ns0:ErrorTypeCode>{ $errTypeCode }</ns0:ErrorTypeCode>
                <ns0:PayloadText>{ $payLoadText }</ns0:PayloadText>
                <ns0:ErrorCode>{ $errCode }</ns0:ErrorCode>
                <ns0:Filename>{ $fileName }</ns0:Filename>
                <ns0:StackTraceText>{ $stackTraceText }</ns0:StackTraceText>
                <ns0:StageName>{ $stageName }</ns0:StageName>
            </ns0:Body>
            <ns0:JMSHeader>
                <ns0:JMSDestinationText>{ fn-bea:trim($JMSDestinationText1) }</ns0:JMSDestinationText>
                <ns0:JMSDeliveryModeText>{ fn-bea:trim($JMSDeliveryModeText1) }</ns0:JMSDeliveryModeText>
                <ns0:JMSMessageID>{ fn-bea:trim($JMSMessageID1) }</ns0:JMSMessageID>
                <ns0:JMSTimestamp>{ fn-bea:trim($JMSTimestamp1) }</ns0:JMSTimestamp>
                <ns0:JMSExpirationTime>{ fn-bea:trim($JMSExpirationTime1) }</ns0:JMSExpirationTime>
                <ns0:JMSRedeliveredFlag>{ fn-bea:trim($JMSRedeliveredFlag1) }</ns0:JMSRedeliveredFlag>
                <ns0:JMSPriorityCode>{ fn-bea:trim($JMSPriorityCode1) }</ns0:JMSPriorityCode>
                <ns0:JMSType>{ fn-bea:trim($JMSType1) }</ns0:JMSType>
                <ns0:JMSCorrelationID>{ fn-bea:trim($JMSCorrelationID1) }</ns0:JMSCorrelationID>
                <ns0:JMSReplyToText>{ fn-bea:trim($JMSReplyToText1) }</ns0:JMSReplyToText>
                <ns0:JMSDeliveryTime>{ fn-bea:trim($JMSDeliveryTime1) }</ns0:JMSDeliveryTime>
                <ns0:JMSRedeliveryLimit>{ fn-bea:trim($JMSRedeliveryLimit1) }</ns0:JMSRedeliveryLimit>
                <ns0:JMSDeliveryCount>{ fn-bea:trim($JMSDeliveryCount1) }</ns0:JMSDeliveryCount>
                <ns0:UserDefinedProperties>
                    <ns0:UserDefinedPropertyName>{ $UserDefinedPropName }</ns0:UserDefinedPropertyName>
                    <ns0:UserDefinedPropertyText>{ $UserDefinedPropText }</ns0:UserDefinedPropertyText>
                </ns0:UserDefinedProperties>
            </ns0:JMSHeader>
        </ns0:ErrorMessage>
};

declare variable $platform as xs:string external;
declare variable $servName as xs:string external;
declare variable $servID as xs:string external;
declare variable $LinkID as xs:string external;
declare variable $senderText as xs:string external;
declare variable $senderAppln as xs:string external;
declare variable $targetAppln as xs:string external;
declare variable $serverName as xs:string external;
declare variable $trackID as xs:string external;
declare variable $BkeyName as xs:string external;
declare variable $BkeyText as xs:string external;
declare variable $messageText as xs:string external;
declare variable $errTypeCode as xs:string external;
declare variable $payLoadText as xs:string external;
declare variable $errCode as xs:string external;
declare variable $fileName as xs:string external;
declare variable $stackTraceText as xs:string external;
declare variable $stageName as xs:string external;
declare variable $JMSDestinationText1 as xs:string external;
declare variable $JMSDeliveryModeText1 as xs:string external;
declare variable $JMSMessageID1 as xs:string external;
declare variable $JMSExpirationTime1 as xs:string external;
declare variable $JMSTimestamp1 as xs:string external;
declare variable $JMSRedeliveredFlag1 as xs:string external;
declare variable $JMSPriorityCode1 as xs:string external;
declare variable $JMSType1 as xs:string external;
declare variable $JMSCorrelationID1 as xs:string external;
declare variable $JMSReplyToText1 as xs:string external;
declare variable $JMSDeliveryTime1 as xs:string external;
declare variable $JMSRedeliveryLimit1 as xs:string external;
declare variable $JMSDeliveryCount1 as xs:string external;
declare variable $UserDefinedPropName as xs:string external;
declare variable $UserDefinedPropText as xs:string external;

xf:errorSchema($platform,
    $servName,
    $servID,
    $LinkID,
    $senderText,
    $senderAppln,
    $targetAppln,
    $serverName,
    $trackID,
    $BkeyName,
    $BkeyText,
    $messageText,
    $errTypeCode,
    $payLoadText,
    $errCode,
    $fileName,
    $stackTraceText,
    $stageName,
    $JMSDestinationText1,
    $JMSDeliveryModeText1,
    $JMSMessageID1,
    $JMSExpirationTime1,
    $JMSTimestamp1,
    $JMSRedeliveredFlag1,
    $JMSPriorityCode1,
    $JMSType1,
    $JMSCorrelationID1,
    $JMSReplyToText1,
    $JMSDeliveryTime1,
    $JMSRedeliveryLimit1,
    $JMSDeliveryCount1,
    $UserDefinedPropName,
    $UserDefinedPropText)