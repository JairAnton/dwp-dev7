<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_CA_NewVisit</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_CA_NewVisit_Ctr</value>
    </values>
    <values>
        <field>CustomFields__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;fieldName&quot;: &quot;Name&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;dwp_kitv__visit_start_date__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;dwp_kitv__visit_duration_number__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;dwp_kitv__visit_location_desc__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;dwp_kitv__account_id__c&quot;,
        &quot;required&quot;: true,
        &quot;replaced&quot;: &quot;altm__participant_id__c&quot;,
        &quot;disabled&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;dwp_kitv__visit_purpose_type__c&quot;,
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
        <value xsi:type="xsd:string">{&quot;es&quot;: &quot;Crear visita&quot;,&quot;en_US&quot;: &quot;Create visit&quot;}</value>
    </values>
    <values>
        <field>redirect__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectType__c</field>
        <value xsi:type="xsd:string">dwp_kitv__Visit__c</value>
    </values>
</CustomMetadata>
