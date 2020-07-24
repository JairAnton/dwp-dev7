<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>List Clients</label>
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
        <value xsi:type="xsd:string">ListClients</value>
    </values>
    <values>
        <field>iaso__Description__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Headers_Class__c</field>
        <value xsi:type="xsd:string">Header_helper</value>
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
        <value xsi:type="xsd:string">{
    &quot;data&quot;: [
        {
            &quot;businessDocuments&quot;: [
                {
                    &quot;businessDocumentType&quot;: {
                        &quot;id&quot;: &quot;RUC&quot;,
                        &quot;name&quot;: &quot;R.U.C.&quot;
                    },
                    &quot;documentNumber&quot;: &quot;20978633995&quot;
                }
            ],
            &quot;id&quot;: &quot;77780583&quot;,
            &quot;formation&quot;: {
                &quot;date&quot;: &quot;1980-10-14&quot;,
                &quot;country&quot;: {
                    &quot;id&quot;: &quot;PER&quot;,
                    &quot;name&quot;: &quot;PERU&quot;
                },
                &quot;businessType&quot;: {}
            },
            &quot;membershipDate&quot;: &quot;2007-08-14&quot;,
            &quot;legalName&quot;: &quot;HIPERTEHUELCHE&quot;,
            &quot;businessGroup&quot;: {
                &quot;id&quot;: &quot;M02&quot;,
                &quot;name&quot;: &quot;PERS.JURID.COMERCIA.&quot;
            },
            &quot;bank&quot;: {
                &quot;branch&quot;: {
                    &quot;id&quot;: &quot;0102&quot;,
                    &quot;name&quot;: &quot;OF.CALLAO&quot;
                }
            },
            &quot;employeesNumber&quot;: 0,
            &quot;annualSales&quot;: {
                &quot;amount&quot;: 0,
                &quot;currency&quot;: &quot;PEN&quot;
            },
            &quot;economicActivity&quot;: {
                &quot;id&quot;: &quot;00000000112&quot;,
                &quot;name&quot;: &quot;CULT.HORTALIZAS Y LEGUMBRES&quot;
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">/v0/businesses?identityDocument.documentType.id=#documentType#&amp;identityDocument.documentNumber=#documentNumber#</value>
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
