<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Non Client Contacts</label>
    <protected>false</protected>
    <values>
        <field>BtnConfig__c</field>
        <value xsi:type="xsd:string">{
    &quot;AddRelationship&quot;: {
        &quot;name&quot;: &quot;AddRelationship&quot;,
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
                &quot;required&quot;: &quot;true&quot;
            },
            {
                &quot;fieldName&quot;: &quot;AccountId&quot;,
                &quot;required&quot;: &quot;true&quot;,
                &quot;value&quot;: &quot;recordId&quot;
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
        ],
        &quot;mode&quot;: &quot;insert&quot;,
        &quot;sObjectApiName&quot;: &quot;AccountContactRelation&quot;,
        &quot;defaultValue&quot;: &quot;AccountId&quot;
    }
}</value>
    </values>
    <values>
        <field>FieldsButtons__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Contact.Name,calc_prof_position_type__c,decision_making_desc__c,Contact_decisor__c </value>
    </values>
    <values>
        <field>FieldsUrlRelationship__c</field>
        <value xsi:type="xsd:string">{
    &quot;Contact&quot;: {
        &quot;label&quot;: &quot;Name&quot;,
        &quot;fieldName&quot;: &quot;Id&quot;,
        &quot;isObject&quot;: true,
        &quot;type&quot;: &quot;url&quot;,
        &quot;relApiName&quot;: &quot;Contact&quot;
    }
}</value>
    </values>
    <values>
        <field>Fields__c</field>
        <value xsi:type="xsd:string">Contact,calc_prof_position_type__c,decision_making_desc__c,Contact_decisor__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">AccountId=:recordId</value>
    </values>
    <values>
        <field>Labels__c</field>
        <value xsi:type="xsd:string">Nombre,Cargo,Rol,Decisor</value>
    </values>
    <values>
        <field>ModalName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>RowActionDelete__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>RowActionView__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>RowActions__c</field>
        <value xsi:type="xsd:string">{
    &quot;view&quot;: {
        &quot;label&quot;: {
            &quot;es&quot;: &quot;Ver relación&quot;,
            &quot;en-US&quot;: &quot;View Relationship&quot;
        },
        &quot;title&quot;: {
            &quot;es&quot;: &quot;Relación de contacto de cuenta&quot;,
            &quot;en-US&quot;: &quot;Account Contact Relationship&quot;
        },
        &quot;name&quot;: &quot;view&quot;
    },
    &quot;update&quot;: {
        &quot;label&quot;: {
            &quot;es&quot;: &quot;Editar relación&quot;,
            &quot;en-US&quot;: &quot;Edit Relationship&quot;
        },
        &quot;title&quot;: {
            &quot;es&quot;: &quot;Modificar Relación de contacto de cuenta&quot;,
            &quot;en-US&quot;: &quot;Modify Account Contact Relationship&quot;
        },
        &quot;name&quot;: &quot;update&quot;,
        &quot;fields&quot;: [
            {
                &quot;fieldName&quot;: &quot;ContactId&quot;,
                &quot;required&quot;: &quot;true&quot;
            },
            {
                &quot;fieldName&quot;: &quot;AccountId&quot;,
                &quot;required&quot;: &quot;true&quot;,
                &quot;value&quot;: &quot;recordId&quot;
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
    },
    &quot;delete&quot;: {
        &quot;label&quot;: {
            &quot;es&quot;: &quot;Eliminar relación&quot;,
            &quot;en-US&quot;: &quot;Remove Relationship&quot;
        },
        &quot;title&quot;: {
            &quot;es&quot;: &quot;Eliminar Relación de contacto de cuenta&quot;,
            &quot;en-US&quot;: &quot;Delete Account Contact Relationship&quot;
        },
        &quot;name&quot;: &quot;delete&quot;
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
        <value xsi:type="xsd:string">AccountContactRelation</value>
    </values>
</CustomMetadata>
