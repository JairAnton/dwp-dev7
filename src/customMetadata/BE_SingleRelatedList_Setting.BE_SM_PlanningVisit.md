<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_SM_PlanningVisit</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
	&quot;values&quot;: [
		{
			&quot;label&quot;: &quot;Nombre&quot;,
			&quot;fieldName&quot;: &quot;Id&quot;,
			&quot;type&quot;: &quot;customurl&quot;,
			&quot;typeAttributes&quot;: {
				&quot;rowData&quot;: {
					&quot;fieldName&quot;: &quot;rowData&quot;
				},
				&quot;isCustom&quot;: true,
				&quot;label&quot;: &quot;Name&quot;,
				&quot;fieldName&quot;: &quot;Id&quot;
			}
		},
		{
			&quot;label&quot;: &quot;Cliente&quot;,
			&quot;fieldName&quot;: &quot;dwp_kitv__account_id__c&quot;,
			&quot;type&quot;: &quot;customlookup&quot;,
			&quot;typeAttributes&quot;: {
				&quot;isCustom&quot;: true,
				&quot;fieldName&quot;: &quot;Id&quot;,
				&quot;label&quot;: &quot;Name&quot;,
				&quot;objectApiName&quot;: &quot;dwp_kitv__account_id__r&quot;,
				&quot;rowData&quot;: {
					&quot;fieldName&quot;: &quot;rowData&quot;
				}
			}
		},
		{
			&quot;label&quot;: &quot;Fecha&quot;,
			&quot;fieldName&quot;: &quot;dwp_kitv__visit_start_date__c&quot;,
			&quot;type&quot;: &quot;date&quot;,
			&quot;typeAttributes&quot;: {
				&quot;year&quot;:&quot;numeric&quot;,
				&quot;day&quot;:&quot;2-digit&quot;,
				&quot;month&quot;:&quot;2-digit&quot;,
				&quot;hour&quot;:&quot;2-digit&quot;,
				&quot;minute&quot;:&quot;2-digit&quot;,
				&quot;hour12&quot;:true,
				&quot;time-zone&quot;:&quot;America/Bogota&quot;
			}
		},
		{
			&quot;label&quot;: &quot;Estado&quot;,
			&quot;fieldName&quot;: &quot;dwp_kitv__visit_status_type__c&quot;,
			&quot;type&quot;: &quot;text&quot;
		},
		{
			&quot;type&quot;:&quot;action&quot;,
			&quot;typeAttributes&quot;:{
				&quot;rowActions&quot;:[
					{
						&quot;name&quot;:&quot;edit&quot;,
						&quot;navigationType&quot;:&quot;standard__recordPage&quot;,
						&quot;objectApiName&quot;:&quot;dwp_kitv__Visit__c&quot;,
						&quot;isStandardModal&quot;:&quot;true&quot;,
						&quot;title&quot;:{
							&quot;es&quot;:&quot;Modificar&quot;,
							&quot;en-US&quot;:&quot;Modify&quot;
						},
						&quot;label&quot;:{
							&quot;es&quot;:&quot;Editar&quot;,
							&quot;en-US&quot;:&quot;Edit&quot;
						}
					},
					{
						&quot;name&quot;:&quot;insert&quot;,
						&quot;title&quot;:{
							&quot;es&quot;:&quot;Nuevo Tema&quot;,
							&quot;en-US&quot;:&quot;New Topic&quot;
						},
						&quot;label&quot;:{
							&quot;es&quot;:&quot;Nuevo Tema&quot;,
							&quot;en-US&quot;:&quot;New Topic&quot;
						},
						&quot;objectApiName&quot;:&quot;Task&quot;,
						&quot;isNotUIAPI&quot;:&quot;true&quot;,
						&quot;recordTypeDevName&quot;:&quot;Sales_Meeting&quot;,
						&quot;fields&quot;: [
							{
								&quot;fieldName&quot;: &quot;Subject&quot;,
								&quot;label&quot;: &quot;Asunto&quot;,
								&quot;type&quot;: &quot;text&quot;,
								&quot;required&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;slmt__management_plan_meeting_id__c&quot;,
								&quot;value&quot;: &quot;recordId&quot;,
								&quot;type&quot;: &quot;search&quot;,
								&quot;label&quot;: &quot;Reunión individual&quot;,
								&quot;required&quot;: &quot;true&quot;,
								&quot;disabled&quot;: &quot;true&quot;
							},
							{
								&quot;fieldName&quot;: &quot;OwnerId&quot;,
								&quot;value&quot;: &quot;userId&quot;,
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
								&quot;value&quot;: &quot;Id&quot;,
								&quot;type&quot;: &quot;search&quot;,
								&quot;label&quot;: &quot;Relacionado con&quot;,
								&quot;required&quot;: &quot;true&quot;
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
        <value xsi:type="xsd:string">Name, dwp_kitv__visit_start_date__c, toLabel(dwp_kitv__visit_status_type__c), dwp_kitv__account_id__r.Name</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:type="xsd:string">{
&quot;values&quot;: [
{
&quot;name&quot;: &quot;insert&quot;,
&quot;objectApiName&quot;: &quot;dwp_kitv__Visit__c&quot;,
&quot;label&quot;: {
&quot;es&quot;: &quot;Nuevo Visita&quot;,
&quot;en-US&quot;: &quot;New Visit&quot;
},
&quot;title&quot;: {
&quot;es&quot;: &quot;Nueva Visita&quot;,
&quot;en-US&quot;: &quot;New Visit&quot;
},
&quot;fields&quot;: [
{
&quot;fieldName&quot;: &quot;Name&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;dwp_kitv__account_id__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;dwp_kitv__visit_start_date__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;dwp_kitv__visit_duration_number__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;dwp_kitv__visit_location_desc__c&quot;
},
{
&quot;fieldName&quot;: &quot;dwp_kitv__visit_purpose_type__c&quot;,
&quot;required&quot;: &quot;true&quot;
}
]
}
]
}</value>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
&quot;readClassName&quot;: &quot;BE_SM_PlanningVisit_cls&quot;,
&quot;hideViewAll&quot;: true
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">dwp_kitv__Visit__c</value>
    </values>
</CustomMetadata>
