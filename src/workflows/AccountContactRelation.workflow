<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ACR_FieldUpdate_OtherPosition_Null</fullName>
        <description>Null value to Other position if any value different from &apos;Otros&apos; is selected in Position picklist.</description>
        <field>other_prof_prosition_type__c</field>
        <name>ACR FieldUpdate OtherPosition Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AccountContactRelationship_Workflow_Rule_Position_Others</fullName>
        <actions>
            <name>ACR_FieldUpdate_OtherPosition_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AccountContactRelation.prof_position_type__c</field>
            <operation>notEqual</operation>
            <value>OTROS</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
