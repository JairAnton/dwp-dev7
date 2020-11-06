<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AP - Accionistas</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
{
            &quot;label&quot;: &quot;FIADOR&quot;,
            &quot;fieldName&quot;: &quot;Guarantor__c&quot;,
            &quot;type&quot;: &quot;boolean&quot;,
&quot;hideDefaultActions&quot;: true,
&quot;fixedWidth&quot; : 70,
            &quot;editable&quot;: true
        },
        {
            &quot;label&quot;: &quot;TIPO DE DOCUMENTO&quot;,
            &quot;fieldName&quot;: &quot;DocumentType__c&quot;,
            &quot;type&quot;: &quot;text&quot;,
&quot;hideDefaultActions&quot;: true
        },
{
            &quot;label&quot;: &quot;NÚMERO DE DOCUMENTO&quot;,
            &quot;fieldName&quot;: &quot;DocumentNumber__c&quot;,
            &quot;type&quot;: &quot;text&quot;,
&quot;hideDefaultActions&quot;: true,
            &quot;editable&quot;: true
        },
        {
            &quot;label&quot;: &quot;NOMBRE DE ACCIONISTA&quot;,
            &quot;fieldName&quot;: &quot;Name&quot;,
            &quot;type&quot;: &quot;text&quot;,
&quot;hideDefaultActions&quot;: true,
&quot;editable&quot;: true
        },
{
            &quot;label&quot;: &quot;PARTICIPACIÓN&quot;,
            &quot;fieldName&quot;: &quot;Participation__c&quot;,
            &quot;type&quot;: &quot;number&quot;,
&quot;hideDefaultActions&quot;: true,
&quot;typeAttributes&quot;: {
                &quot;minimumFractionDigits&quot;: &quot;2&quot;,
                &quot;maximumFractionDigits&quot;: &quot;2&quot;,
&quot;formatStyle&quot;: &quot;percent&quot;
            },
&quot;fixedWidth&quot; : 120,
&quot;editable&quot;: true
        },
{
&quot;type&quot;: &quot;action&quot;,
&quot;typeAttributes&quot;: {
&quot;rowActions&quot;: [
{
&quot;name&quot;: &quot;view&quot;,
&quot;objectApiName&quot;: &quot;BE_Stockholder__c&quot;,
&quot;label&quot;: {
&quot;es&quot;: &quot;Ver detalle&quot;,
&quot;en-US&quot;: &quot;View detail&quot;
},
&quot;title&quot;: {
&quot;es&quot;: &quot;Detalle del Accionista&quot;,
&quot;en-US&quot;: &quot;Guarantor detail&quot;
}
},
{
&quot;name&quot;: &quot;update&quot;,
&quot;className&quot;: &quot;&quot;,
&quot;objectApiName&quot;: &quot;BE_Stockholder__c&quot;,
&quot;title&quot;: {
&quot;es&quot;: &quot;Editar Accionista&quot;,
&quot;en-US&quot;: &quot;Edit Guarantor&quot;
},
&quot;label&quot;: {
&quot;es&quot;: &quot;Editar accionista&quot;,
&quot;en-US&quot;: &quot;Edit guarantor&quot;
},
&quot;fields&quot;: [
{
&quot;fieldName&quot;: &quot;Guarantor__c&quot;
},
{
&quot;fieldName&quot;: &quot;DocumentType__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;DocumentNumber__c&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;Name&quot;,
&quot;required&quot;: &quot;true&quot;
},
{
&quot;fieldName&quot;: &quot;Nationality__c&quot;
},
{
&quot;fieldName&quot;: &quot;Participation__c&quot;
},
{
&quot;fieldName&quot;: &quot;Buro__c&quot;
},
{
&quot;fieldName&quot;: &quot;BBVA_Classification__c&quot;
},
{
&quot;fieldName&quot;: &quot;BBVA_Debt__c&quot;
},
{
&quot;fieldName&quot;: &quot;SBS_Classification__c&quot;
},
{
&quot;fieldName&quot;: &quot;SBS_Debt__c&quot;
}
]
},
{
&quot;name&quot;: &quot;delete&quot;,
&quot;label&quot;: {
&quot;es&quot;: &quot;Eliminar accionista&quot;,
&quot;en-US&quot;: &quot;Delete guarantor&quot;
},
&quot;className&quot;: &quot;&quot;,
&quot;objectApiName&quot;: &quot;BE_Stockholder__c&quot;,
&quot;title&quot;: {
&quot;es&quot;: &quot;Eliminar accionista&quot;,
&quot;en-US&quot;: &quot;Delete guarantor&quot;
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
        <value xsi:type="xsd:string">Guarantor__c, toLabel(DocumentType__c), DocumentNumber__c, Name, Nationality__c, Participation__c, Buro__c, BBVA_Classification__c, BBVA_Debt__c, SBS_Classification__c, SBS_Debt__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">Account_Planning__c =: recordId</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;name&quot;: &quot;insert&quot;,
            &quot;className&quot;: &quot;&quot;,
            &quot;objectApiName&quot;: &quot;BE_Stockholder__c&quot;,
            &quot;label&quot;: {
                &quot;es&quot;: &quot;Nuevo Accionista&quot;,
                &quot;en-US&quot;: &quot;New Guarantor&quot;
            },
            &quot;title&quot;: {
                &quot;es&quot;: &quot;Nuevo Accionista&quot;,
                &quot;en-US&quot;: &quot;New Guarantor&quot;
            },
            &quot;fields&quot;: [
                {
                    &quot;fieldName&quot;: &quot;Guarantor__c&quot;,
                    &quot;required&quot;: false
                },
                {
                    &quot;fieldName&quot;: &quot;DocumentType__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;DocumentNumber__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Name&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Nationality__c&quot;,
                    &quot;required&quot;: false
                },
{
                    &quot;fieldName&quot;: &quot;Participation__c&quot;,
                    &quot;required&quot;: false
                },
                {
                    &quot;fieldName&quot;: &quot;Buro__c&quot;,
                    &quot;required&quot;: false
                },
{
                    &quot;fieldName&quot;: &quot;BBVA_Classification__c&quot;,
                    &quot;required&quot;: false
                },
                {
                    &quot;fieldName&quot;: &quot;BBVA_Debt__c&quot;,
                    &quot;required&quot;: false
                },
{
                    &quot;fieldName&quot;: &quot;SBS_Classification__c&quot;,
                    &quot;required&quot;: false
                },
                {
                    &quot;fieldName&quot;: &quot;SBS_Debt__c&quot;,
                    &quot;required&quot;: false
                },
                {
                    &quot;fieldName&quot;: &quot;Account_Planning__c&quot;,
                    &quot;required&quot;: &quot;true&quot;,
                    &quot;disabled&quot;: &quot;true&quot;,
                    &quot;value&quot;: &quot;recordId&quot;
                }
            ]
        }
    ]
}</value>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
&quot;updateClassName&quot;: &quot;&quot;,
&quot;refreshView&quot;: true
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">BE_Stockholder__c</value>
    </values>
</CustomMetadata>
