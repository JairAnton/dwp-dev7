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
&quot;fieldName&quot;: &quot;start_date_calculated__c&quot;,
&quot;type&quot;: &quot;date-local&quot;
},
{
&quot;label&quot;: &quot;Estado&quot;,
&quot;fieldName&quot;: &quot;dwp_kitv__visit_status_type__c&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;type&quot;: &quot;action&quot;,
&quot;typeAttributes&quot;: {
&quot;rowActions&quot;: [
{
&quot;name&quot;: &quot;edit&quot;,
&quot;navigationType&quot;: &quot;standard__recordPage&quot;,
&quot;objectApiName&quot;: &quot;dwp_kitv__Visit__c&quot;,
&quot;isNotUIAPI&quot;: &quot;true&quot;,
&quot;title&quot;: {
&quot;es&quot;: &quot;Modificar&quot;,
&quot;en-US&quot;: &quot;Modify&quot;
},
&quot;label&quot;: {
&quot;es&quot;: &quot;Editar&quot;,
&quot;en-US&quot;: &quot;Edit&quot;
}
},
{
&quot;objectApiName&quot;: &quot;Task&quot;,
&quot;name&quot;: &quot;new&quot;,
&quot;isNotUIAPI&quot;: &quot;true&quot;,
&quot;navigationType&quot;: &quot;standard__objectPage&quot;,
&quot;recordTypeDevName&quot;: &quot;Sales_Meeting&quot;,
&quot;navigationLocation&quot;: &quot;RELATED_LIST&quot;,
&quot;defaultValues&quot;: [
{
&quot;fieldName&quot;: &quot;slmt__management_plan_meeting_id__c&quot;,
&quot;value&quot;: &quot;recordId&quot;
},
{
&quot;fieldName&quot;: &quot;OwnerId&quot;,
&quot;value&quot;: &quot;userId&quot;
},
{
&quot;fieldName&quot;: &quot;WhatId&quot;,
&quot;value&quot;: &quot;Id&quot;
}
],
&quot;title&quot;: {
&quot;es&quot;: &quot;Nuevo Tema&quot;,
&quot;en-US&quot;: &quot;New Topic&quot;
},
&quot;label&quot;: {
&quot;es&quot;: &quot;Nuevo Tema&quot;,
&quot;en-US&quot;: &quot;New Topic&quot;
}
}
]
}
}
]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Name, start_date_calculated__c, toLabel(dwp_kitv__visit_status_type__c), dwp_kitv__account_id__r.Name</value>
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
