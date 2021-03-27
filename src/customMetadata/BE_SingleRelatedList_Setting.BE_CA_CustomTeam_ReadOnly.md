<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_CA_CustomTeam_ReadOnly</label>
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
            &quot;fieldName&quot;: &quot;UserOrGroupId&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;UserOrGroup&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Accesso&quot;,
            &quot;fieldName&quot;: &quot;AccessLevel&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Tipo&quot;,
            &quot;fieldName&quot;: &quot;RowCause&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Fecha de modificación&quot;,
            &quot;fieldName&quot;: &quot;LastModifiedDate&quot;,
            &quot;type&quot;: &quot;date-local&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">toLabel(AccessLevel),UserOrGroup.Name,ParentId,toLabel(RowCause),UserOrGroup.UserRole.Name,LastModifiedDate</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">ParentId=:recordId</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">5.0</value>
    </values>
    <values>
        <field>Order__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
&quot;readClassName&quot;: &quot;BE_CA_CustomTeam_Cls&quot;
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">altm__Commercial_Alert__Share</value>
    </values>
</CustomMetadata>
