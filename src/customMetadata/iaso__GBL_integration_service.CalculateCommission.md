<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CalculateCommission</label>
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
        <value xsi:type="xsd:string">CalculateCommission</value>
    </values>
    <values>
        <field>iaso__Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Headers_Class__c</field>
        <value xsi:nil="true"/>
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
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">{
   &quot;initialAmount&quot;:{
      &quot;amount&quot;:#initialAmountAmount#,
      &quot;currency&quot;:&quot;#initialAmountCurrency#&quot;
   },
   #termFrequencyId#
   &quot;fixedFee&quot;:{
      &quot;id&quot;:&quot;#fixedFeeId#&quot;
   },
   &quot;rates&quot;:{
      &quot;itemizeRates&quot;:[
         {
            &quot;rateUnit&quot;:#ratesItemizeRatesRateUnit#
         }
      ]
   }
   #questions#
}</value>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;data&quot;:{&quot;fixedFee&quot;:{&quot;id&quot;:&quot;CO223&quot;},&quot;calculatedFee&quot;:{&quot;id&quot;:&quot;382&quot;,&quot;version&quot;:1,&quot;calculatedAmount&quot;:{&quot;amount&quot;:100000,&quot;currency&quot;:&quot;PEN&quot;}},&quot;rates&quot;:{&quot;totalRates&quot;:{&quot;amount&quot;:0.03,&quot;currency&quot;:&quot;USD&quot;},&quot;itemizeRates&quot;:[{&quot;rateUnit&quot;:{&quot;unitRateType&quot;:&quot;PERCENTAGE&quot;,&quot;percentage&quot;:0.03}}]}}}</value>
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
