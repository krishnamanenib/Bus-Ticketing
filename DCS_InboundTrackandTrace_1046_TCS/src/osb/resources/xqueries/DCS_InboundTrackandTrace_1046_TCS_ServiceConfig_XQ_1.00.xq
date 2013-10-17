xquery version "1.0" encoding "Cp1252";
(:: pragma bea:global-element-return element="ns0:serviceconfig" location="../schemas/DCS_InboundTrackandTrace_1046_TCS_ServiceConfigXsd_1.00.xsd" ::)

declare namespace xf = "http://tempuri.org/DCS_InboundTrackandTrace_1046_TCS/src/osb/resources/xqueries/DCS_InboundTrackandTrace_1046_TCS_ServiceConfig_XQ_1.00/";
declare namespace ns0 = "http://www.nike.com/ServiceConfig";

declare function xf:DCS_InboundTrackandTrace_1046_TCS_ServiceConfig_XQ_1()
as element(ns0:serviceconfig) {
        <ns0:serviceconfig>
        <ns0:constants>
             <ns0:field>
                <ns0:key>WebServiceRetryCodes</ns0:key>
                <ns0:value>|400|404|</ns0:value>
            </ns0:field>
        </ns0:constants>
    </ns0:serviceconfig>
};


xf:DCS_InboundTrackandTrace_1046_TCS_ServiceConfig_XQ_1()