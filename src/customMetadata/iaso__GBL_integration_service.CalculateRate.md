<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CalculateRate</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">CalculateRate</value>
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
 &quot;bank&quot;:{
	&quot;branch&quot;:{
		 &quot;id&quot;: &quot;#branch#&quot;
	}
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
        <value xsi:type="xsd:string">{}</value>
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
