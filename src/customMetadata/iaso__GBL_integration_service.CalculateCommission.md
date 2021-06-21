<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CalculateCommission</label>
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
        <value xsi:type="xsd:string">CalculateCommission</value>
    </values>
    <values>
        <field>iaso__Description__c</field>
        <value xsi:nil="true"/>
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
        <value xsi:type="xsd:string">{&quot;Content-Type&quot;: &quot;application/json&quot;, &quot;back-clientdocument&quot;:&quot;&quot;}</value>
    </values>
    <values>
        <field>iaso__Http_Method__c</field>
        <value xsi:type="xsd:string">POST</value>
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
        <value xsi:type="xsd:string">{
   &quot;initialAmount&quot;:{
      &quot;amount&quot;:#initialAmountAmount#,
      &quot;currency&quot;:&quot;#initialAmountCurrency#&quot;
   },
   &quot;fixedFee&quot;:{
      &quot;id&quot;:&quot;#fixedFeeId#&quot;
   },
   &quot;term&quot;:{
      &quot;frequency&quot;:{
		&quot;id&quot;:&quot;#termFrequencyId#&quot;
      },
	  &quot;number&quot;:#termNumber#
   },
   &quot;additionalAmount&quot;:{
      &quot;amount&quot;:&quot;&quot;,
      &quot;currency&quot;:&quot;&quot;
   },
   &quot;rates&quot;:{
      &quot;itemizeRates&quot;:[
         {
            &quot;rateUnit&quot;:#ratesItemizeRatesRateUnit#
         }
      ]
   }
   #questions#
}</value>
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
            &quot;id&quot;: &quot;CO278&quot;,
            &quot;name&quot;: &quot;Modificación de contrato&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: true,
            &quot;isRORCApplicable&quot;: false,
            &quot;calculationType&quot;: &quot;PERCENTAGE&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;PERCENTAGE&quot;,
                    &quot;percentage&quot;: 1,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;amount&quot;: 150,
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: false,
            &quot;paymenMethod&quot;: {},
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {}
        },
        {
            &quot;id&quot;: &quot;CO039&quot;,
            &quot;name&quot;: &quot;Gestión de transferencia vehicular&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: false,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;RANGE&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                    &quot;currency&quot;: &quot;USD&quot;,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: false,
            &quot;paymenMethod&quot;: {},
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;range&quot;: {
                &quot;id&quot;: &quot;R001&quot;,
                &quot;intervals&quot;: [
                    {
                        &quot;id&quot;: &quot;3&quot;,
                        &quot;settledValue&quot;: {
                            &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                            &quot;currency&quot;: &quot;USD&quot;,
                            &quot;amount&quot;: 80
                        },
                        &quot;limits&quot;: {
                            &quot;limitType&quot;: &quot;QUANTITY&quot;,
                            &quot;minimumValue&quot;: 4,
                            &quot;maximumValue&quot;: 99999
                        },
                        &quot;calculationType&quot;: &quot;MULTIPLICATION&quot;
                    },
                    {
                        &quot;id&quot;: &quot;2&quot;,
                        &quot;settledValue&quot;: {
                            &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                            &quot;currency&quot;: &quot;USD&quot;,
                            &quot;amount&quot;: 100
                        },
                        &quot;limits&quot;: {
                            &quot;limitType&quot;: &quot;QUANTITY&quot;,
                            &quot;minimumValue&quot;: 2,
                            &quot;maximumValue&quot;: 3
                        },
                        &quot;calculationType&quot;: &quot;MULTIPLICATION&quot;
                    },
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;settledValue&quot;: {
                            &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                            &quot;currency&quot;: &quot;USD&quot;,
                            &quot;amount&quot;: 120
                        },
                        &quot;limits&quot;: {
                            &quot;limitType&quot;: &quot;QUANTITY&quot;,
                            &quot;minimumValue&quot;: 0,
                            &quot;maximumValue&quot;: 1
                        },
                        &quot;calculationType&quot;: &quot;MULTIPLICATION&quot;
                    }
                ]
            },
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU0015&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;QUANTITY&quot;,
                        &quot;description&quot;: &quot;Cuantos vehiculos se estan financiando?&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO035&quot;,
            &quot;name&quot;: &quot;Tramite de inafectación del impuesto vehicular&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: false,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;MULTIPLICATION&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                    &quot;currency&quot;: &quot;USD&quot;,
                    &quot;amount&quot;: 100,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: true,
            &quot;paymenMethod&quot;: {
                &quot;frequency&quot;: {
                    &quot;id&quot;: &quot;YEARLY&quot;
                }
            },
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU004&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;2&quot;,
                        &quot;outputType&quot;: &quot;QUANTITY&quot;,
                        &quot;description&quot;: &quot;Cuantos vehiculos son?&quot;,
                        &quot;parentId&quot;: &quot;1&quot;,
                        &quot;parentOutputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;parentAnswerActivator&quot;: &quot;SI&quot;
                    },
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;El vehiculo a financiar es un Omnibus de servicio público?&quot;,
                        &quot;expectedResponse&quot;: &quot;SI&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO034&quot;,
            &quot;name&quot;: &quot;Tramite y gestión de pago del impuesto vehicular&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: false,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;AMOUNT&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                    &quot;currency&quot;: &quot;PEN&quot;,
                    &quot;amount&quot;: 85,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;PEN&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;currency&quot;: &quot;PEN&quot;
            },
            &quot;isTermIncluded&quot;: true,
            &quot;paymenMethod&quot;: {
                &quot;frequency&quot;: {
                    &quot;id&quot;: &quot;YEARLY&quot;
                }
            },
            &quot;term&quot;: {
                &quot;frequency&quot;: {
                    &quot;id&quot;: &quot;YEARLY&quot;
                },
                &quot;number&quot;: 3
            },
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU003&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;El vehiculo esta afecto al impuesto vehicular?&quot;,
                        &quot;expectedResponse&quot;: &quot;SI&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO028&quot;,
            &quot;name&quot;: &quot;Pago de documentos&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: false,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;MULTIPLICATION&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                    &quot;currency&quot;: &quot;USD&quot;,
                    &quot;amount&quot;: 2.5,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: false,
            &quot;paymenMethod&quot;: {},
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU002&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;2&quot;,
                        &quot;outputType&quot;: &quot;QUANTITY&quot;,
                        &quot;description&quot;: &quot;Cuantos documentos son los excedentes?&quot;,
                        &quot;parentId&quot;: &quot;1&quot;,
                        &quot;parentOutputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;parentAnswerActivator&quot;: &quot;SI&quot;
                    },
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;Con este desembolso se van a pagar mas de 11 documento (facturas, declaraciones únicas de aduanas, documentos de embarque, notas de crédito, entre otros)?&quot;,
                        &quot;expectedResponse&quot;: &quot;SI&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO018&quot;,
            &quot;name&quot;: &quot;Liquidación Anticipada&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: true,
            &quot;isRORCApplicable&quot;: false,
            &quot;calculationType&quot;: &quot;PERCENTAGE&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;PERCENTAGE&quot;,
                    &quot;percentage&quot;: 5,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;amount&quot;: 150,
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: false,
            &quot;paymenMethod&quot;: {},
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU001&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;2&quot;,
                        &quot;outputType&quot;: &quot;AMOUNT&quot;,
                        &quot;description&quot;: &quot;Cuál es el precio de venta sin IGV?&quot;,
                        &quot;parentId&quot;: &quot;1&quot;,
                        &quot;parentOutputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;parentAnswerActivator&quot;: &quot;NO&quot;
                    },
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;Es PNN o PJ (Ventas menores a 150 UIT)?&quot;,
                        &quot;expectedResponse&quot;: &quot;NO&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO012&quot;,
            &quot;name&quot;: &quot;Opción de compra&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: true,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;PERCENTAGE&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;PERCENTAGE&quot;,
                    &quot;percentage&quot;: 1,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: false,
            &quot;paymenMethod&quot;: {},
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU001&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;2&quot;,
                        &quot;outputType&quot;: &quot;AMOUNT&quot;,
                        &quot;description&quot;: &quot;Cuál es el precio de venta sin IGV?&quot;,
                        &quot;parentId&quot;: &quot;1&quot;,
                        &quot;parentOutputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;parentAnswerActivator&quot;: &quot;NO&quot;
                    },
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;Es PNN o PJ (Ventas menores a 150 UIT)?&quot;,
                        &quot;expectedResponse&quot;: &quot;NO&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO004&quot;,
            &quot;name&quot;: &quot;Estructuración&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: true,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;PERCENTAGE&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;PERCENTAGE&quot;,
                    &quot;percentage&quot;: 1,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;amount&quot;: 550,
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: false,
            &quot;paymenMethod&quot;: {},
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU001&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;2&quot;,
                        &quot;outputType&quot;: &quot;AMOUNT&quot;,
                        &quot;description&quot;: &quot;Cuál es el precio de venta sin IGV?&quot;,
                        &quot;parentId&quot;: &quot;1&quot;,
                        &quot;parentOutputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;parentAnswerActivator&quot;: &quot;NO&quot;
                    },
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;Es PNN o PJ (Ventas menores a 150 UIT)?&quot;,
                        &quot;expectedResponse&quot;: &quot;NO&quot;
                    }
                ]
            }
        },
        {
            &quot;id&quot;: &quot;CO044&quot;,
            &quot;name&quot;: &quot;Evaluación de Poliza de seguro endosada&quot;,
            &quot;product&quot;: {
                &quot;id&quot;: &quot;4&quot;,
                &quot;modality&quot;: {
                    &quot;id&quot;: &quot;34&quot;
                }
            },
            &quot;currency&quot;: &quot;USD&quot;,
            &quot;isNegotiable&quot;: false,
            &quot;isRORCApplicable&quot;: true,
            &quot;calculationType&quot;: &quot;AMOUNT&quot;,
            &quot;settledValues&quot;: [
                {
                    &quot;settledValueType&quot;: &quot;AMOUNT&quot;,
                    &quot;currency&quot;: &quot;USD&quot;,
                    &quot;amount&quot;: 63.56,
                    &quot;name&quot;: &quot;SUGGESTED_RATE&quot;
                }
            ],
            &quot;maximumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;minimumValue&quot;: {
                &quot;currency&quot;: &quot;USD&quot;
            },
            &quot;isTermIncluded&quot;: true,
            &quot;paymenMethod&quot;: {
                &quot;frequency&quot;: {
                    &quot;id&quot;: &quot;YEARLY&quot;
                }
            },
            &quot;term&quot;: {},
            &quot;additionalAmount&quot;: {},
            &quot;questionnaire&quot;: {
                &quot;id&quot;: &quot;CU005&quot;,
                &quot;questions&quot;: [
                    {
                        &quot;id&quot;: &quot;1&quot;,
                        &quot;outputType&quot;: &quot;YES_OR_NOT&quot;,
                        &quot;description&quot;: &quot;El cliente endosará la poliza?&quot;,
                        &quot;expectedResponse&quot;: &quot;SI&quot;
                    }
                ]
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
