<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Garantías de Prendas</label>
    <protected>false</protected>
    <values>
        <field>BtnConfig__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>FieldsButtons__c</field>
        <value xsi:type="xsd:string">{&quot;Name&quot;:&quot;Id&quot;,&quot;typeAttributes&quot;:{&quot;label&quot;:{&quot;fieldName&quot;:&quot;Name&quot;},&quot;title&quot;:&quot;Mostrar detalles&quot;,&quot;name&quot;:&quot;show_details&quot;,&quot;disabled&quot;:false,&quot;value&quot;:&quot;view&quot;,&quot;iconName&quot;:&quot;utility:search&quot;,&quot;iconPosition&quot;:&quot;right&quot;}}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">toLabel(guarantee_type__c),Name,guaranteed_amount__c,toLabel(guarantee_status_type__c),guarantee_release_date__c,toLabel(guarantee_class__c) </value>
    </values>
    <values>
        <field>FieldsUrlRelationship__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Fields__c</field>
        <value xsi:type="xsd:string">guarantee_type__c,Name,guaranteed_amount__c,guarantee_status_type__c,guarantee_release_date__c,guarantee_class__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">account_id__c=:recordId AND guarantee_type__c IN (@@131@@,@@133@@,@@136@@,@@143@@,@@301@@,@@302@@,@@303@@,@@304@@,@@305@@) ORDER BY guarantee_release_date__c DESC NULLS LAST, guarantee_status_type__c ASC</value>
    </values>
    <values>
        <field>Labels__c</field>
        <value xsi:type="xsd:string">Tipo,N° Garantía,Importe,Situación,F.Formalización,Clase</value>
    </values>
    <values>
        <field>ModalName__c</field>
        <value xsi:type="xsd:string">Guarantee_Detailes_Prendas</value>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>maximumFractionDigits__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>minimumFractionDigits__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Guarantee__c</value>
    </values>
</CustomMetadata>
