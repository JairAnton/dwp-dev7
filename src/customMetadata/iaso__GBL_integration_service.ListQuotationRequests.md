<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ListQuotationRequests</label>
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
        <value xsi:type="xsd:string">ListQuotationRequests</value>
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
            &quot;id&quot;: &quot;283869&quot;,
            &quot;status&quot;: {
                &quot;id&quot;: &quot;OPEN&quot;,
                &quot;name&quot;: &quot;ABIERTO&quot;
            },
            &quot;participant&quot;: {
                &quot;id&quot;: &quot;26835866&quot;,
                &quot;identityDocuments&quot;: [
                    {
                        &quot;documentType&quot;: {
                            &quot;id&quot;: &quot;RUC&quot;
                        },
                        &quot;documentNumber&quot;: &quot;20601539722&quot;
                    }
                ],
                &quot;segment&quot;: {
                    &quot;id&quot;: &quot;EMPRESA PEQUEÑA&quot;,
                    &quot;name&quot;: &quot;EMPRESA PEQUEÑA&quot;
                },
                &quot;detail&quot;: {
                    &quot;firstName&quot;: &quot;CONSORCIO CHUQUIMAL&quot;,
                    &quot;lastName&quot;: &quot;&quot;,
                    &quot;bankingData&quot;: {
                        &quot;adjustedBanking&quot;: {
                            &quot;id&quot;: &quot;BEC&quot;,
                            &quot;name&quot;: &quot;BEC&quot;
                        }
                    }
                }
            },
            &quot;quotations&quot;: [
                {
                    &quot;status&quot;: {
                        &quot;id&quot;: &quot;APPROVED&quot;,
                        &quot;name&quot;: &quot;APROBADA&quot;
                    },
                    &quot;approvalDate&quot;: &quot;2020-12-07T10:51:25.906-0500&quot;,
                    &quot;validityDate&quot;: &quot;2020-12-22T15:53:13.538+0000&quot;,
                    &quot;id&quot;: &quot;297869&quot;,
                    &quot;version&quot;: &quot;2&quot;,
                    &quot;interestRates&quot;: {
                        &quot;effectiveRates&quot;: [
                            {
                                &quot;id&quot;: &quot;TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.0978
                            },
                            {
                                &quot;id&quot;: &quot;MINIMUM_TEA&quot;,
                                &quot;percentage&quot;: 0.098
                            },
                            {
                                &quot;id&quot;: &quot;SUGGESTED_TEA&quot;,
                                &quot;percentage&quot;: 0.105
                            },
                            {
                                &quot;id&quot;: &quot;MINIMUM_TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.098
                            },
                            {
                                &quot;id&quot;: &quot;SUGGESTED_TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.105
                            },
                            {
                                &quot;id&quot;: &quot;FINAL_TEA&quot;,
                                &quot;percentage&quot;: 0.087
                            },
                            {
                                &quot;id&quot;: &quot;APPROVED_TEA&quot;,
                                &quot;percentage&quot;: 0.087
                            },
                            {
                                &quot;id&quot;: &quot;REQUESTED_TEA&quot;,
                                &quot;percentage&quot;: 0.085
                            },
                            {
                                &quot;id&quot;: &quot;ADJUSTED_MODEL_TEA&quot;,
                                &quot;percentage&quot;: 0.0002
                            },
                            {
                                &quot;id&quot;: &quot;REQUESTED_ADJUSTED_TEA&quot;,
                                &quot;percentage&quot;: 0
                            },
                            {
                                &quot;id&quot;: &quot;APPROVED_ADJUSTED_TEA&quot;,
                                &quot;percentage&quot;: 0
                            }
                        ]
                    },
                    &quot;comment&quot;: &quot;Petición de evaluación de cotización desde DWP&quot;,
                    &quot;product&quot;: {
                        &quot;id&quot;: &quot;11&quot;,
                        &quot;requestedAmount&quot;: {
                            &quot;amount&quot;: 250000,
                            &quot;currency&quot;: &quot;PEN&quot;
                        },
                        &quot;name&quot;: &quot;Préstamo Comercial (CP)&quot;,
                        &quot;contractingModality&quot;: {
                            &quot;id&quot;: &quot;7&quot;
                        },
                        &quot;term&quot;: {
                            &quot;frequency&quot;: {
                                &quot;id&quot;: &quot;DAILY&quot;,
                                &quot;name&quot;: &quot;DIA&quot;
                            },
                            &quot;termNumber&quot;: 90
                        }
                    },
                    &quot;businessAgents&quot;: [
                        {
                            &quot;id&quot;: &quot;P023210&quot;,
                            &quot;firstName&quot;: &quot;RENZO&quot;,
                            &quot;lastName&quot;: &quot;LOLI&quot;,
                            &quot;secondLastName&quot;: &quot;OLIVA&quot;,
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
                        },
                        {
                            &quot;id&quot;: &quot;P023210&quot;,
                            &quot;firstName&quot;: &quot;RENZO&quot;,
                            &quot;lastName&quot;: &quot;LOLI&quot;,
                            &quot;secondLastName&quot;: &quot;OLIVA&quot;,
                            &quot;classification&quot;: {
                                &quot;involvements&quot;: [
                                    {
                                        &quot;involvementType&quot;: {
                                            &quot;id&quot;: &quot;REGISTERED&quot;,
                                            &quot;description&quot;: &quot;Usuario que registra la cotización&quot;
                                        }
                                    }
                                ]
                            }
                        },
                        {
                            &quot;id&quot;: &quot;P012677&quot;,
                            &quot;firstName&quot;: &quot;IRMA BEATRIZ&quot;,
                            &quot;lastName&quot;: &quot;COLLANTES&quot;,
                            &quot;secondLastName&quot;: &quot;BOHORQUEZ&quot;,
                            &quot;classification&quot;: {
                                &quot;involvements&quot;: [
                                    {
                                        &quot;involvementType&quot;: {
                                            &quot;id&quot;: &quot;APPROVER&quot;,
                                            &quot;description&quot;: &quot;Usuario que aprobó la cotización&quot;
                                        }
                                    }
                                ]
                            }
                        }
                    ],
                    &quot;bank&quot;: {
                        &quot;branch&quot;: {
                            &quot;id&quot;: &quot;0949&quot;
                        }
                    },
                    &quot;disbursement&quot;: {
                        &quot;status&quot;: {
                            &quot;id&quot;: &quot;PENDING&quot;,
                            &quot;description&quot;: &quot;PENDIENTE&quot;
                        }
                    },
                    &quot;profitabilityIndicators&quot;: [
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_MODEL_TEA&quot;,
                            &quot;percentage&quot;: 0.1915
                        },
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_APPROVED_TEA&quot;,
                            &quot;percentage&quot;: 0.1287
                        },
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA&quot;,
                            &quot;percentage&quot;: 0.1287
                        }
                    ],
                    &quot;fees&quot;: [
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EXPECTED_LOSS&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.018025
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FUNDING_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0342
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FINANCING_COST_STOCKHOLDER&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0164
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EFFICIENCY_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;REGULATORY_CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.1
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;ADDITIONAL_CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0228
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 30700
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;OPPORTUNITY_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.1336
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EFFICIENCY_COST_FACTOR&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;TAX_RATE&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.3
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FUNDING_COST_ADJUSTED&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.03
                            }
                        }
                    ],
                    &quot;creationDate&quot;: &quot;2020-12-07T10:37:55.871-0500&quot;,
                    &quot;lastUpdateDate&quot;: &quot;2020-12-07T15:53:13.490+0000&quot;,
                    &quot;indicators&quot;: [
                        {
                            &quot;id&quot;: &quot;QUOTATION_MIGRATED&quot;,
                            &quot;value&quot;: &quot;0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;SEGMENT_NAME&quot;,
                            &quot;value&quot;: &quot;EMPRESA PEQUEÑA&quot;
                        },
                        {
                            &quot;id&quot;: &quot;SEGMENT_CODE&quot;,
                            &quot;value&quot;: &quot;30400&quot;
                        },
                        {
                            &quot;id&quot;: &quot;ENTAILMENT&quot;,
                            &quot;value&quot;: &quot;No Vinculado&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RATING&quot;,
                            &quot;value&quot;: &quot;&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PRINCIPAL_MANAGER_NAME&quot;,
                            &quot;value&quot;: &quot;GERARDO ANGEL PORTOCARRERO FERNANDEZ DAV&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PRINCIPAL_MANAGER_CODE&quot;,
                            &quot;value&quot;: &quot;001855&quot;
                        },
                        {
                            &quot;id&quot;: &quot;BUSINESS_LINE_CODE&quot;,
                            &quot;value&quot;: &quot;45207&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_VARIATION&quot;,
                            &quot;value&quot;: &quot;-4.512537&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_STOCK_PERIOD&quot;,
                            &quot;value&quot;: &quot;2019-12-01 00:00:00.0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_PERIOD&quot;,
                            &quot;value&quot;: &quot;2019-12-01 00:00:00.0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-4043.818149&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-5727.580006&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-7055.734225&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                            &quot;value&quot;: &quot;4.7&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                            &quot;value&quot;: &quot;4.7&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_THRESHOLD_CLIENT&quot;,
                            &quot;value&quot;: &quot;0.078&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_THRESHOLD_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.094&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_POST&quot;,
                            &quot;value&quot;: &quot;0.187463&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_POST&quot;,
                            &quot;value&quot;: &quot;0.336586&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.141466&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.256075&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD_RORC&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD_RAROEC_OPERATION&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        }
                    ]
                }
            ],
            &quot;lastUpdateDate&quot;: &quot;2020-12-07T15:53:13.480+0000&quot;
        },
        {
            &quot;id&quot;: &quot;290800&quot;,
            &quot;status&quot;: {
                &quot;id&quot;: &quot;OPEN&quot;,
                &quot;name&quot;: &quot;ABIERTO&quot;
            },
            &quot;participant&quot;: {
                &quot;id&quot;: &quot;26835866&quot;,
                &quot;identityDocuments&quot;: [
                    {
                        &quot;documentType&quot;: {
                            &quot;id&quot;: &quot;RUC&quot;
                        },
                        &quot;documentNumber&quot;: &quot;20601539722&quot;
                    }
                ],
                &quot;segment&quot;: {
                    &quot;id&quot;: &quot;EMPRESA PEQUEÑA&quot;,
                    &quot;name&quot;: &quot;EMPRESA PEQUEÑA&quot;
                },
                &quot;detail&quot;: {
                    &quot;firstName&quot;: &quot;CONSORCIO CHUQUIMAL&quot;,
                    &quot;lastName&quot;: &quot;&quot;,
                    &quot;bankingData&quot;: {
                        &quot;adjustedBanking&quot;: {
                            &quot;id&quot;: &quot;BEC&quot;,
                            &quot;name&quot;: &quot;BEC&quot;
                        }
                    }
                }
            },
            &quot;quotations&quot;: [
                {
                    &quot;status&quot;: {
                        &quot;id&quot;: &quot;TARIFY&quot;,
                        &quot;name&quot;: &quot;TARIFARIO&quot;
                    },
                    &quot;approvalDate&quot;: &quot;2020-12-11T11:18:21.865-0500&quot;,
                    &quot;validityDate&quot;: &quot;2020-12-26T16:18:21.817+0000&quot;,
                    &quot;id&quot;: &quot;303800&quot;,
                    &quot;version&quot;: &quot;1&quot;,
                    &quot;interestRates&quot;: {
                        &quot;effectiveRates&quot;: [
                            {
                                &quot;id&quot;: &quot;TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.0537
                            },
                            {
                                &quot;id&quot;: &quot;MINIMUM_TEA&quot;,
                                &quot;percentage&quot;: 0.054
                            },
                            {
                                &quot;id&quot;: &quot;SUGGESTED_TEA&quot;,
                                &quot;percentage&quot;: 0.065
                            },
                            {
                                &quot;id&quot;: &quot;MINIMUM_TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.054
                            },
                            {
                                &quot;id&quot;: &quot;SUGGESTED_TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.065
                            },
                            {
                                &quot;id&quot;: &quot;FINAL_TEA&quot;,
                                &quot;percentage&quot;: 0.065
                            },
                            {
                                &quot;id&quot;: &quot;APPROVED_TEA&quot;,
                                &quot;percentage&quot;: 0.065
                            },
                            {
                                &quot;id&quot;: &quot;REQUESTED_TEA&quot;,
                                &quot;percentage&quot;: 0.065
                            },
                            {
                                &quot;id&quot;: &quot;ADJUSTED_MODEL_TEA&quot;,
                                &quot;percentage&quot;: 0.0003
                            },
                            {
                                &quot;id&quot;: &quot;REQUESTED_ADJUSTED_TEA&quot;,
                                &quot;percentage&quot;: 0.0113
                            },
                            {
                                &quot;id&quot;: &quot;APPROVED_ADJUSTED_TEA&quot;,
                                &quot;percentage&quot;: 0.0113
                            }
                        ]
                    },
                    &quot;comment&quot;: &quot;Petición de desembolso desde DWP&quot;,
                    &quot;product&quot;: {
                        &quot;id&quot;: &quot;9&quot;,
                        &quot;requestedAmount&quot;: {
                            &quot;amount&quot;: 156000,
                            &quot;currency&quot;: &quot;USD&quot;
                        },
                        &quot;name&quot;: &quot;Préstamo Comercial (LP)&quot;,
                        &quot;contractingModality&quot;: {
                            &quot;id&quot;: &quot;108&quot;
                        },
                        &quot;term&quot;: {
                            &quot;frequency&quot;: {
                                &quot;id&quot;: &quot;MONTHLY&quot;,
                                &quot;name&quot;: &quot;MES&quot;
                            },
                            &quot;termNumber&quot;: 50
                        }
                    },
                    &quot;businessAgents&quot;: [
                        {
                            &quot;id&quot;: &quot;P023210&quot;,
                            &quot;firstName&quot;: &quot;RENZO&quot;,
                            &quot;lastName&quot;: &quot;LOLI&quot;,
                            &quot;secondLastName&quot;: &quot;OLIVA&quot;,
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
                        },
                        {
                            &quot;id&quot;: &quot;P023210&quot;,
                            &quot;firstName&quot;: &quot;RENZO&quot;,
                            &quot;lastName&quot;: &quot;LOLI&quot;,
                            &quot;secondLastName&quot;: &quot;OLIVA&quot;,
                            &quot;classification&quot;: {
                                &quot;involvements&quot;: [
                                    {
                                        &quot;involvementType&quot;: {
                                            &quot;id&quot;: &quot;REGISTERED&quot;,
                                            &quot;description&quot;: &quot;Usuario que registra la cotización&quot;
                                        }
                                    }
                                ]
                            }
                        },
                        {
                            &quot;id&quot;: &quot;P023210&quot;,
                            &quot;firstName&quot;: &quot;RENZO&quot;,
                            &quot;lastName&quot;: &quot;LOLI&quot;,
                            &quot;secondLastName&quot;: &quot;OLIVA&quot;,
                            &quot;classification&quot;: {
                                &quot;involvements&quot;: [
                                    {
                                        &quot;involvementType&quot;: {
                                            &quot;id&quot;: &quot;APPROVER&quot;,
                                            &quot;description&quot;: &quot;Usuario que aprobó la cotización&quot;
                                        }
                                    }
                                ]
                            }
                        }
                    ],
                    &quot;bank&quot;: {
                        &quot;branch&quot;: {
                            &quot;id&quot;: &quot;0949&quot;
                        }
                    },
                    &quot;disbursement&quot;: {
                        &quot;status&quot;: {
                            &quot;id&quot;: &quot;DISBURSED&quot;,
                            &quot;description&quot;: &quot;DESEMBOLSADO&quot;
                        }
                    },
                    &quot;profitabilityIndicators&quot;: [
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_MODEL_TEA&quot;,
                            &quot;percentage&quot;: 0.1049
                        },
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_APPROVED_TEA&quot;,
                            &quot;percentage&quot;: 0.1678
                        },
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA&quot;,
                            &quot;percentage&quot;: 0.1678
                        }
                    ],
                    &quot;fees&quot;: [
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EXPECTED_LOSS&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.010857
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FUNDING_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0095
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FINANCING_COST_STOCKHOLDER&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0164
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EFFICIENCY_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;REGULATORY_CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.1
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;ADDITIONAL_CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0228
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 19156.8
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;OPPORTUNITY_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.1336
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EFFICIENCY_COST_FACTOR&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;TAX_RATE&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.3
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FUNDING_COST_ADJUSTED&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0083
                            }
                        }
                    ],
                    &quot;creationDate&quot;: &quot;2020-12-11T11:18:21.792-0500&quot;,
                    &quot;lastUpdateDate&quot;: &quot;2020-12-11T16:21:00.453+0000&quot;,
                    &quot;indicators&quot;: [
                        {
                            &quot;id&quot;: &quot;QUOTATION_MIGRATED&quot;,
                            &quot;value&quot;: &quot;0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;SEGMENT_NAME&quot;,
                            &quot;value&quot;: &quot;EMPRESA PEQUEÑA&quot;
                        },
                        {
                            &quot;id&quot;: &quot;SEGMENT_CODE&quot;,
                            &quot;value&quot;: &quot;30400&quot;
                        },
                        {
                            &quot;id&quot;: &quot;ENTAILMENT&quot;,
                            &quot;value&quot;: &quot;No Vinculado&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RATING&quot;,
                            &quot;value&quot;: &quot;&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PRINCIPAL_MANAGER_NAME&quot;,
                            &quot;value&quot;: &quot;GERARDO ANGEL PORTOCARRERO FERNANDEZ DAV&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PRINCIPAL_MANAGER_CODE&quot;,
                            &quot;value&quot;: &quot;001855&quot;
                        },
                        {
                            &quot;id&quot;: &quot;BUSINESS_LINE_CODE&quot;,
                            &quot;value&quot;: &quot;45207&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_VARIATION&quot;,
                            &quot;value&quot;: &quot;-4.049413&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_STOCK_PERIOD&quot;,
                            &quot;value&quot;: &quot;2019-12-01 00:00:00.0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_PERIOD&quot;,
                            &quot;value&quot;: &quot;2019-12-01 00:00:00.0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-6529.384985&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-6049.268528&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-9541.301062&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                            &quot;value&quot;: &quot;4.7&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                            &quot;value&quot;: &quot;4.7&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_THRESHOLD_CLIENT&quot;,
                            &quot;value&quot;: &quot;0.078&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_THRESHOLD_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.094&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_POST&quot;,
                            &quot;value&quot;: &quot;0.650587&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_POST&quot;,
                            &quot;value&quot;: &quot;0.563718&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.486027&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.418858&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD_RORC&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD_RAROEC_OPERATION&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        }
                    ]
                }
            ],
            &quot;lastUpdateDate&quot;: &quot;2020-12-11T16:21:00.358+0000&quot;
        },
        {
            &quot;id&quot;: &quot;280185&quot;,
            &quot;status&quot;: {
                &quot;id&quot;: &quot;OPEN&quot;,
                &quot;name&quot;: &quot;ABIERTO&quot;
            },
            &quot;participant&quot;: {
                &quot;id&quot;: &quot;26835866&quot;,
                &quot;identityDocuments&quot;: [
                    {
                        &quot;documentType&quot;: {
                            &quot;id&quot;: &quot;RUC&quot;
                        },
                        &quot;documentNumber&quot;: &quot;20601539722&quot;
                    }
                ],
                &quot;segment&quot;: {
                    &quot;id&quot;: &quot;EMPRESA PEQUEÑA&quot;,
                    &quot;name&quot;: &quot;EMPRESA PEQUEÑA&quot;
                },
                &quot;detail&quot;: {
                    &quot;firstName&quot;: &quot;EMILIO&quot;,
                    &quot;lastName&quot;: &quot;ESQUEDA&quot;,
                    &quot;bankingData&quot;: {
                        &quot;adjustedBanking&quot;: {
                            &quot;id&quot;: &quot;BEC&quot;,
                            &quot;name&quot;: &quot;BEC&quot;
                        }
                    }
                }
            },
            &quot;quotations&quot;: [
                {
                    &quot;status&quot;: {
                        &quot;id&quot;: &quot;REQUESTED&quot;,
                        &quot;name&quot;: &quot;SOLICITADA&quot;
                    },
                    &quot;approvalDate&quot;: &quot;2020-11-12T17:34:06.124-0500&quot;,
                    &quot;validityDate&quot;: &quot;2021-01-01T15:24:54.370+0000&quot;,
                    &quot;id&quot;: &quot;292885&quot;,
                    &quot;version&quot;: &quot;4&quot;,
                    &quot;interestRates&quot;: {
                        &quot;effectiveRates&quot;: [
                            {
                                &quot;id&quot;: &quot;TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.0682
                            },
                            {
                                &quot;id&quot;: &quot;MINIMUM_TEA&quot;,
                                &quot;percentage&quot;: 0.069
                            },
                            {
                                &quot;id&quot;: &quot;SUGGESTED_TEA&quot;,
                                &quot;percentage&quot;: 0.075
                            },
                            {
                                &quot;id&quot;: &quot;MINIMUM_TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.069
                            },
                            {
                                &quot;id&quot;: &quot;SUGGESTED_TEA_OF_MODEL&quot;,
                                &quot;percentage&quot;: 0.075
                            },
                            {
                                &quot;id&quot;: &quot;REQUESTED_TEA&quot;,
                                &quot;percentage&quot;: 0.065
                            },
                            {
                                &quot;id&quot;: &quot;ADJUSTED_MODEL_TEA&quot;,
                                &quot;percentage&quot;: 0.0008
                            },
                            {
                                &quot;id&quot;: &quot;APPROVED_ADJUSTED_TEA&quot;,
                                &quot;percentage&quot;: 0
                            }
                        ]
                    },
                    &quot;comment&quot;: &quot;Petición de evaluación de cotización desde DWP&quot;,
                    &quot;product&quot;: {
                        &quot;id&quot;: &quot;8&quot;,
                        &quot;requestedAmount&quot;: {
                            &quot;amount&quot;: 5000000,
                            &quot;currency&quot;: &quot;USD&quot;
                        },
                        &quot;name&quot;: &quot;Leasing&quot;,
                        &quot;contractingModality&quot;: {
                            &quot;id&quot;: &quot;101&quot;
                        },
                        &quot;term&quot;: {
                            &quot;frequency&quot;: {
                                &quot;id&quot;: &quot;MONTHLY&quot;,
                                &quot;name&quot;: &quot;MES&quot;
                            },
                            &quot;termNumber&quot;: 36
                        }
                    },
                    &quot;businessAgents&quot;: [
                        {
                            &quot;id&quot;: &quot;P012677&quot;,
                            &quot;firstName&quot;: &quot;IRMA BEATRIZ&quot;,
                            &quot;lastName&quot;: &quot;COLLANTES&quot;,
                            &quot;secondLastName&quot;: &quot;BOHORQUEZ&quot;,
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
                        },
                        {
                            &quot;id&quot;: &quot;P023210&quot;,
                            &quot;firstName&quot;: &quot;RENZO&quot;,
                            &quot;lastName&quot;: &quot;LOLI&quot;,
                            &quot;secondLastName&quot;: &quot;OLIVA&quot;,
                            &quot;classification&quot;: {
                                &quot;involvements&quot;: [
                                    {
                                        &quot;involvementType&quot;: {
                                            &quot;id&quot;: &quot;REGISTERED&quot;,
                                            &quot;description&quot;: &quot;Usuario que registra la cotización&quot;
                                        }
                                    }
                                ]
                            }
                        }
                    ],
                    &quot;bank&quot;: {
                        &quot;branch&quot;: {
                            &quot;id&quot;: &quot;0949&quot;
                        }
                    },
                    &quot;disbursement&quot;: {
                        &quot;status&quot;: {
                            &quot;id&quot;: &quot;PENDING&quot;,
                            &quot;description&quot;: &quot;PENDIENTE&quot;
                        }
                    },
                    &quot;profitabilityIndicators&quot;: [
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_MODEL_TEA&quot;,
                            &quot;percentage&quot;: 0.0553
                        },
                        {
                            &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA&quot;,
                            &quot;percentage&quot;: -0.0247
                        }
                    ],
                    &quot;fees&quot;: [
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EXPECTED_LOSS&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.018025
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FUNDING_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0284
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FINANCING_COST_STOCKHOLDER&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0164
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EFFICIENCY_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;REGULATORY_CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.1
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;ADDITIONAL_CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0228
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;CAPITAL&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 614000
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;OPPORTUNITY_COST&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.1336
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;EFFICIENCY_COST_FACTOR&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;TAX_RATE&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.3
                            }
                        },
                        {
                            &quot;feeType&quot;: {
                                &quot;id&quot;: &quot;FUNDING_COST_ADJUSTED&quot;
                            },
                            &quot;detail&quot;: {
                                &quot;percentage&quot;: 0.0249
                            }
                        }
                    ],
                    &quot;creationDate&quot;: &quot;2020-12-28T10:24:54.206-0500&quot;,
                    &quot;lastUpdateDate&quot;: &quot;2020-12-28T15:24:53.138+0000&quot;,
                    &quot;indicators&quot;: [
                        {
                            &quot;id&quot;: &quot;PAYMENT_METHOD_CODE&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;QUOTATION_MIGRATED&quot;,
                            &quot;value&quot;: &quot;0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;SEGMENT_NAME&quot;,
                            &quot;value&quot;: &quot;EMPRESA PEQUEÑA&quot;
                        },
                        {
                            &quot;id&quot;: &quot;SEGMENT_CODE&quot;,
                            &quot;value&quot;: &quot;30400&quot;
                        },
                        {
                            &quot;id&quot;: &quot;ENTAILMENT&quot;,
                            &quot;value&quot;: &quot;No Vinculado&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RATING&quot;,
                            &quot;value&quot;: &quot;&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PRINCIPAL_MANAGER_NAME&quot;,
                            &quot;value&quot;: &quot;GERARDO ANGEL PORTOCARRERO FERNANDEZ DAV&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PRINCIPAL_MANAGER_CODE&quot;,
                            &quot;value&quot;: &quot;001855&quot;
                        },
                        {
                            &quot;id&quot;: &quot;BUSINESS_LINE_CODE&quot;,
                            &quot;value&quot;: &quot;45207&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_VARIATION&quot;,
                            &quot;value&quot;: &quot;-4.494553&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_STOCK_PERIOD&quot;,
                            &quot;value&quot;: &quot;2019-12-01 00:00:00.0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_PERIOD&quot;,
                            &quot;value&quot;: &quot;2019-12-01 00:00:00.0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;0&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-57902.322708&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-19599.561629&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_LOST_FINANCIAL_MARGIN&quot;,
                            &quot;value&quot;: &quot;-60914.238785&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                            &quot;value&quot;: &quot;4.7&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                            &quot;value&quot;: &quot;4.7&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_THRESHOLD_CLIENT&quot;,
                            &quot;value&quot;: &quot;0.078&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_THRESHOLD_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.094&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_CLIENT_POST&quot;,
                            &quot;value&quot;: &quot;0.205447&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_CLIENT_POST&quot;,
                            &quot;value&quot;: &quot;0.122013&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RORC_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.199312&quot;
                        },
                        {
                            &quot;id&quot;: &quot;RAROEC_OPERATION&quot;,
                            &quot;value&quot;: &quot;0.118304&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD_RORC&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD_RAROEC_OPERATION&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        },
                        {
                            &quot;id&quot;: &quot;PASS_THRESHOLD&quot;,
                            &quot;value&quot;: &quot;1&quot;
                        }
                    ]
                }
            ],
            &quot;lastUpdateDate&quot;: &quot;2020-12-28T15:24:53.128+0000&quot;
        }
    ],
    &quot;pagination&quot;: {
        &quot;links&quot;: {
            &quot;first&quot;: &quot;/quotations/v1/requests?participant.id=26835866&amp;expand=quotations&quot;,
            &quot;last&quot;: &quot;/quotations/v1/requests?participant.id=26835866&amp;expand=quotations&amp;paginationKey=LAST&quot;,
            &quot;next&quot;: &quot;/quotations/v1/requests?participant.id=26835866&amp;expand=quotations&amp;paginationKey=2&amp;pageSize=20&quot;
        },
        &quot;totalPages&quot;: 6,
        &quot;totalElements&quot;: 117,
        &quot;pageSize&quot;: 20
    }
}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">?paginationKey=#paginationKey#&amp;pageSize=#pageSize#&amp;participant.id=#participantId#&amp;expand=quotations</value>
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
