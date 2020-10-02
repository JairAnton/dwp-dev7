<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AP Proximas Visitas - Clientes</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;NOMBRE DE LA VISITA&quot;,
            &quot;fieldName&quot;: &quot;Name&quot;,
            &quot;type&quot;: &quot;Text&quot;
        },
        {
            &quot;label&quot;: &quot;FECHA DE INICIO&quot;,
            &quot;fieldName&quot;: &quot;start_date_calculated__c&quot;,
            &quot;type&quot;: &quot;Date&quot;
        },
        {
            &quot;label&quot;: &quot;COMENTARIOS&quot;,
            &quot;fieldName&quot;: &quot;dwp_kitv__visit_desc__c&quot;,
            &quot;type&quot;: &quot;TextArea&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Name,start_date_calculated__c,dwp_kitv__visit_desc__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">dwp_kitv__account_id__c  =: recordId AND start_date_calculated__c &gt;= TODAY ORDER BY start_date_calculated__c DESC</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
    &quot;readClassName&quot;: &quot;BE_AP_NextVisits_cls&quot;
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">dwp_kitv__Visit__c</value>
    </values>
</CustomMetadata>
