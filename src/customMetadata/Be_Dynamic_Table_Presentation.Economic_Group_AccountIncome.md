<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Grupo Economico - Saldo Medio Anual</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_EconomicGroup_AccountIncome_cls</value>
    </values>
    <values>
        <field>Columns_Table_Configuration__c</field>
        <value xsi:type="xsd:string">{
&quot;ClientsGroup_AccountIncome&quot;: [
{
&quot;label&quot;: &quot;CLIENTE&quot;,
&quot;fieldName&quot;: &quot;URL__Id&quot;,
&quot;type&quot;: &quot;url&quot;,
&quot;typeAttributes&quot;: {
&quot;label&quot;: {
&quot;fieldName&quot;: &quot;CLIENT_NAME&quot;
},
&quot;target&quot;: &quot;_self&quot;
},
&quot;sortable&quot;: true
}, 
{
&quot;label&quot;: &quot;THIS_YEAR_USD&quot;,
&quot;fieldName&quot;: &quot;CURRENT_YEAR_USD&quot;,
&quot;type&quot;: &quot;number&quot;,
&quot;typeAttributes&quot;: {
&quot;formatStyle&quot;: &quot;decimal&quot;
},
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
},
{
&quot;label&quot;: &quot;THIS_YEAR_PEN&quot;,
&quot;fieldName&quot;: &quot;CURRENT_YEAR_PEN&quot;,
&quot;type&quot;: &quot;number&quot;,
&quot;typeAttributes&quot;: {
&quot;formatStyle&quot;: &quot;decimal&quot;
},
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
},
{
&quot;label&quot;: &quot;PREV_YEAR_USD&quot;,
&quot;fieldName&quot;: &quot;PAST_YEAR_USD&quot;,
&quot;type&quot;: &quot;number&quot;,
&quot;typeAttributes&quot;: {
&quot;formatStyle&quot;: &quot;decimal&quot;
},
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
},
{
&quot;label&quot;: &quot;PREV_YEAR_PEN&quot;,
&quot;fieldName&quot;: &quot;PAST_YEAR_PEN&quot;,
&quot;type&quot;: &quot;number&quot;,
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
}
]
}</value>
    </values>
    <values>
        <field>Filters__c</field>
        <value xsi:type="xsd:string">[
{
&quot;label&quot;: &quot;SALDO MEDIO ANUAL&quot;,
&quot;code&quot;: &quot;ClientsGroup_AccountIncome&quot;,
&quot;sobjectType&quot;: &quot;&quot;,
&quot;developerName&quot;:&quot;&quot;,
&quot;defaultFilter&quot;: true
}
]</value>
    </values>
    <values>
        <field>Replace_Fields_Configuration__c</field>
        <value xsi:type="xsd:string">[
{
&quot;code&quot;: &quot;ClientsGroup_AccountIncome&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;queryFields&quot;: &quot;acpl__participant_id__c&quot;,
&quot;queryFilters&quot;: &quot;Id =: recordId&quot;,
&quot;replaceField&quot; : &quot;acpl__participant_id__c&quot;
}
]</value>
    </values>
</CustomMetadata>
