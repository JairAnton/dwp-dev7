<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Oportunidades en progreso</label>
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
        <value xsi:type="xsd:string">Name,toLabel(StageName),Amount,CloseDate</value>
    </values>
    <values>
        <field>FieldsUrlRelationship__c</field>
        <value xsi:type="xsd:string">{&quot;Name&quot;:{&quot;label&quot;:&quot;Name&quot;,&quot;fieldName&quot;:&quot;Id&quot;,&quot;isObject&quot;:false,&quot;type&quot;:&quot;url&quot;}}</value>
    </values>
    <values>
        <field>Fields__c</field>
        <value xsi:type="xsd:string">Name,StageName,Amount,CloseDate</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">AccountId=:recordId AND StageName IN (@@02@@,@@03@@,@@04@@,@@05@@)</value>
    </values>
    <values>
        <field>Labels__c</field>
        <value xsi:type="xsd:string">Nombre,Etapa,Monto,Fecha de cierre</value>
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
        <field>UrlRelConfig__c</field>
        <value xsi:type="xsd:string">{
    &quot;Name&quot;: {
        &quot;label&quot;: &quot;Name&quot;,
        &quot;fieldName&quot;: &quot;Id&quot;,
        &quot;isObject&quot;: false,
        &quot;type&quot;: &quot;url&quot;
    },
    &quot;CreatedBy&quot;: {
        &quot;label&quot;: &quot;Name&quot;,
        &quot;fieldName&quot;: &quot;Id&quot;,
        &quot;isObject&quot;: true,
        &quot;type&quot;: &quot;url&quot;,
        &quot;relApiName&quot;: &quot;CreatedBy&quot;
    }
}</value>
    </values>
    <values>
        <field>maximumFractionDigits__c</field>
        <value xsi:type="xsd:double">2.0</value>
    </values>
    <values>
        <field>minimumFractionDigits__c</field>
        <value xsi:type="xsd:double">2.0</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
</CustomMetadata>
