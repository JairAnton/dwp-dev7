<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Vista Planes de Cuenta para Ejecutivos</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_AccountPlanning_HomeView_cls</value>
    </values>
    <values>
        <field>Columns_Table_Configuration__c</field>
        <value xsi:type="xsd:string">{
&quot;priority&quot;: [
{
&quot;label&quot;: &quot;Cliente&quot;,
&quot;fieldName&quot;: &quot;linkAP&quot;,
&quot;type&quot;: &quot;url&quot;,
&quot;typeAttributes&quot;: {
&quot;label&quot;: {
&quot;fieldName&quot;: &quot;clientName&quot;
},
&quot;target&quot;: &quot;_self&quot;
},
&quot;sortable&quot;: true
},
{
&quot;label&quot;: &quot;Segmento&quot;,
&quot;fieldName&quot;: &quot;segment&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Estado&quot;,
&quot;fieldName&quot;: &quot;status&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Prioridad&quot;,
&quot;fieldName&quot;: &quot;priority&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Fecha de vencimiento&quot;,
&quot;fieldName&quot;: &quot;DueDate&quot;,
&quot;type&quot;: &quot;date-local&quot;,
&quot;typeAttributes&quot;: {
&quot;month&quot;: &quot;2-digit&quot;,
&quot;day&quot;: &quot;2-digit&quot;
}
}
],
&quot;validated&quot;: [
{
&quot;label&quot;: &quot;Cliente&quot;,
&quot;fieldName&quot;: &quot;linkAP&quot;,
&quot;type&quot;: &quot;url&quot;,
&quot;typeAttributes&quot;: {
&quot;label&quot;: {
&quot;fieldName&quot;: &quot;clientName&quot;
},
&quot;target&quot;: &quot;_self&quot;
},
&quot;sortable&quot;: true
},
{
&quot;label&quot;: &quot;Segmento&quot;,
&quot;fieldName&quot;: &quot;segment&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Estado&quot;,
&quot;fieldName&quot;: &quot;status&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Prioridad&quot;,
&quot;fieldName&quot;: &quot;priority&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Fecha de vencimiento&quot;,
&quot;fieldName&quot;: &quot;DueDate&quot;,
&quot;type&quot;: &quot;date-local&quot;,
&quot;typeAttributes&quot;: {
&quot;month&quot;: &quot;2-digit&quot;,
&quot;day&quot;: &quot;2-digit&quot;
}
}
],
&quot;closed_this_month&quot;: [
{
&quot;label&quot;: &quot;Cliente&quot;,
&quot;fieldName&quot;: &quot;linkAP&quot;,
&quot;type&quot;: &quot;url&quot;,
&quot;typeAttributes&quot;: {
&quot;label&quot;: {
&quot;fieldName&quot;: &quot;clientName&quot;
},
&quot;target&quot;: &quot;_self&quot;
},
&quot;sortable&quot;: true
},
{
&quot;label&quot;: &quot;Segmento&quot;,
&quot;fieldName&quot;: &quot;segment&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Estado&quot;,
&quot;fieldName&quot;: &quot;status&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Prioridad&quot;,
&quot;fieldName&quot;: &quot;priority&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Fecha de vencimiento&quot;,
&quot;fieldName&quot;: &quot;DueDate&quot;,
&quot;type&quot;: &quot;date-local&quot;,
&quot;typeAttributes&quot;: {
&quot;month&quot;: &quot;2-digit&quot;,
&quot;day&quot;: &quot;2-digit&quot;
}
}
],
&quot;closed_next_month&quot;: [
{
&quot;label&quot;: &quot;Cliente&quot;,
&quot;fieldName&quot;: &quot;linkAP&quot;,
&quot;type&quot;: &quot;url&quot;,
&quot;typeAttributes&quot;: {
&quot;label&quot;: {
&quot;fieldName&quot;: &quot;clientName&quot;
},
&quot;target&quot;: &quot;_self&quot;
},
&quot;sortable&quot;: true
},
{
&quot;label&quot;: &quot;Segmento&quot;,
&quot;fieldName&quot;: &quot;segment&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Estado&quot;,
&quot;fieldName&quot;: &quot;status&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Prioridad&quot;,
&quot;fieldName&quot;: &quot;priority&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Fecha de vencimiento&quot;,
&quot;fieldName&quot;: &quot;DueDate&quot;,
&quot;type&quot;: &quot;date-local&quot;,
&quot;typeAttributes&quot;: {
&quot;month&quot;: &quot;2-digit&quot;,
&quot;day&quot;: &quot;2-digit&quot;
}
}
]

}</value>
    </values>
    <values>
        <field>Filters__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;label&quot;: &quot;Por prioridad&quot;,
        &quot;code&quot;: &quot;priority&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;developerName&quot;:&quot;Period_by_priority&quot;,
&quot;default&quot;: true
    },
    {
        &quot;label&quot;: &quot;Todos los planes validados&quot;,
        &quot;code&quot;: &quot;validated&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;developerName&quot;:&quot;Account_Planning_validated&quot;
    },
{
        &quot;label&quot;: &quot;Planes que cierran este mes&quot;,
        &quot;code&quot;: &quot;closed_this_month&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;developerName&quot;:&quot;Account_Planning_closed_this_month&quot;
    },
{
        &quot;label&quot;: &quot;Planes que cierran el próximo mes&quot;,
        &quot;code&quot;: &quot;closed_next_month&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;developerName&quot;:&quot;Account_Planning_closed_next_month&quot;
    }
]</value>
    </values>
</CustomMetadata>
