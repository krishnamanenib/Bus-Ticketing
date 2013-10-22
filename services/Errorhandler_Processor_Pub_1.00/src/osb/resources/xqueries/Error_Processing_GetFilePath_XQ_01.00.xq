xquery version "1.0" encoding "Cp1252";
declare namespace xf = "http://tempuri.org/Errorhandler_Processor_Pub_1.00/src/osb/resources/xqueries/Error_Processing_SubString_01.00/";

declare function xf:escapeRegex($inputstring as xs:string) as xs:string {
   replace($inputstring,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
 } ;

declare function xf:substring-afterlast($inputstring as xs:string ,$delimeter as xs:string) as xs:string {       
   replace ($inputstring,concat('^.*',xf:escapeRegex($delimeter)),'')
 } ;
 
declare function xf:substring-beforelast($inputstring as xs:string,$delimeter as xs:string) as xs:string {
   if (matches($inputstring, xf:escapeRegex($delimeter))) then
   replace($inputstring,concat('^(.*)', xf:escapeRegex($delimeter),'.*'),'$1')
   else ''
 } ;
 
declare function xf:Error_Processing_SubString_01($endpoint as xs:string)
    as xs:string {
   
        fn:concat(xf:substring-beforelast($endpoint ,'/'),'|',xf:substring-afterlast($endpoint,'/'))
    
};

declare variable $endpoint as xs:string external;

xf:Error_Processing_SubString_01($endpoint)