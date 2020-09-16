<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Grupo Economico - Spread y Tasa</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_EconomicGroup_Spread_Rate_cls</value>
    </values>
    <values>
        <field>Columns_Table_Configuration__c</field>
        <value xsi:type="xsd:string">{
&quot;ClientsGroup_Spread_Rate&quot;: [
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
&quot;label&quot;: &quot;SPREAD&quot;,
&quot;fieldName&quot;: &quot;Spread&quot;,
&quot;type&quot;: &quot;text&quot;,
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
},
{
&quot;label&quot;: &quot;TASA&quot;,
&quot;fieldName&quot;: &quot;Tasa&quot;,
&quot;type&quot;: &quot;text&quot;,
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
},
{
&quot;label&quot;: &quot;ULTIMO MES&quot;,
&quot;fieldName&quot;: &quot;MONTH&quot;,
&quot;type&quot;: &quot;text&quot;,
&quot;cellAttributes&quot;: { &quot;alignment&quot;: &quot;left&quot;} 
}
]
}</value>
    </values>
    <values>
        <field>Filters__c</field>
        <value xsi:type="xsd:string">[
{
&quot;label&quot;: &quot;Spread y Tasa&quot;,
&quot;code&quot;: &quot;ClientsGroup_Spread_Rate&quot;,
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
&quot;code&quot;: &quot;ClientsGroup_Spread_Rate&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;queryFields&quot;: &quot;acpl__participant_id__c&quot;,
&quot;queryFilters&quot;: &quot;Id =: recordId&quot;,
&quot;replaceField&quot; : &quot;acpl__participant_id__c&quot;
}
]</value>
    </values>
</CustomMetadata>
