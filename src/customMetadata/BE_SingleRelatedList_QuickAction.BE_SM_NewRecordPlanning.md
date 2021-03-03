<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_SM_NewRecordPlanning</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>CustomFields__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;fieldName&quot;: &quot;Name&quot;,
        &quot;disabled&quot;: true,
        &quot;value&quot;: &quot;Reunión de Planificación ...&quot;
    },
    {
        &quot;fieldName&quot;: &quot;Collaborator__c&quot;,
        &quot;required&quot;: true,
        &quot;value&quot;: &quot;UserId&quot;
    },
    {
        &quot;fieldName&quot;: &quot;Type_of_meeting__c&quot;,
        &quot;required&quot;: true,
        &quot;value&quot;: &quot;Planning&quot;
    },
    {
        &quot;fieldName&quot;: &quot;DateTime__c&quot;,
        &quot;required&quot;: true
    },
    {
        &quot;fieldName&quot;: &quot;slmt__mngmt_plan_meet_dur_number__c&quot;,
        &quot;required&quot;: true,
        &quot;value&quot;: &quot;45&quot;
    }
]</value>
    </values>
    <values>
        <field>ModeAction__c</field>
        <value xsi:type="xsd:string">create</value>
    </values>
    <values>
        <field>Title__c</field>
        <value xsi:type="xsd:string">{ &quot;es&quot;: &quot;Nueva Reunión Individual&quot;, &quot;en_US&quot;: &quot;New Sales Meeting&quot; }</value>
    </values>
    <values>
        <field>sObjectType__c</field>
        <value xsi:type="xsd:string">slmt__Sales_Meeting__c</value>
    </values>
</CustomMetadata>
