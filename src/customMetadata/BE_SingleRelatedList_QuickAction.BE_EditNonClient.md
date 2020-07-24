<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_EditNonClient</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:type="xsd:string">BE_EditNonClient_Ctr</value>
    </values>
    <values>
        <field>CustomFields__c</field>
        <value xsi:type="xsd:string">{
&quot;fields&quot;: [
{
&quot;fieldName&quot;: &quot;Name&quot;,
&quot;disabled&quot;: true
},
{
&quot;fieldName&quot;: &quot;ParentId&quot;
},
{
&quot;fieldName&quot;: &quot;AccountNumber&quot;,
&quot;disabled&quot;: true
},
{
&quot;fieldName&quot;: &quot;economic_activity_sector__c&quot;
},
{
&quot;fieldName&quot;: &quot;phone_area_code__c&quot;,
&quot;required&quot;: true
},
{
&quot;fieldName&quot;: &quot;other_phone_number__c&quot;,
&quot;required&quot;: true
},
{
&quot;fieldName&quot;: &quot;Website&quot;
},
{
&quot;fieldName&quot;: &quot;email__c&quot;
},
{
&quot;fieldName&quot;: &quot;OwnerId&quot;,
&quot;required&quot;: true
},
{
&quot;fieldName&quot;: &quot;Description&quot;
},
{
&quot;fieldName&quot;: &quot;BillingStreet&quot;
},
{
&quot;fieldName&quot;: &quot;BillingCity&quot;
},
{
&quot;fieldName&quot;: &quot;BillingState&quot;
},
{
&quot;fieldName&quot;: &quot;BillingCountry&quot;
}
]
}</value>
    </values>
    <values>
        <field>ModeAction__c</field>
        <value xsi:type="xsd:string">update</value>
    </values>
    <values>
        <field>Title__c</field>
        <value xsi:type="xsd:string">{ &quot;es&quot;: &quot;Modificar No Cliente&quot;, &quot;en_US&quot;: &quot;Modify Non Client&quot; }</value>
    </values>
    <values>
        <field>sObjectType__c</field>
        <value xsi:type="xsd:string">Account</value>
    </values>
</CustomMetadata>
