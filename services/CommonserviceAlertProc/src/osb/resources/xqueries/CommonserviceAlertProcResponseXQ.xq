(:: pragma bea:global-element-parameter parameter="$commonserviceAlertConfigDBRead_1.00OutputCollection1" element="ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection" location="../schema/CommonserviceAlertConfigDBRead_1_00.xsd" ::)
(:: pragma bea:global-element-parameter parameter="$alertMessage1" element="ns1:AlertMessage" location="../../../../../CommonServiceInterfaces/src/osb/resources/schemas/AlertMessageXSD_1.00.xsd" ::)
(:: pragma bea:global-element-return element="ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection" location="../schema/CommonserviceAlertConfigDBRead_1_00.xsd" ::)

declare namespace ns1 = "http://www.xmlns.nike.com/enterprise/resources/xsd/alert/v1";
declare namespace ns0 = "http://xmlns.oracle.com/pcbpel/adapter/db/CommonserviceAlertConfigDBRead_1.00";
declare namespace xf = "http://tempuri.org/CommonserviceAlertProc/src/osb/resources/xqueries/CommonserviceAlertProcResponseXQ/";

declare function xf:CommonserviceAlertProcResponseXQ($commonserviceAlertConfigDBRead_1.00OutputCollection1 as element(ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection),
    $alertMessage1 as element(ns1:AlertMessage))
    as element(ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection) {
        <ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection>
            <ns0:CommonserviceAlertConfigDBRead_1.00Output>
               
                <ns0:PLATFORM_NAME>
                    {
                           data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[1]/ns0:PLATFORM_NAME)
                    }
</ns0:PLATFORM_NAME>
                <ns0:SERVICE_NAME>{ 
                 data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[1]/ns0:SERVICE_NAME)
                    }</ns0:SERVICE_NAME>
                <ns0:SERVICE_ID>{ 
                data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[1]/ns0:SERVICE_ID)
                 }</ns0:SERVICE_ID>
                <ns0:STAGE_NAME>{
                      if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                ( data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:STAGE_NAME))
                else
                 ( data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:STAGE_NAME))
                 }</ns0:STAGE_NAME>
                <ns0:RECIPIENT_EMAILID>{ 
                        if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:RECIPIENT_EMAILID))
                else
                     (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:RECIPIENT_EMAILID))
                 }
                 </ns0:RECIPIENT_EMAILID>
                <ns0:SENDER_EMAILID>{
                        if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:SENDER_EMAILID))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:SENDER_EMAILID))
                 }</ns0:SENDER_EMAILID>
                <ns0:COPY_EMAILID>{ 
                if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then  
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:COPY_EMAILID))
                else
                    (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:COPY_EMAILID))
                 }</ns0:COPY_EMAILID>
                <ns0:BLIND_COPY_EMAILID>{
                 if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                ( data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:BLIND_COPY_EMAILID))
                else
                ( data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:BLIND_COPY_EMAILID))
                 }
                 </ns0:BLIND_COPY_EMAILID>
                <ns0:ALERT_FLAG>{ 
                 if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then   
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:ALERT_FLAG))
                else
                  (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:ALERT_FLAG))
                 }</ns0:ALERT_FLAG>
                <ns0:ALERT_FREQUENCY>{ 
                    if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:ALERT_FREQUENCY))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:ALERT_FREQUENCY))
                 }</ns0:ALERT_FREQUENCY>
                <ns0:SUBJECT_TEXT>{ 
                    if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:SUBJECT_TEXT))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:SUBJECT_TEXT))
                 }</ns0:SUBJECT_TEXT>
                <ns0:MESSAGE_TEXT>{ 
                   if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:MESSAGE_TEXT))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:MESSAGE_TEXT))
                 }</ns0:MESSAGE_TEXT>
                <ns0:ZZ_SETUP_TMST>{ 
                 if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then   
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:ZZ_SETUP_TMST))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:ZZ_SETUP_TMST))
                 }</ns0:ZZ_SETUP_TMST>
                <ns0:ZZ_CHNG_TMST>{ 
                    if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:ZZ_CHNG_TMST))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:ZZ_CHNG_TMST))
                 }</ns0:ZZ_CHNG_TMST>
                <ns0:ZZ_CHNG_CNT>{ 
                    if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:ZZ_CHNG_CNT))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:ZZ_CHNG_CNT))
                 }</ns0:ZZ_CHNG_CNT>
                <ns0:XXX_CHNG_USR_ID>{ 
                    if (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output/ns0:STAGE_NAME) = data($alertMessage1/ns1:Body/ns1:StageName)) then
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= $alertMessage1/ns1:Body/ns1:StageName/text()]/ns0:XXX_CHNG_USR_ID))
                else
                (data($commonserviceAlertConfigDBRead_1.00OutputCollection1/ns0:CommonserviceAlertConfigDBRead_1.00Output[ns0:STAGE_NAME/text()= 'ALL']/ns0:XXX_CHNG_USR_ID))
                 }</ns0:XXX_CHNG_USR_ID>
            </ns0:CommonserviceAlertConfigDBRead_1.00Output>
        </ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection>
};

declare variable $commonserviceAlertConfigDBRead_1.00OutputCollection1 as element(ns0:CommonserviceAlertConfigDBRead_1.00OutputCollection) external;
declare variable $alertMessage1 as element(ns1:AlertMessage) external;

xf:CommonserviceAlertProcResponseXQ($commonserviceAlertConfigDBRead_1.00OutputCollection1,
    $alertMessage1)
