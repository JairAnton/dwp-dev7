<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_CreateAccountContactRelation</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>CustomFields__c</field>
        <value xsi:type="xsd:string">{
    &quot;fields&quot;: [
        {
            &quot;fieldName&quot;: &quot;ContactId&quot;,
            &quot;value&quot;: &quot;id&quot;,
            &quot;required&quot;: &quot;true&quot;,
            &quot;disabled&quot;: &quot;true&quot;
        },
        {
            &quot;fieldName&quot;: &quot;AccountId&quot;,
            &quot;required&quot;: &quot;true&quot;,
            &quot;value&quot;: &quot;recordId&quot;,
            &quot;disabled&quot;: &quot;true&quot;
        },
        {
            &quot;fieldName&quot;: &quot;prof_position_type__c&quot;,
            &quot;required&quot;: &quot;true&quot;
        },
        {
            &quot;fieldName&quot;: &quot;other_prof_prosition_type__c&quot;
        },
        {
            &quot;fieldName&quot;: &quot;decision_making_desc__c&quot;,
            &quot;required&quot;: &quot;true&quot;
        },
        {
            &quot;fieldName&quot;: &quot;MobilePhone__c&quot;,
            &quot;required&quot;: &quot;true&quot;,
            &quot;value&quot;: &quot;Phone&quot;
        },
        {
            &quot;fieldName&quot;: &quot;email__c&quot;,
            &quot;required&quot;: &quot;true&quot;,
            &quot;value&quot;: &quot;Email&quot;
        },
        {
            &quot;fieldName&quot;: &quot;phone_1_area_code__c&quot;
        },
        {
            &quot;fieldName&quot;: &quot;phone_1__c&quot;
        },
        {
            &quot;fieldName&quot;: &quot;phone_2_area_code__c&quot;
        },
        {
            &quot;fieldName&quot;: &quot;phone_2__c&quot;
        },
        {
            &quot;fieldName&quot;: &quot;events_info_type__c&quot;
        },
        {
            &quot;fieldName&quot;: &quot;Description__c&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>Fields__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>ModeAction__c</field>
        <value xsi:type="xsd:string">Create</value>
    </values>
    <values>
        <field>Title__c</field>
        <value xsi:type="xsd:string">{     &quot;es&quot;: &quot;Nueva Relación de contacto de cuenta &quot;,     &quot;en_US&quot;: &quot;New Account Contact Relationship&quot; }</value>
    </values>
    <values>
        <field>redirect__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectType__c</field>
        <value xsi:type="xsd:string">AccountContactRelation</value>
    </values>
</CustomMetadata>
