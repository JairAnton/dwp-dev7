<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>REASIGN CASE</label>
    <protected>false</protected>
    <values>
        <field>additional_validation_class_desc__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>is_active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>language_code_id__c</field>
        <value xsi:type="xsd:string">es</value>
    </values>
    <values>
        <field>message_structure__c</field>
        <value xsi:type="xsd:string">\ la oportunidad #opportunity_id__r.Name# del cliente #Account.Name# ha sido asignada para sanción de precio por #UserInfo# el día #CurrentDateTime#. Acceda a la petición a través del siguiente link: #SalesforceBaseUrl#/#Id#</value>
    </values>
    <values>
        <field>object_api_name__c</field>
        <value xsi:type="xsd:string">Case</value>
    </values>
    <values>
        <field>recipient_class_desc__c</field>
        <value xsi:type="xsd:string">GetCaseOwnerOrQueueMembers</value>
    </values>
    <values>
        <field>unique_id__c</field>
        <value xsi:type="xsd:string">REASIGN_CASE</value>
    </values>
</CustomMetadata>
