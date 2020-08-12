<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CalculateRate</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Blocked_Service__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">CalculateRate</value>
    </values>
    <values>
        <field>iaso__Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Headers_Class__c</field>
        <value xsi:type="xsd:string">Header_helper</value>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;Content-Type&quot;: &quot;application/json&quot;, &quot;back-clientdocument&quot;:&quot;&quot;}</value>
    </values>
    <values>
        <field>iaso__Http_Method__c</field>
        <value xsi:type="xsd:string">POST</value>
    </values>
    <values>
        <field>iaso__IsCacheable__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">{
 &quot;calculationType&quot;: {
   &quot;id&quot;: &quot;UNIQUE&quot;
 },
 &quot;participant&quot;: {
   &quot;id&quot;: &quot;#participantId#&quot;,
   &quot;identityDocuments&quot;: [
     {
       &quot;documentType&quot;: {
         &quot;id&quot;: &quot;RUC&quot;
       },
       &quot;documentNumber&quot;: &quot;#participantDocumentNumber#&quot;
     }
   ]
 },
 &quot;product&quot;: {
   &quot;id&quot;: &quot;#productId#&quot;,
   &quot;requestedAmount&quot;: {
     &quot;amount&quot;: &quot;#amount#&quot;,
     &quot;currency&quot;: &quot;#currencyCode#&quot;
   },
   &quot;term&quot;: {
     &quot;frequency&quot;: {
       &quot;id&quot;: &quot;#termId#&quot;
     },
&quot;number&quot;: &quot;#termNumber#&quot;
   },
   &quot;guarantee&quot;: {
     &quot;classification&quot;: {
       &quot;id&quot;: &quot;#guaranteeId#&quot;
     }
#guaranteeCoverage#
   },
   &quot;contractingModality&quot;: {
     &quot;id&quot;: &quot;#contractingModality#&quot;
   }
 },
&quot;indicators&quot;: [ 
   { 
     &quot;id&quot;: &quot;GUARANTEE_TYPE&quot;, 
     &quot;value&quot;: &quot;#guaranteeType#&quot; 
   }, 
   { 
     &quot;id&quot;: &quot;PAYMENT_METHOD_CODE&quot;, 
     &quot;value&quot;: &quot;#paymentMethodCode#&quot; 
   }, 
   { 
     &quot;id&quot;: &quot;BENEFICIARY_CODE&quot;, 
     &quot;value&quot;: &quot;#beneficiaryCode#&quot; 
   }, 
   { 
     &quot;id&quot;: &quot;PAYMENT_PERIOD_CODE&quot;, 
     &quot;value&quot;: &quot;#paymentPeriodCode#&quot; 
   }, 
   { 
     &quot;id&quot;: &quot;BAIL_OBJECT_CODE&quot;, 
     &quot;value&quot;: &quot;#bailObjectCode#&quot; 
   }
 ]
}</value>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;data&quot;:{&quot;calculationType&quot;:{&quot;id&quot;:&quot;UNIQUE&quot;},&quot;model&quot;:{&quot;id&quot;:&quot;2&quot;},&quot;businessAgent&quot;:{},&quot;participant&quot;:{&quot;identityDocuments&quot;:[{&quot;documentType&quot;:{}}],&quot;bank&quot;:{},&quot;segment&quot;:{&quot;subSegment&quot;:{&quot;partitions&quot;:[]}},&quot;delinquency&quot;:{&quot;behaviorDebts&quot;:{&quot;tacticalVariable&quot;:[]}},&quot;strategicRelationships&quot;:[],&quot;riskLevel&quot;:[]},&quot;product&quot;:{&quot;requestedAmount&quot;:{},&quot;term&quot;:{},&quot;guarantee&quot;:{}},&quot;summary&quot;:[{&quot;calculationId&quot;:&quot;227095&quot;,&quot;financialIndicators&quot;:[{&quot;id&quot;:&quot;CLUSTER&quot;,&quot;value&quot;:&quot;BE_CARTERA_02047&quot;},{&quot;id&quot;:&quot;COLLECTIVE_FLAG&quot;,&quot;value&quot;:&quot;false&quot;},{&quot;id&quot;:&quot;TACTICAL_FACTOR&quot;,&quot;value&quot;:&quot;1&quot;}],&quot;interestRates&quot;:{&quot;effectiveRates&quot;:[{&quot;id&quot;:&quot;ADJUSTED_MODEL_TEA&quot;,&quot;percentage&quot;:0.00070},{&quot;id&quot;:&quot;MINIMUM_TEA&quot;,&quot;percentage&quot;:0.049},{&quot;id&quot;:&quot;SUGGESTED_TEA&quot;,&quot;percentage&quot;:0.055}]},&quot;fees&quot;:[{&quot;feeType&quot;:{&quot;id&quot;:&quot;EXPECTED_LOSS&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.001528}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FUNDING_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0251}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;EFFICIENCY_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FINANCING_COST_STOCKHOLDER&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0164}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FUNDING_COST_ADJUSTED&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.022}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;REGULATORY_CAPITAL&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.1}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;ADDITIONAL_CAPITAL&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0228}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;CAPITAL&quot;},&quot;detail&quot;:{&quot;amount&quot;:392960.0,&quot;currency&quot;:&quot;USD&quot;}}],&quot;liquidityIndicators&quot;:[{&quot;id&quot;:&quot;ADDITIONAL_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;MINIMUM_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;COMMERCIAL_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.0034}}]}],&quot;indicators&quot;:[{&quot;id&quot;:&quot;RORC_CLIENT_VARIATION&quot;,&quot;value&quot;:&quot;0.004328&quot;},{&quot;id&quot;:&quot;RORC_CLIENT_STOCK_PERIOD&quot;,&quot;value&quot;:&quot;2019-12-01 00:00:00.0&quot;},{&quot;id&quot;:&quot;RAROEC_CLIENT_STOCK_PERIOD&quot;,&quot;value&quot;:&quot;2019-12-01 00:00:00.0&quot;},{&quot;id&quot;:&quot;LOST_FINANCIAL_MARGIN&quot;,&quot;value&quot;:&quot;5493687.123719&quot;},{&quot;id&quot;:&quot;RORC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,&quot;value&quot;:&quot;597180.498275&quot;},{&quot;id&quot;:&quot;RAROEC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,&quot;value&quot;:&quot;489511.563076&quot;},{&quot;id&quot;:&quot;RORC_CLIENT_LOST_FINANCIAL_MARGIN&quot;,&quot;value&quot;:&quot;5493687.123719&quot;},{&quot;id&quot;:&quot;RORC_CLIENT_STOCK_MONTH_ACTIVE&quot;,&quot;value&quot;:&quot;0.107978&quot;},{&quot;id&quot;:&quot;RAROEC_CLIENT_STOCK_MONTH_ACTIVE&quot;,&quot;value&quot;:&quot;0.283415&quot;},{&quot;id&quot;:&quot;RORC_THRESHOLD_CLIENT&quot;,&quot;value&quot;:&quot;1.078&quot;},{&quot;id&quot;:&quot;RAROEC_THRESHOLD_OPERATION&quot;,&quot;value&quot;:&quot;2.094&quot;},{&quot;id&quot;:&quot;RORC_CLIENT_POST&quot;,&quot;value&quot;:&quot;0.112306&quot;},{&quot;id&quot;:&quot;RAROEC_CLIENT_POST&quot;,&quot;value&quot;:&quot;0.299101&quot;},{&quot;id&quot;:&quot;RORC_OPERATION&quot;,&quot;value&quot;:&quot;0.146396&quot;},{&quot;id&quot;:&quot;RAROEC_OPERATION&quot;,&quot;value&quot;:&quot;0.440877&quot;},{&quot;id&quot;:&quot;PASS_THRESHOLD_RORC&quot;,&quot;value&quot;:&quot;0&quot;},{&quot;id&quot;:&quot;PASS_THRESHOLD_RAROEC_OPERATION&quot;,&quot;value&quot;:&quot;0&quot;},{&quot;id&quot;:&quot;PASS_THRESHOLD&quot;,&quot;value&quot;:&quot;0&quot;}]}}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA_TEMP__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
</CustomMetadata>
