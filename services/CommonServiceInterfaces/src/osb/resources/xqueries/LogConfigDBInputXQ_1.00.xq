(:: pragma bea:global-element-parameter parameter="$logMessage1" element="ns0:LogMessage" location="../schemas/LogMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns1:InputParameters" location="../schemas/LogConfigDB_1_00.xsd" ::)

declare namespace ns1 = "http://xmlns.oracle.com/pcbpel/adapter/db/schema/GET_LOG_CONFIG/";
declare namespace ns0 = "http://www.xmlns.nike.com/enterprise/resources/xsd/log/v1";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/src/osb/resources/xqueries/LogConfigDBInputXQ_1.00/";

declare function xf:LogConfigDBInputXQ_1($logMessage1 as element(ns0:LogMessage))
    as element(ns1:InputParameters) {
        <ns1:InputParameters>
            <ns1:PLATFORMNAME>{ data($logMessage1/ns0:Header/ns0:PlatformName) }</ns1:PLATFORMNAME>
            <ns1:SERVICENAME>{ data($logMessage1/ns0:Header/ns0:ServiceName) }</ns1:SERVICENAME>
        </ns1:InputParameters>
};

declare variable $logMessage1 as element(ns0:LogMessage) external;

xf:LogConfigDBInputXQ_1($logMessage1)
