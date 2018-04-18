<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DWP_Opp_Field_Update_Source</fullName>
        <field>opportunity_origin_name__c</field>
        <literalValue>01</literalValue>
        <name>Opportunity Field Update Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DWP_Opp_Field_Update_Source02</fullName>
        <field>opportunity_origin_name__c</field>
        <literalValue>02</literalValue>
        <name>Opportunity Field Update Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DWP_Opp_Field_Update_Source03</fullName>
        <field>opportunity_origin_name__c</field>
        <literalValue>03</literalValue>
        <name>Opportunity Field Update Source</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity_Workflow_Rule_Source_01</fullName>
        <actions>
            <name>DWP_Opp_Field_Update_Source</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Ejecutivo</value>
        </criteriaItems>
        <description>Cuando la oportunidad se crea, si el perfil del usuario que crea la oportunidad es: 
&apos;Ejecutivo&apos;, &apos;Gerente&apos; o &apos;Asistente&apos;, Source = 01</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Workflow_Rule_Source_02</fullName>
        <actions>
            <name>DWP_Opp_Field_Update_Source02</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Especialista</value>
        </criteriaItems>
        <description>Cuando la oportunidad se crea, si el perfil del usuario que crea la oportunidad es &apos;Especialista&apos;, se actualiza el campo Source = 02</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Workflow_Rule_Source_03</fullName>
        <actions>
            <name>DWP_Opp_Field_Update_Source03</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Migracion</value>
        </criteriaItems>
        <description>Cuando la oportunidad se crea, si el perfil del usuario que crea la oportunidad es &apos;Migracion&apos;, se actualiza el campo Source = 03</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
