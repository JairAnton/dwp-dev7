<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_CA_NewCampaign</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_CA_NewCampaign_Ctr</value>
    </values>
    <values>
        <field>CustomFields__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;fieldName&quot;: &quot;Name&quot;,
        &quot;required&quot;: true
    },    
    {
        &quot;fieldName&quot;: &quot;commercial_alert_category__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;altm__commercial_alert_start_date__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;altm__commercial_alert_end_date__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;altm__commercial_alert_record_type__c&quot;,
        &quot;required&quot;: true
    }
]</value>
    </values>
    <values>
        <field>Fields__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>ModeAction__c</field>
        <value xsi:type="xsd:string">create</value>
    </values>
    <values>
        <field>Title__c</field>
        <value xsi:type="xsd:string">{&quot;es&quot;: &quot;Crear alerta&quot;,&quot;en_US&quot;: &quot;Create alert&quot;}</value>
    </values>
    <values>
        <field>sObjectType__c</field>
        <value xsi:type="xsd:string">altm__Commercial_Alert__c</value>
    </values>
</CustomMetadata>
