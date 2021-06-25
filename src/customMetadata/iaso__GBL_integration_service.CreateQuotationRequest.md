<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CreateQuotationRequest</label>
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
        <value xsi:type="xsd:string">CreateQuotationRequest</value>
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
        <value xsi:type="xsd:string">POST</value>
    </values>
    <values>
        <field>iaso__IsCacheable__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">{
  &quot;quotations&quot;:[{  
		&quot;rate&quot;:{
			&quot;id&quot;: &quot;#calculationRatesId#&quot;
		},
		&quot;analyzeRate&quot;:{
			&quot;id&quot;: &quot;#analizeRateId#&quot;
		},
		&quot;comment&quot;: &quot;#requestComment#&quot;,
		&quot;interestRates&quot;: {
			&quot;effectiveRates&quot;: [{
				&quot;id&quot;: &quot;REQUESTED_TEA&quot;,
				&quot;percentage&quot;: #proposedAPRpercent#
			}]
		}
		
    }]  
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
        &quot;id&quot;: &quot;1468400&quot;,
        &quot;status&quot;: {
            &quot;id&quot;: &quot;OPEN&quot;,
            &quot;name&quot;: &quot;ABIERTO&quot;
        },
        &quot;quotations&quot;: [
            {
                &quot;status&quot;: {
                    &quot;id&quot;: &quot;REQUESTED&quot;,
                    &quot;name&quot;: &quot;SOLICITADA&quot;
                },
                &quot;id&quot;: &quot;1464550&quot;,
                &quot;version&quot;: &quot;1&quot;,
                &quot;businessAgents&quot;: [
                    {
                        &quot;id&quot;: &quot;P012677&quot;,
                        &quot;firstName&quot;: &quot;IRMA BEATRIZ&quot;,
                        &quot;lastName&quot;: &quot;COLLANTES&quot;,
                        &quot;secondLastName&quot;: &quot;BOHORQUEZ&quot;,
                        &quot;workTeam&quot;: {
                            &quot;id&quot;: &quot;ANA_PRE_BEC&quot;,
                            &quot;name&quot;: &quot;Analista de Precios BEC&quot;
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
        ]
    }
}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:nil="true"/>
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
