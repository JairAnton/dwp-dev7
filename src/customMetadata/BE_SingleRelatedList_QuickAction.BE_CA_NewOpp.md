<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_CA_NewOpp</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_CA_NewOpp_Ctr</value>
    </values>
    <values>
        <field>CustomFields__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;fieldName&quot;: &quot;Name&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;Amount&quot;
    },
    {
        &quot;fieldName&quot;: &quot;CurrencyIsoCode&quot;
    },
    {
        &quot;fieldName&quot;: &quot;StageName&quot;,
        &quot;value&quot;: &quot;02&quot;,
        &quot;required&quot;: true,
        &quot;disabled&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;opportunity_status_type__c&quot;,
        &quot;value&quot;: &quot;03&quot;,
        &quot;required&quot;: true,
        &quot;disabled&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;opportunity_planning_date__c&quot;
    },
    {
        &quot;fieldName&quot;: &quot;CloseDate&quot;
    },
    {
        &quot;fieldName&quot;: &quot;success_probability_desc__c&quot;
    },
    {
        &quot;fieldName&quot;: &quot;Description&quot;
    },
    {
        &quot;fieldName&quot;: &quot;AccountId&quot;,
        &quot;required&quot;: true,
        &quot;disabled&quot;: true,
        &quot;replaced&quot;: &quot;altm__participant_id__c&quot;
    },
    {
        &quot;fieldName&quot;: &quot;commercial_alert_id__c&quot;,
        &quot;required&quot;: true,
        &quot;disabled&quot;: true,
        &quot;value&quot;: &quot;recordId&quot;
    },
    {
        &quot;fieldName&quot;: &quot;CampaignId&quot;,
        &quot;disabled&quot;: true,
        &quot;required&quot;: true,
        &quot;replaced&quot;: &quot;altm__campaign_id__c&quot;
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
        <value xsi:type="xsd:string">{&quot;es&quot;: &quot;Crear Oportunidad&quot;,&quot;en_US&quot;: &quot;Create Opportunity&quot;}</value>
    </values>
    <values>
        <field>sObjectType__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
</CustomMetadata>
