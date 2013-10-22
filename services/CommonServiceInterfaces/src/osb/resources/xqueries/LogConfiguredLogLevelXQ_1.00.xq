(:: pragma bea:global-element-parameter parameter="$outputParameters1" element="ns0:OutputParameters" location="../schemas/LogConfigDB_1_00.xsd" ::)

declare namespace ns0 = "http://xmlns.oracle.com/pcbpel/adapter/db/schema/GET_LOG_CONFIG/";
declare namespace xf = "http://tempuri.org/CommonServiceInterfaces/src/osb/resources/xqueries/LogConfiguredLogLevelXQ_1.00/";

declare function xf:LogConfiguredLogLevelXQ_1($outputParameters1 as element(ns0:OutputParameters))
    as xs:string {
        if (data($outputParameters1/ns0:SERVICELOGLEVEL) = 'Error') then
            (xs:string('1'))
        else 
            if (data($outputParameters1/ns0:SERVICELOGLEVEL) = 'Info') then
                (xs:string('2'))
            else 
                if (data($outputParameters1/ns0:SERVICELOGLEVEL) = 'Debug') then
                    (xs:string('3'))
                else 
                (xs:string('Invalid Details'))
};

declare variable $outputParameters1 as element(ns0:OutputParameters) external;

xf:LogConfiguredLogLevelXQ_1($outputParameters1)
