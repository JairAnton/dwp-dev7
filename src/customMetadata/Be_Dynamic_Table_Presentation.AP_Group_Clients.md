<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Vista Clientes de Grupo Economico</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Columns_Table_Configuration__c</field>
        <value xsi:type="xsd:string">{
&quot;ClientsGroup&quot;: [
{
&quot;label&quot;: &quot;Cliente&quot;,
&quot;fieldName&quot;: &quot;URL__Id&quot;,
&quot;type&quot;: &quot;url&quot;,
&quot;typeAttributes&quot;: {
&quot;label&quot;: {
&quot;fieldName&quot;: &quot;Name&quot;
},
&quot;target&quot;: &quot;_self&quot;
},
&quot;sortable&quot;: true
},
{
&quot;label&quot;: &quot;Código central&quot;,
&quot;fieldName&quot;: &quot;main_code_id__c&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Segmento&quot;,
&quot;fieldName&quot;: &quot;segment_desc__c&quot;,
&quot;type&quot;: &quot;text&quot;
},
{
&quot;label&quot;: &quot;Buro&quot;,
&quot;fieldName&quot;: &quot;bureau_classification_type__c&quot;,
&quot;type&quot;: &quot;number&quot;,
&quot;typeAttributes&quot;: { &quot;format-style&quot;:&quot;decimal&quot;}
},
{
&quot;label&quot;: &quot;Estrategia&quot;,
&quot;fieldName&quot;: &quot;risk_strategy_class_name__c&quot;,
&quot;type&quot;: &quot;text&quot;
}
]
}</value>
    </values>
    <values>
        <field>Filters__c</field>
        <value xsi:type="xsd:string">[
{
&quot;label&quot;: &quot;Clientes del grupo&quot;,
&quot;code&quot;: &quot;ClientsGroup&quot;,
&quot;developerName&quot;:&quot;&quot;,
&quot;sobjectType&quot;: &quot;Account&quot;,
&quot;queryFields&quot;: &quot;Name, main_code_id__c, segment_desc__c, bureau_classification_type__c, risk_strategy_class_name__c&quot;,
&quot;queryFilters&quot;: &quot;parentId IN: replaceField&quot;, 
&quot;defaultFilter&quot;: true
}
]</value>
    </values>
    <values>
        <field>Replace_Fields_Configuration__c</field>
        <value xsi:type="xsd:string">[
{
&quot;code&quot;: &quot;ClientsGroup&quot;,
&quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
&quot;queryFields&quot;: &quot;acpl__participant_id__c&quot;,
&quot;queryFilters&quot;: &quot;Id =: recordId&quot;, 
&quot;replaceField&quot; : &quot;acpl__participant_id__c&quot;
}
]</value>
    </values>
</CustomMetadata>
