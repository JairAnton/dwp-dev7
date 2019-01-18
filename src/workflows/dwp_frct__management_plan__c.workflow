<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_management_plan_review</fullName>
        <description>Notification management plan review</description>
        <protected>false</protected>
        <recipients>
            <field>dwp_frct__user_id__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Aviso_de_plan_en_revision</template>
    </alerts>
    <fieldUpdates>
        <fullName>Pasar_etapa_a_finalizado</fullName>
        <field>dwp_frct__management_plan_stage_type__c</field>
        <literalValue>05</literalValue>
        <name>Pasar etapa a finalizado</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Overdue End Date Management</fullName>
        <active>false</active>
        <description>When overdue end date, stage change to finalized.</description>
        <formula>ISPICKVAL( dwp_frct__management_plan_stage_type__c , &apos;04&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Pasar_etapa_a_finalizado</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>dwp_frct__management_plan__c.dwp_frct__management_plan_end_date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send notification to the manager</fullName>
        <actions>
            <name>Notification_management_plan_review</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send notification to the manager when plan pamagement stage is &quot;Review&quot;</description>
        <formula>ISPICKVAL( dwp_frct__management_plan_stage_type__c ,&apos;03&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
