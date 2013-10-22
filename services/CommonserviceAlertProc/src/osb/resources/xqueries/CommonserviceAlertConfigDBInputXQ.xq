(:: pragma bea:global-element-parameter parameter="$alertMessage1" element="ns1:AlertMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AlertMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:CommonserviceAlertConfigDBRead_1.00Input" location="../schema/CommonserviceAlertConfigDBRead_1_00.xsd" ::)

declare namespace ns1 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace ns0 = "http://xmlns.oracle.com/pcbpel/adapter/db/CommonserviceAlertConfigDBRead_1.00";
declare namespace xf = "http://tempuri.org/CommonservicesAlertProc/src/osb/resources/xqueries/CommonserviceAlertConfigDBInput_AllStageXQ/";

declare function xf:CommonserviceAlertConfigDBInput_AllStageXQ($alertMessage1 as element(ns1:AlertMessage))
    as element(ns0:CommonserviceAlertConfigDBRead_1.00Input) {
        <ns0:CommonserviceAlertConfigDBRead_1.00Input>
            <ns0:Platform_name>{ data($alertMessage1/ns1:Header/ns1:PlatformName) }</ns0:Platform_name>
            <ns0:Service_name>{ data($alertMessage1/ns1:Header/ns1:ServiceName) }</ns0:Service_name>
            <ns0:Service_id>{ xs:decimal(data($alertMessage1/ns1:Header/ns1:ServiceID)) }</ns0:Service_id>
            <ns0:Stage_name>{ data($alertMessage1/ns1:Body/ns1:StageName) }</ns0:Stage_name>
        </ns0:CommonserviceAlertConfigDBRead_1.00Input>
};

declare variable $alertMessage1 as element(ns1:AlertMessage) external;

xf:CommonserviceAlertConfigDBInput_AllStageXQ($alertMessage1)
