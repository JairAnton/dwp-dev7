<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Visitas pasadas</label>
    <protected>false</protected>
    <values>
        <field>BtnConfig__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>FieldsButtons__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Name,start_date_calculated__c,CreatedBy.Name </value>
    </values>
    <values>
        <field>FieldsUrlRelationship__c</field>
        <value xsi:type="xsd:string">{
    &quot;Name&quot;: {
        &quot;label&quot;: &quot;Name&quot;,
        &quot;fieldName&quot;: &quot;Id&quot;,
        &quot;isObject&quot;: false,
        &quot;type&quot;: &quot;url&quot;
    },
    &quot;CreatedByName&quot;: {
        &quot;label&quot;: &quot;Name&quot;,
        &quot;fieldName&quot;: &quot;Id&quot;,
        &quot;isObject&quot;: true,
        &quot;type&quot;: &quot;url&quot;,
        &quot;relApiName&quot;: &quot;CreatedBy&quot;
    }
}</value>
    </values>
    <values>
        <field>Fields__c</field>
        <value xsi:type="xsd:string">Name,start_date_calculated__c,CreatedByName</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">dwp_kitv__account_id__c = :recordId AND start_date_calculated__c &lt; TODAY ORDER BY start_date_calculated__c DESC</value>
    </values>
    <values>
        <field>Labels__c</field>
        <value xsi:type="xsd:string">NOMBRE,FECHA DE INICIO,CREADO POR</value>
    </values>
    <values>
        <field>ModalName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">5.0</value>
    </values>
    <values>
        <field>maximumFractionDigits__c</field>
        <value xsi:type="xsd:double">0.0</value>
    </values>
    <values>
        <field>minimumFractionDigits__c</field>
        <value xsi:type="xsd:double">0.0</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">dwp_kitv__Visit__c</value>
    </values>
</CustomMetadata>
