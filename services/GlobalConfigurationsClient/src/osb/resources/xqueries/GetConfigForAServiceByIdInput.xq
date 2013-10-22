(:: pragma bea:global-element-return element="ns0:GetConfigForAServiceByIdRequest" location="../wsdls/GlobalConfigurations_1.00.wsdl" ::)

declare namespace ns0 = "http://www.nike.com/GlobalConfigurations_1.00/";
declare namespace xf = "http://tempuri.org/GlobalConfigurationsClient/src/osb/resources/xqueries/GetConfigForAServiceByIdInput/";

declare function xf:GetConfigForAServiceByIdInput($serviceId as xs:string)
    as element(ns0:GetConfigForAServiceByIdRequest) {
        <ns0:GetConfigForAServiceByIdRequest>
            <serviceId>{ $serviceId }</serviceId>
        </ns0:GetConfigForAServiceByIdRequest>
};

declare variable $serviceId as xs:string external;

xf:GetConfigForAServiceByIdInput($serviceId)
