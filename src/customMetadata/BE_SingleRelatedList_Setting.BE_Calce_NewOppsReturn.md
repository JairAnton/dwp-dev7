<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Oportunidades nuevas a retomar</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Account.Name,opportunity_product__c,Name,CloseDate,Amount,toLabel(StageName)</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">OwnerId=@@0054C000001YhvKQAS@@</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">10.0</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
</CustomMetadata>
