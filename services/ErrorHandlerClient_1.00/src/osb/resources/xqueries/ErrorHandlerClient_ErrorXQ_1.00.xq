(:: pragma bea:global-element-return element="ns0:ErrorProcessing" location="../schemas/ErrorHandlerClient_ErrorXsd_1.00.xsd" ::)

declare namespace ns0 = "http://www.Nike.GeneralError/XmlSchema";
declare namespace xf = "http://tempuri.org/ErrorHandlerClient_1.00/src/osb/resources/xqueries/ErrorHandlerClient_ErrorXQ_1.00.xq/";

declare function xf:ErrorHandlerClient_InputXQ($Platform as xs:string ?,
    $Link_ID as xs:string ?,
    $Source as xs:string ?,
    $SourceType as xs:string ?,
    $ServiceName as xs:string ?,
    $ServiceId as xs:string ?,
    $DataArea as xs:string ?,
    $JMSDestination as xs:string ?,
    $JMSDeliveryMode as xs:string ?,
    $JMSMessageID as xs:string ?,
    $JMSTimestamp as xs:string ?,
    $JMSCorrelationID as xs:string ?,
    $JMSReplyTo as xs:string ?,
    $JMSRedelivered as xs:string ?,
    $JMSType as xs:string ?,
    $JMSMessagePriority as xs:string ?,
    $JMSMessageExpiration as xs:string ?,
    $JMSMessageType as xs:string ?,
    $UserHeaders as xs:string ?,
    $MessagePayload as element(*)?)
    as element(ns0:ErrorProcessing) {
        <ns0:ErrorProcessing>
            <ns0:Platform>{ $Platform }</ns0:Platform>
            <ns0:Link_ID>{ $Link_ID }</ns0:Link_ID>
            <ns0:Source>{ $Source }</ns0:Source>
            <ns0:SourceType>{ $SourceType }</ns0:SourceType>
            <ns0:ServiceName>{ $ServiceName }</ns0:ServiceName>
            <ns0:ServiceId>{ $ServiceId }</ns0:ServiceId>
            <ns0:DataArea>{ $DataArea }</ns0:DataArea>
            <ns0:JMSDestination>{ $JMSDestination }</ns0:JMSDestination>
            <ns0:JMSDeliveryMode>{ $JMSDeliveryMode }</ns0:JMSDeliveryMode>
            <ns0:JMSMessageID>{ $JMSMessageID }</ns0:JMSMessageID>
            <ns0:JMSTimestamp>{ $JMSTimestamp }</ns0:JMSTimestamp>
            <ns0:JMSCorrelationID>{ $JMSCorrelationID }</ns0:JMSCorrelationID>
            <ns0:JMSReplyTo>{ $JMSReplyTo }</ns0:JMSReplyTo>
            <ns0:JMSRedelivered>{ $JMSRedelivered }</ns0:JMSRedelivered>
            <ns0:JMSType>{ $JMSType }</ns0:JMSType>
            <ns0:JMSMessagePriority>{ $JMSMessagePriority }</ns0:JMSMessagePriority>
            <ns0:JMSMessageExpiration>{ $JMSMessageExpiration }</ns0:JMSMessageExpiration>
            <ns0:JMSMessageType>{ $JMSMessageType }</ns0:JMSMessageType>
            { 
            if (data($UserHeaders)!="") then 
            <ns0:UserDefinedProperties>{
            	for $UserHeader in tokenize(data($UserHeaders),";")
			 return 
			      let $name := substring-before($UserHeader,"=") return
			      let $value := substring-after($UserHeader,"=") return
			      
			      if ($name!="") then
			      <ns0:UserDefinedProperty>
			          <ns0:Name>{$name}</ns0:Name>
			          <ns0:Value>{$value}</ns0:Value>
			      </ns0:UserDefinedProperty>
			     else()
            }</ns0:UserDefinedProperties> else ''
            }
               {
                let $MessagePayload1 := $MessagePayload
                return
                    <ns0:MessagePayload>{ $MessagePayload1/. }</ns0:MessagePayload>
            	}
           
        </ns0:ErrorProcessing>
};

declare variable $Platform as xs:string external;
declare variable $Link_ID as xs:string external;
declare variable $Source as xs:string external;
declare variable $SourceType as xs:string external;
declare variable $ServiceName as xs:string external;
declare variable $ServiceId as xs:string external;
declare variable $DataArea as xs:string external;
declare variable $JMSDestination as xs:string external;
declare variable $JMSDeliveryMode as xs:string external;
declare variable $JMSMessageID as xs:string external;
declare variable $JMSTimestamp as xs:string external;
declare variable $JMSCorrelationID as xs:string external;
declare variable $JMSReplyTo as xs:string external;
declare variable $JMSRedelivered as xs:string external;
declare variable $JMSType as xs:string external;
declare variable $JMSMessagePriority as xs:string external;
declare variable $JMSMessageExpiration as xs:string external;
declare variable $JMSMessageType as xs:string external;
declare variable $UserHeaders as xs:string external;
declare variable $MessagePayload as element(*) external;

xf:ErrorHandlerClient_InputXQ($Platform,
    $Link_ID,
    $Source,
    $SourceType,
    $ServiceName,
    $ServiceId,
    $DataArea,
    $JMSDestination,
    $JMSDeliveryMode,
    $JMSMessageID,
    $JMSTimestamp,
    $JMSCorrelationID,
    $JMSReplyTo,
    $JMSRedelivered,
    $JMSType,
    $JMSMessagePriority,
    $JMSMessageExpiration,
    $JMSMessageType,
    $UserHeaders,
    $MessagePayload)