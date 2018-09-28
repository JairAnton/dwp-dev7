<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>SimulateRate</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">SimulateRate</value>
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
 }
}</value>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;data&quot;:{&quot;calculationType&quot;:{&quot;id&quot;:&quot;UNIQUE&quot;},&quot;model&quot;:{&quot;id&quot;:&quot;2&quot;},&quot;businessAgent&quot;:{},&quot;participant&quot;:{&quot;identityDocuments&quot;:[{&quot;documentType&quot;:{}}],&quot;bank&quot;:{},&quot;segment&quot;:{&quot;subSegment&quot;:{&quot;partitions&quot;:[]}},&quot;delinquency&quot;:{&quot;behaviorDebts&quot;:{&quot;tacticalVariable&quot;:[]}},&quot;strategicRelationships&quot;:[],&quot;riskLevel&quot;:[]},&quot;product&quot;:{&quot;requestedAmount&quot;:{},&quot;term&quot;:{},&quot;guarantee&quot;:{}},&quot;summary&quot;:[{&quot;calculationId&quot;:&quot;173380&quot;,&quot;financialIndicators&quot;:[{&quot;id&quot;:&quot;CLUSTER&quot;,&quot;value&quot;:&quot;E1014&quot;},{&quot;id&quot;:&quot;COLLECTIVE_FLAG&quot;,&quot;value&quot;:&quot;false&quot;},{&quot;id&quot;:&quot;TACTICAL_FACTOR&quot;,&quot;value&quot;:&quot;1&quot;}],&quot;interestRates&quot;:{&quot;effectiveRates&quot;:[{&quot;id&quot;:&quot;ADJUSTED_MODEL_TEA&quot;,&quot;percentage&quot;:0.00020},{&quot;id&quot;:&quot;MINIMUM_TEA&quot;,&quot;percentage&quot;:0.154},{&quot;id&quot;:&quot;SUGGESTED_TEA&quot;,&quot;percentage&quot;:0.165}]},&quot;fees&quot;:[{&quot;feeType&quot;:{&quot;id&quot;:&quot;EXPECTED_LOSS&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.063162}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FUNDING_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0353}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;EFFICIENCY_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0074}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FINANCING_COST_STOCKHOLDER&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0147}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FUNDING_COST_ADJUSTED&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0309}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;REGULATORY_CAPITAL&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.1}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;ADDITIONAL_CAPITAL&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.025}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;CAPITAL&quot;},&quot;detail&quot;:{&quot;amount&quot;:2931.88,&quot;currency&quot;:&quot;PEN&quot;}}],&quot;liquidityIndicators&quot;:[{&quot;id&quot;:&quot;ADDITIONAL_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;MINIMUM_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;COMMERCIAL_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.04}}]}]}}</value>
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
