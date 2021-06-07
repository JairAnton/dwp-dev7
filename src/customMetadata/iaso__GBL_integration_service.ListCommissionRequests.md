<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ListCommissionRequests</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Blocked_Service__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">ListCommissionRequests</value>
    </values>
    <values>
        <field>iaso__Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Headers_Class__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;Content-Type&quot;: &quot;application/json&quot;, &quot;back-clientdocument&quot;:&quot;&quot;}</value>
    </values>
    <values>
        <field>iaso__Http_Method__c</field>
        <value xsi:type="xsd:string">GET</value>
    </values>
    <values>
        <field>iaso__IsCacheable__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;data&quot;:[{&quot;id&quot;:&quot;CO239&quot;,&quot;name&quot;:&quot;Por Liquidación Anticipada&quot;,&quot;product&quot;:{&quot;id&quot;:&quot;5&quot;,&quot;modality&quot;:{&quot;id&quot;:&quot;8&quot;}},&quot;currency&quot;:&quot;PEN&quot;,&quot;isNegotiable&quot;:true,&quot;isRORCApplicable&quot;:false,&quot;calculationType&quot;:&quot;PERCENTAGE&quot;,&quot;settledValues&quot;:[{&quot;settledValueType&quot;:&quot;PERCENTAGE&quot;,&quot;percentage&quot;:5,&quot;name&quot;:&quot;SUGGESTED_RATE&quot;}],&quot;maximumValue&quot;:{&quot;currency&quot;:&quot;PEN&quot;},&quot;minimumValue&quot;:{&quot;currency&quot;:&quot;PEN&quot;},&quot;isTermIncluded&quot;:true,&quot;paymenMethod&quot;:{&quot;frequency&quot;:{&quot;id&quot;:&quot;MONTHLY&quot;}},&quot;term&quot;:{&quot;frequency&quot;:{&quot;id&quot;:&quot;MONTHLY&quot;},&quot;number&quot;:12},&quot;additionalAmount&quot;:{},&quot;questionnaire&quot;:{&quot;id&quot;:&quot;CU0022&quot;,&quot;questions&quot;:[{&quot;id&quot;:&quot;2&quot;,&quot;outputType&quot;:&quot;YES_OR_NOT&quot;,&quot;description&quot;:&quot;El Plazo es mayor a 12?&quot;,&quot;parentId&quot;:&quot;1&quot;,&quot;parentOutputType&quot;:&quot;YES_OR_NOT&quot;,&quot;parentAnswerActivator&quot;:&quot;SI&quot;},{&quot;id&quot;:&quot;1&quot;,&quot;outputType&quot;:&quot;YES_OR_NOT&quot;,&quot;description&quot;:&quot;El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?&quot;}]}},{&quot;id&quot;:&quot;CO235&quot;,&quot;name&quot;:&quot;Por Liquidación Anticipada&quot;,&quot;product&quot;:{&quot;id&quot;:&quot;5&quot;,&quot;modality&quot;:{&quot;id&quot;:&quot;8&quot;}},&quot;currency&quot;:&quot;PEN&quot;,&quot;isNegotiable&quot;:true,&quot;isRORCApplicable&quot;:false,&quot;calculationType&quot;:&quot;PERCENTAGE&quot;,&quot;settledValues&quot;:[{&quot;settledValueType&quot;:&quot;PERCENTAGE&quot;,&quot;percentage&quot;:5,&quot;name&quot;:&quot;SUGGESTED_RATE&quot;}],&quot;maximumValue&quot;:{&quot;currency&quot;:&quot;PEN&quot;},&quot;minimumValue&quot;:{&quot;currency&quot;:&quot;PEN&quot;},&quot;isTermIncluded&quot;:true,&quot;paymenMethod&quot;:{&quot;frequency&quot;:{&quot;id&quot;:&quot;MONTHLY&quot;}},&quot;term&quot;:{&quot;frequency&quot;:{&quot;id&quot;:&quot;MONTHLY&quot;},&quot;number&quot;:12},&quot;additionalAmount&quot;:{},&quot;questionnaire&quot;:{&quot;id&quot;:&quot;CU0022&quot;,&quot;questions&quot;:[{&quot;id&quot;:&quot;2&quot;,&quot;outputType&quot;:&quot;YES_OR_NOT&quot;,&quot;description&quot;:&quot;El Plazo es mayor a 12?&quot;,&quot;parentId&quot;:&quot;1&quot;,&quot;parentOutputType&quot;:&quot;YES_OR_NOT&quot;,&quot;parentAnswerActivator&quot;:&quot;SI&quot;},{&quot;id&quot;:&quot;1&quot;,&quot;outputType&quot;:&quot;YES_OR_NOT&quot;,&quot;description&quot;:&quot;El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?&quot;}]}},{&quot;id&quot;:&quot;CO229&quot;,&quot;name&quot;:&quot;Comisión de Estructuración&quot;,&quot;product&quot;:{&quot;id&quot;:&quot;5&quot;,&quot;modality&quot;:{&quot;id&quot;:&quot;8&quot;}},&quot;currency&quot;:&quot;PEN&quot;,&quot;isNegotiable&quot;:true,&quot;isRORCApplicable&quot;:true,&quot;calculationType&quot;:&quot;PERCENTAGE&quot;,&quot;settledValues&quot;:[{&quot;settledValueType&quot;:&quot;PERCENTAGE&quot;,&quot;percentage&quot;:1,&quot;name&quot;:&quot;SUGGESTED_RATE&quot;}],&quot;maximumValue&quot;:{&quot;currency&quot;:&quot;PEN&quot;},&quot;minimumValue&quot;:{&quot;amount&quot;:850,&quot;currency&quot;:&quot;PEN&quot;},&quot;isTermIncluded&quot;:false,&quot;paymenMethod&quot;:{},&quot;term&quot;:{},&quot;additionalAmount&quot;:{}},{&quot;id&quot;:&quot;CO217&quot;,&quot;name&quot;:&quot;Gestión Operativa&quot;,&quot;product&quot;:{&quot;id&quot;:&quot;5&quot;,&quot;modality&quot;:{&quot;id&quot;:&quot;8&quot;}},&quot;currency&quot;:&quot;PEN&quot;,&quot;isNegotiable&quot;:true,&quot;isRORCApplicable&quot;:true,&quot;calculationType&quot;:&quot;PERCENTAGE&quot;,&quot;settledValues&quot;:[{&quot;settledValueType&quot;:&quot;PERCENTAGE&quot;,&quot;percentage&quot;:20,&quot;name&quot;:&quot;SUGGESTED_RATE&quot;}],&quot;maximumValue&quot;:{&quot;amount&quot;:700,&quot;currency&quot;:&quot;PEN&quot;},&quot;minimumValue&quot;:{&quot;amount&quot;:120,&quot;currency&quot;:&quot;PEN&quot;},&quot;isTermIncluded&quot;:false,&quot;paymenMethod&quot;:{},&quot;term&quot;:{},&quot;additionalAmount&quot;:{}}]}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">?product.id=#productModelCode#&amp;product.modality.id=#modalityCode#&amp;product.guarantee.id=#guarantyCode#&amp;currency=#currencyCode#</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA_TEMP__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
</CustomMetadata>
