<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_SM_PendingTopic</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;Acuerdo&quot;,
            &quot;fieldName&quot;: &quot;Id&quot;,
            &quot;type&quot;: &quot;customurl&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                },
                &quot;isCustom&quot;: true,
                &quot;label&quot;: &quot;Subject&quot;,
                &quot;fieldName&quot;: &quot;Id&quot;
            }
        },
        {
            &quot;label&quot;: &quot;Relacionado&quot;,
            &quot;fieldName&quot;: &quot;WhatId&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;What&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Asignado&quot;,
            &quot;fieldName&quot;: &quot;OwnerId&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;Owner&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Estado&quot;,
            &quot;fieldName&quot;: &quot;Status&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;type&quot;: &quot;action&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowActions&quot;: [
                    {
                        &quot;name&quot;: &quot;update&quot;,
                        &quot;objectApiName&quot;: &quot;Task&quot;,
                        &quot;isNotUIAPI&quot;: &quot;true&quot;,
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Editar&quot;,
                            &quot;en-US&quot;: &quot;Edit&quot;
                        },
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Editar&quot;,
                            &quot;en-US&quot;: &quot;Edit&quot;
                        },
						&quot;fields&quot;: [
							{
								&quot;fieldName&quot;: &quot;Subject&quot;,
								&quot;label&quot;: &quot;Asunto&quot;,
								&quot;type&quot;: &quot;text&quot;,
								&quot;required&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;slmt__management_plan_meeting_id__c&quot;,
								&quot;type&quot;: &quot;search&quot;,
								&quot;label&quot;: &quot;Reunión individual&quot;,
								&quot;required&quot;: &quot;true&quot;,
								&quot;disabled&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;OwnerId&quot;,
								&quot;type&quot;: &quot;search&quot;,
								&quot;label&quot;: &quot;Asignado a&quot;,
								&quot;required&quot;: &quot;true&quot;,
								&quot;disabled&quot;: &quot;false&quot;
							},
							{
								&quot;fieldName&quot;: &quot;ActivityDate&quot;,
								&quot;type&quot;: &quot;datetime&quot;,
								&quot;label&quot;: &quot;Fecha de vencimiento&quot;,
								&quot;required&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;WhatId&quot;,
								&quot;type&quot;: &quot;search&quot;,
								&quot;label&quot;: &quot;Relacionado con&quot;
							},
							{
								&quot;fieldName&quot;: &quot;Priority&quot;,
								&quot;type&quot;: &quot;picklist&quot;,
								&quot;label&quot;: &quot;Prioridad&quot;,
								&quot;required&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;Status&quot;,
								&quot;type&quot;: &quot;picklist&quot;,
								&quot;label&quot;: &quot;Estado&quot;,
								&quot;required&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;Description&quot;,
								&quot;type&quot;: &quot;picklist&quot;,
								&quot;label&quot;: &quot;Comentarios&quot;
							}
						]
                    }
                ]
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">toLabel(Status),WhatId,toLabel(Subject),What.Name,Owner.Name</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">slmt__management_plan_meeting_id__c=:recordId AND Status=@@Open@@</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
&quot;readClassName&quot;: &quot;BE_SM_PendingTopic_Ctr&quot;,
&quot;hideViewAll&quot;: true
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Task</value>
    </values>
</CustomMetadata>
