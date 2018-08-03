<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>REJECT</label>
    <protected>false</protected>
    <values>
        <field>additional_validation_class_desc__c</field>
        <value xsi:type="xsd:string">checkIfUserNotOppAccountOwner</value>
    </values>
    <values>
        <field>is_active__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>language_code_id__c</field>
        <value xsi:type="xsd:string">en_US</value>
    </values>
    <values>
        <field>message_structure__c</field>
        <value xsi:type="xsd:string">\ the Opportunity #Name# from Account #Account.Name# has been rejected by #UserInfo# the day #CurrentDateTime#. You can access to the opportunity with the next link: #SalesforceBaseUrl#/#Id#</value>
    </values>
    <values>
        <field>object_api_name__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
    <values>
        <field>recipient_class_desc__c</field>
        <value xsi:type="xsd:string">getAccountOwnerAndOppTeam</value>
    </values>
    <values>
        <field>unique_id__c</field>
        <value xsi:type="xsd:string">REJECT</value>
    </values>
</CustomMetadata>