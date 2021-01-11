<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Related Accounts</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
&quot;values&quot;: [
{
&quot;label&quot;: &quot;Name&quot;,
&quot;fieldName&quot;: &quot;AccountId&quot;,
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
&quot;label&quot;: &quot;Contacto&quot;,
&quot;fieldName&quot;: &quot;ContactId&quot;,
&quot;type&quot;: &quot;customlookup&quot;,
&quot;typeAttributes&quot;: {
&quot;isCustom&quot;: true,
&quot;fieldName&quot;: &quot;Id&quot;,
&quot;label&quot;: &quot;Name&quot;,
&quot;objectApiName&quot;: &quot;Contact&quot;,
&quot;rowData&quot;: {
&quot;fieldName&quot;: &quot;rowData&quot;
}
}
},
{
&quot;label&quot;: &quot;Cargo&quot;,
&quot;fieldName&quot;: &quot;calc_prof_position_type__c&quot;,
&quot;type&quot;: &quot;picklist&quot;
},
{
&quot;label&quot;: &quot;Decisor&quot;,
&quot;fieldName&quot;: &quot;decision_making_desc__c&quot;,
&quot;type&quot;: &quot;checkbox&quot;
},
{
&quot;label&quot;: &quot;Celular&quot;,
&quot;fieldName&quot;: &quot;MobilePhone__c&quot;,
&quot;type&quot;: &quot;Phone&quot;
},
{
&quot;type&quot;: &quot;action&quot;,
&quot;typeAttributes&quot;: {
&quot;rowActions&quot;: [
{
&quot;name&quot;: &quot;view&quot;,
&quot;objectApiName&quot;: &quot;AccountContactRelation&quot;,
&quot;label&quot;: {
&quot;es&quot;: &quot;Ver relación&quot;,
&quot;en-US&quot;: &quot;View Relationship&quot;
},
&quot;title&quot;: {
&quot;es&quot;: &quot;Relación de contacto de cuenta&quot;,
&quot;en-US&quot;: &quot;Account Contact Relationship&quot;
}
},
{
&quot;name&quot;: &quot;update&quot;,
&quot;className&quot;: &quot;BE_NonClient_Contact_Ctr&quot;,
&quot;objectApiName&quot;: &quot;AccountContactRelation&quot;,
&quot;title&quot;: {
&quot;es&quot;: &quot;Modificar Relación de contacto de cuenta&quot;,
&quot;en-US&quot;: &quot;Modify Account Contact Relationship&quot;
},
&quot;label&quot;: {
&quot;es&quot;: &quot;Editar relación&quot;,
&quot;en-US&quot;: &quot;Edit Relationship&quot;
},
&quot;fields&quot;: [
{
&quot;fieldName&quot;: &quot;ContactId&quot;,
&quot;required&quot;: &quot;true&quot;,
&quot;disabled&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;AccountId&quot;,
&quot;required&quot;: &quot;true&quot;,
&quot;disabled&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;prof_position_type__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;other_prof_prosition_type__c&quot;
},
{
&quot;fieldName&quot;: &quot;decision_making_desc__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;MobilePhone__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;email__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;isDirect&quot;
},
{
&quot;fieldName&quot;: &quot;phone_1_area_code__c&quot;
},
{
&quot;fieldName&quot;: &quot;phone_1__c&quot;
},
{
&quot;fieldName&quot;: &quot;phone_2_area_code__c&quot;
},
{
&quot;fieldName&quot;: &quot;phone_2__c&quot;
},
{
&quot;fieldName&quot;: &quot;events_info_type__c&quot;
},
{
&quot;fieldName&quot;: &quot;Description__c&quot;
}
]
},
{
&quot;name&quot;: &quot;delete&quot;,
&quot;label&quot;: {
&quot;es&quot;: &quot;Eliminar relación&quot;,
&quot;en-US&quot;: &quot;Remove Relationship&quot;
},
&quot;className&quot;: &quot;BE_NonClient_Contact_Ctr&quot;,
&quot;objectApiName&quot;: &quot;AccountContactRelation&quot;,
&quot;title&quot;: {
&quot;es&quot;: &quot;Eliminar Relación de contacto de cuenta&quot;,
&quot;en-US&quot;: &quot;Delete Account Contact Relationship&quot;
}
}
]
}
}
]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Contact.Name,Account.Name,calc_prof_position_type__c,decision_making_desc__c,Contact_decisor__c,MobilePhone__c,email__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">ContactId=:recordId</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;name&quot;: &quot;insert&quot;,
            &quot;className&quot;: &quot;BE_NonClient_Contact_Ctr&quot;,
            &quot;objectApiName&quot;: &quot;AccountContactRelation&quot;,
            &quot;defaultValue&quot;: &quot;ContactId&quot;,
            &quot;label&quot;: {
                &quot;es&quot;: &quot;Agregar relación&quot;,
                &quot;en-US&quot;: &quot;Add Relationship&quot;
            },
            &quot;title&quot;: {
                &quot;es&quot;: &quot;Nueva Relación de contacto de cuenta &quot;,
                &quot;en-US&quot;: &quot;New Account Contact Relationship&quot;
            },
            &quot;fields&quot;: [
                {
                    &quot;fieldName&quot;: &quot;ContactId&quot;,
                    &quot;required&quot;: &quot;true&quot;,                 
                    &quot;value&quot;: &quot;recordId&quot;,
                    &quot;disabled&quot;: true
                },
                {
                    &quot;fieldName&quot;: &quot;AccountId&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;prof_position_type__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;other_prof_prosition_type__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;decision_making_desc__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;MobilePhone__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;email__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Status_desc__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;phone_1_area_code__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;phone_1__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;phone_2_area_code__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;phone_2__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;events_info_type__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Description__c&quot;
                }
            ]
        }
    ]
}</value>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">AccountContactRelation</value>
    </values>
</CustomMetadata>
