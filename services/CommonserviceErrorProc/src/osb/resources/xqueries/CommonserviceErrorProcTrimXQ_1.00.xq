(:: pragma bea:global-element-parameter parameter="$errorMessage1" element="ns0:ErrorMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/ErrorMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:ErrorMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/ErrorMessageXSD_1.00.xsd" ::)

declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/error/v1";
declare namespace xf = "http://tempuri.org/CommonserviceErrorProc_1.00/src/osb/resources/xqueries/CommonserviceErrorProcTrimXQ_1.00/";

declare function xf:CommonserviceErrorProcTrimXQ_1($errorMessage1 as element(ns0:ErrorMessage))
    as element(ns0:ErrorMessage) {
        <ns0:ErrorMessage>
            {
                let $Header := $errorMessage1/ns0:Header
                return
                    <ns0:Header>
                        <ns0:PlatformName>{ substring(fn-bea:trim(data($Header/ns0:PlatformName)),1,20) }</ns0:PlatformName>
                        <ns0:ServiceName>{ substring(fn-bea:trim(data($Header/ns0:ServiceName)),1,50) }</ns0:ServiceName>
                        {
                            for $ServiceID in $Header/ns0:ServiceID
                            return
                               if (fn:string-length($ServiceID) != 0) then
                                <ns0:ServiceID>{ fn-bea:trim(data($ServiceID)) }</ns0:ServiceID>
                                else
                                ()
                        }
                    </ns0:Header>
            }
            {
                let $Body := $errorMessage1/ns0:Body
                return
                    <ns0:Body>
                        {
                            for $LinkID in $Body/ns0:LinkID
                            return
                                  if (fn:string-length($LinkID) != 0) then
                                   <ns0:LinkID>{ fn-bea:trim(data($LinkID)) }</ns0:LinkID>
                                   else
                                   ()
                        }
                        {
                            for $SenderText in $Body/ns0:SenderText
                            return
                                <ns0:SenderText>{ substring(fn-bea:trim(data($SenderText)),1,50) }</ns0:SenderText>
                        }
                        {
                            for $SendingApplicationText in $Body/ns0:SendingApplicationText
                            return
                                <ns0:SendingApplicationText>{ substring(fn-bea:trim(data($SendingApplicationText)),1,50) }</ns0:SendingApplicationText>
                        }
                        {
                            for $TargetApplicationText in $Body/ns0:TargetApplicationText
                            return
                                <ns0:TargetApplicationText>{ substring(fn-bea:trim(data($TargetApplicationText)),1,50) }</ns0:TargetApplicationText>
                        }
                        <ns0:ServerName>{ substring(fn-bea:trim(data($Body/ns0:ServerName)),1,20) }</ns0:ServerName>
                        <ns0:ServerTimestamp>{ fn-bea:trim(data($Body/ns0:ServerTimestamp)) }</ns0:ServerTimestamp>
                        {
                            for $TrackingIDText in $Body/ns0:TrackingIDText
                            return
                                <ns0:TrackingIDText>{ substring(fn-bea:trim(data($TrackingIDText)),1,255) }</ns0:TrackingIDText>
                        }
                        <ns0:BusinessKeyName>{ substring(fn-bea:trim(data($Body/ns0:BusinessKeyName)),1,200) }</ns0:BusinessKeyName>
                        <ns0:BusinessKeyText>{ substring(fn-bea:trim(data($Body/ns0:BusinessKeyText)),1,200) }</ns0:BusinessKeyText>
                        <ns0:MessageText>{ substring(fn-bea:trim(data($Body/ns0:MessageText)),1,4000) }</ns0:MessageText>
                        <ns0:ErrorTypeCode>{ substring(fn-bea:trim(data($Body/ns0:ErrorTypeCode)),1,20) }</ns0:ErrorTypeCode>
                        {
                            for $PayloadText in $Body/ns0:PayloadText
                            return
                                <ns0:PayloadText>{ fn-bea:trim(data($PayloadText)) }</ns0:PayloadText>
                        }
                        <ns0:ErrorCode>{ substring(fn-bea:trim(data($Body/ns0:ErrorCode)),1,50) }</ns0:ErrorCode>
                        {
                            for $Filename in $Body/ns0:Filename
                            return
                                <ns0:Filename>{ substring(fn-bea:trim(data($Filename)),1,80) }</ns0:Filename>
                        }
                        {
                            for $StackTraceText in $Body/ns0:StackTraceText
                            return
                                <ns0:StackTraceText>{ substring(fn-bea:trim(data($StackTraceText)),1,4000) }</ns0:StackTraceText>
                        }
                        {
                            for $StageName in $Body/ns0:StageName
                            return
                                <ns0:StageName>{ substring(fn-bea:trim(data($StageName)),1,50) }</ns0:StageName>
                        }
                    </ns0:Body>
            }
            {
                for $JMSHeader in $errorMessage1/ns0:JMSHeader
                return
                    <ns0:JMSHeader>
                        {
                            for $JMSDestinationText in $JMSHeader/ns0:JMSDestinationText
                            return
                                <ns0:JMSDestinationText>{ substring(fn-bea:trim(data($JMSDestinationText)),1,300) }</ns0:JMSDestinationText>
                        }
                        {
                            for $JMSDeliveryModeText in $JMSHeader/ns0:JMSDeliveryModeText
                            return
                                <ns0:JMSDeliveryModeText>{ substring(fn-bea:trim(data($JMSDeliveryModeText)),1,20) }</ns0:JMSDeliveryModeText>
                        }
                        {
                            for $JMSMessageID in $JMSHeader/ns0:JMSMessageID
                            return
                                <ns0:JMSMessageID>{ substring(fn-bea:trim(data($JMSMessageID)),1,50) }</ns0:JMSMessageID>
                        }
                        {
                            for $JMSTimestamp in $JMSHeader/ns0:JMSTimestamp
                            return
                                <ns0:JMSTimestamp>{ substring(fn-bea:trim(data($JMSTimestamp)),1,20) }</ns0:JMSTimestamp>
                        }
                        {
                            for $JMSExpirationTime in $JMSHeader/ns0:JMSExpirationTime
                            return
                                if (fn:string-length($JMSExpirationTime) != 0) then
                                <ns0:JMSExpirationTime>{ fn-bea:trim(data($JMSExpirationTime)) }</ns0:JMSExpirationTime>
                                else
                                ()
                        }
                        {
                            for $JMSRedeliveredFlag in $JMSHeader/ns0:JMSRedeliveredFlag
                            return
                                <ns0:JMSRedeliveredFlag>{ substring(fn-bea:trim(data($JMSRedeliveredFlag)),1,10) }</ns0:JMSRedeliveredFlag>
                        }
                        {
                            for $JMSPriorityCode in $JMSHeader/ns0:JMSPriorityCode
                            return
                                 if (fn:string-length($JMSPriorityCode) != 0) then
                                <ns0:JMSPriorityCode>{ fn-bea:trim(data($JMSPriorityCode)) }</ns0:JMSPriorityCode>
                                else
                                ()
                        }
                        {
                            for $JMSType in $JMSHeader/ns0:JMSType
                            return
                                <ns0:JMSType>{ substring(fn-bea:trim(data($JMSType)),1,20) }</ns0:JMSType>
                        }
                        {
                            for $JMSCorrelationID in $JMSHeader/ns0:JMSCorrelationID
                            return
                                <ns0:JMSCorrelationID>{ substring(fn-bea:trim(data($JMSCorrelationID)),1,50) }</ns0:JMSCorrelationID>
                        }
                        {
                            for $JMSReplyToText in $JMSHeader/ns0:JMSReplyToText
                            return
                                <ns0:JMSReplyToText>{ substring(fn-bea:trim(data($JMSReplyToText)),1,100) }</ns0:JMSReplyToText>
                        }
                        {
                            for $JMSDeliveryTime in $JMSHeader/ns0:JMSDeliveryTime
                            return
                                <ns0:JMSDeliveryTime>{ substring(fn-bea:trim(data($JMSDeliveryTime)),1,20) }</ns0:JMSDeliveryTime>
                        }
                        {
                            for $JMSRedeliveryLimit in $JMSHeader/ns0:JMSRedeliveryLimit
                            return
                                 if (fn:string-length($JMSRedeliveryLimit) != 0) then
                                <ns0:JMSRedeliveryLimit>{ fn-bea:trim(data($JMSRedeliveryLimit)) }</ns0:JMSRedeliveryLimit>
                                else
                                ()
                        }
                        {
                            for $JMSDeliveryCount in $JMSHeader/ns0:JMSDeliveryCount
                            return
                                   if (fn:string-length($JMSDeliveryCount) != 0) then
                                <ns0:JMSDeliveryCount>{ fn-bea:trim(data($JMSDeliveryCount)) }</ns0:JMSDeliveryCount>
                                else
                                ()
                        }
                        {
                            for $UserDefinedProperties in $JMSHeader/ns0:UserDefinedProperties
                            return
                                <ns0:UserDefinedProperties>
                                    {
                                        for $UserDefinedPropertyName in $UserDefinedProperties/ns0:UserDefinedPropertyName
                                        return
                                            <ns0:UserDefinedPropertyName>{ substring(fn-bea:trim(data($UserDefinedPropertyName)),1,100) }</ns0:UserDefinedPropertyName>
                                    }
                                    {
                                        for $UserDefinedPropertyText in $UserDefinedProperties/ns0:UserDefinedPropertyText
                                        return
                                            <ns0:UserDefinedPropertyText>{ substring(fn-bea:trim(data($UserDefinedPropertyText)),1,100) }</ns0:UserDefinedPropertyText>
                                    }
                                </ns0:UserDefinedProperties>
                        }
                    </ns0:JMSHeader>
            }
        </ns0:ErrorMessage>
};

declare variable $errorMessage1 as element(ns0:ErrorMessage) external;

xf:CommonserviceErrorProcTrimXQ_1($errorMessage1)