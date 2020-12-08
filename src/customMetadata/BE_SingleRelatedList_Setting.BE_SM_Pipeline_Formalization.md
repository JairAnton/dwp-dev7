<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_SM_Pipeline_Formalization</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
&quot;values&quot;: [
{
&quot;label&quot;: &quot;Cliente&quot;,
&quot;fieldName&quot;: &quot;AccountId&quot;,
&quot;type&quot;: &quot;customlookup&quot;,
&quot;typeAttributes&quot;: {
&quot;isCustom&quot;: true,
&quot;fieldName&quot;: &quot;Id&quot;,
&quot;label&quot;: &quot;Name&quot;,
&quot;objectApiName&quot;: &quot;Account&quot;,
&quot;rowData&quot;: {
&quot;fieldName&quot;: &quot;rowData&quot;
}
}
},
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
&quot;label&quot;: &quot;Estado&quot;,
&quot;fieldName&quot;: &quot;opportunity_status_type__c&quot;,
&quot;type&quot;: &quot;picklist&quot;
},
{
&quot;label&quot;: &quot;Importe&quot;,
&quot;fieldName&quot;: &quot;Amount&quot;,
&quot;type&quot;: &quot;currency&quot;,
&quot;typeAttributes&quot;: {
&quot;minimumFractionDigits&quot;: &quot;2&quot;,
&quot;maximumFractionDigits&quot;: &quot;2&quot;,
&quot;currencyCode&quot;: {
&quot;fieldName&quot;: &quot;CurrencyIsoCode&quot;
}
},
&quot;cellAttributes&quot;: {
&quot;alignment&quot;: &quot;right&quot;
}
},
{
&quot;label&quot;: &quot;Fecha de cierre&quot;,
&quot;fieldName&quot;: &quot;CloseDate&quot;,
&quot;type&quot;: &quot;date-local&quot;
},
{
&quot;type&quot;: &quot;action&quot;,
&quot;typeAttributes&quot;: {
&quot;rowActions&quot;: [
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
},
{
&quot;name&quot;: &quot;dynamic&quot;,
&quot;isDynamicCmp&quot;: true,
&quot;label&quot;: {
&quot;es&quot;: &quot;Desestimar&quot;,
&quot;en-US&quot;: &quot;Reject&quot;
},
&quot;componentName&quot;: &quot;c:Reject_comp&quot;,
&quot;componentParams&quot;: {
&quot;recordId&quot;: &quot;Id&quot;,
&quot;inputAttributes&quot;: {
&quot;recordId&quot;: &quot;Id&quot;
},
&quot;redirect&quot;: false
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
        <value xsi:type="xsd:string">Account.Name, Name,toLabel(opportunity_status_type__c),Amount,CloseDate</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:nil="true"/>
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
&quot;readClassName&quot;: &quot;BE_SM_Pipeline_Formalization_cls&quot;,
&quot;hideViewAll&quot;: true
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
</CustomMetadata>
