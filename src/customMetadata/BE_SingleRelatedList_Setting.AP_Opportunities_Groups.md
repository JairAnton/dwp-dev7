<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AP Opportunidades - Grupos</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;NOMBRE DE LA OPORTUNIDAD&quot;,
            &quot;fieldName&quot;: &quot;Name&quot;,
            &quot;type&quot;: &quot;Text&quot;
        },
{
            &quot;label&quot;: &quot;CLIENTE&quot;,
            &quot;fieldName&quot;: &quot;Account&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
&quot;typeAttributes&quot;: {
&quot;isCustom&quot;: true,
&quot;fieldName&quot;: &quot;Id&quot;,
&quot;label&quot;: &quot;Name&quot;,
&quot;objectApiName&quot;: &quot;Account&quot;,
&quot;rowData&quot;: {
&quot;fieldName&quot;: &quot;rowData&quot;
}
}
},
        {
            &quot;label&quot;: &quot;ESTADO&quot;,
            &quot;fieldName&quot;: &quot;opportunity_status_type__c&quot;,
            &quot;type&quot;: &quot;Picklist&quot;
        },
        {
            &quot;label&quot;: &quot;IMPORTE&quot;,
            &quot;fieldName&quot;: &quot;Amount&quot;,
            &quot;type&quot;: &quot;currency&quot;
        },
        {
            &quot;label&quot;: &quot;FECHA DE CIERRE&quot;,
            &quot;fieldName&quot;: &quot;CloseDate&quot;,
            &quot;type&quot;: &quot;Date&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Name,toLabel(opportunity_status_type__c),Amount,CloseDate,Account.Name</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">AccountId IN: recordId AND CloseDate = THIS_YEAR</value>
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
    &quot;readClassName&quot;: &quot;BE_AP_OpportunityInProgress_cls&quot;
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
</CustomMetadata>
