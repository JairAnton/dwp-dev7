<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ModifyQuotationRequest</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">ModifyQuotationRequest</value>
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
        <value xsi:type="xsd:string">{&quot;Content-Type&quot;: &quot;application/json&quot;, &quot;back-clientdocument&quot;:&quot;#userCode#&quot;,&quot;X-HTTP-Method-Override&quot;: &quot;PATCH&quot;}</value>
    </values>
    <values>
        <field>iaso__Http_Method__c</field>
        <value xsi:type="xsd:string">POST</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">{
 &quot;phase&quot;: {
   &quot;id&quot;: &quot;#phaseId#&quot;
 }
 #jsonStructure#
}</value>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{
    &quot;data&quot;: {
        &quot;status&quot;: {
            &quot;id&quot;: &quot;RECOVERED&quot;,
            &quot;name&quot;: &quot;RECUPERADA&quot;
        },
        &quot;id&quot;: &quot;1469800&quot;,
        &quot;version&quot;: &quot;1&quot;,
        &quot;businessAgents&quot;: [
            {
                &quot;id&quot;: &quot;P012170&quot;,
                &quot;firstName&quot;: &quot;CECILIA&quot;,
                &quot;lastName&quot;: &quot;AGUIRRE&quot;,
                &quot;secondLastName&quot;: &quot;GONZALES&quot;,
                &quot;workTeam&quot;: {
                    &quot;id&quot;: &quot;EJE_BEC&quot;,
                    &quot;name&quot;: &quot;Ejecutivo BEC&quot;
                },
                &quot;classification&quot;: {
                    &quot;involvements&quot;: [
                        {
                            &quot;involvementType&quot;: {
                                &quot;id&quot;: &quot;ASSIGNED&quot;,
                                &quot;description&quot;: &quot;Usuario asignado a la cotización&quot;
                            }
                        }
                    ]
                }
            }
        ],
        &quot;disbursement&quot;: {
            &quot;status&quot;: {
                &quot;id&quot;: &quot;PENDING&quot;,
                &quot;description&quot;: &quot;PENDIENTE&quot;
            }
        }
    }
}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">/#quotationId#/quotations/#operationId#</value>
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
