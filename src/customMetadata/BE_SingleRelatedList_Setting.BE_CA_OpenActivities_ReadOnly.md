<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CA-OpenActivities</label>
    <protected>false</protected>
    <values>
        <field>BE_SingleRetatedListView__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;&quot;,
            &quot;fieldName&quot;: &quot;Id&quot;,
            &quot;type&quot;: &quot;customurl&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                },
                &quot;isCustom&quot;: true,
                &quot;label&quot;: &quot;Subject&quot;,
                &quot;fieldName&quot;: &quot;Id&quot;
            }
        },
        {
            &quot;label&quot;: &quot;Fecha de vencimiento&quot;,
            &quot;fieldName&quot;: &quot;ActivityDate&quot;,
            &quot;type&quot;: &quot;date-local&quot;
        },
        {
            &quot;label&quot;: &quot;Estado&quot;,
            &quot;fieldName&quot;: &quot;Status&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;Asignado a&quot;,
            &quot;fieldName&quot;: &quot;OwnerId&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;Owner&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Subject,Owner.Name,LastModifiedBy.Name,Status,ActivityDate</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">WhatId=:recordId</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Order__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Task</value>
    </values>
</CustomMetadata>
