<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_proposed_fee</fullName>
        <field>proposed_fee_per__c</field>
        <formula>proposed_apr_per__c</formula>
        <name>Update proposed_fee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update proposed_fee</fullName>
        <actions>
            <name>Update_proposed_fee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( proposed_apr_per__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
