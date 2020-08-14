<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AnalyzeRate</label>
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
        <value xsi:type="xsd:string">AnalyzeRate</value>
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
    &quot;interestRates&quot;: {
        &quot;effectiveRates&quot;: #ltsEffectiveRates#
    },
    &quot;rate&quot;: {
        &quot;id&quot;: &quot;#calculationRatesId#&quot;
    },
    &quot;fees&quot;: #lstFees#,
    &quot;products&quot;: #lstProducts#
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
        &quot;id&quot;: &quot;227154&quot;,
        &quot;interestRates&quot;: {
            &quot;effectiveRates&quot;: [
                {
                    &quot;id&quot;: &quot;APPROVED_ADJUSTED_TEA&quot;,
                    &quot;percentage&quot;: 0.0167
                }
            ]
        },
        &quot;financialIndicators&quot;: [
            {
                &quot;id&quot;: &quot;PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA&quot;,
                &quot;value&quot;: &quot;0.2042&quot;
            }
        ],
        &quot;liquidityIndicators&quot;: [
            {
                &quot;id&quot;: &quot;LIQUIDITY_MARGIN_RECOVERED&quot;,
                &quot;detail&quot;: {
                    &quot;amount&quot;: 5449630.14,
                    &quot;currency&quot;: &quot;PEN&quot;
                }
            },
            {
                &quot;id&quot;: &quot;ADDITIONAL_SPREAD_OF_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.005
                }
            },
            {
                &quot;id&quot;: &quot;MINIMUM_SPREAD_OF_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.005
                }
            },
            {
                &quot;id&quot;: &quot;COMMERCIAL_SPREAD_OF_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.0034
                }
            },
            {
                &quot;id&quot;: &quot;SPREAD_OF_OPERATION&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.043
                }
            },
            {
                &quot;id&quot;: &quot;BENEFIT_BEFORE_TAX&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.0251
                }
            },
            {
                &quot;id&quot;: &quot;SPREAD_FINANTIAL&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.065
                }
            },
            {
                &quot;id&quot;: &quot;SPREAD_REFERENTIAL&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.005
                }
            }
        ],
        &quot;fees&quot;: [
            {
                &quot;feeType&quot;: {
                    &quot;id&quot;: &quot;RORC_CLIENT&quot;
                },
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.0971838
                }
            },
            {
                &quot;feeType&quot;: {
                    &quot;id&quot;: &quot;RORC_OPERATION&quot;
                },
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.1984
                }
            },
            {
                &quot;feeType&quot;: {
                    &quot;id&quot;: &quot;RORC_UPDATED&quot;
                },
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.1123
                }
            },
            {
                &quot;feeType&quot;: {
                    &quot;id&quot;: &quot;RORC_VARIATION&quot;
                },
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.0151162
                }
            },
            {
                &quot;feeType&quot;: {
                    &quot;id&quot;: &quot;RORC_MODEL&quot;
                },
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.11578
                }
            },
            {
                &quot;feeType&quot;: {
                    &quot;id&quot;: &quot;RORC_APPROVED&quot;
                },
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.1984
                }
            }
        ],
        &quot;products&quot;: [
            {
                &quot;id&quot;: &quot;52&quot;,
                &quot;name&quot;: &quot;INCR. SM VISTA + AHORRO&quot;,
                &quot;committedData&quot;: {
                    &quot;description&quot;: &quot;IMPORTE SOLES&quot;,
                    &quot;unitValue&quot;: {
                        &quot;amount&quot;: 100,
                        &quot;currency&quot;: &quot;PEN&quot;,
                        &quot;unitValueDetailType&quot;: &quot;AMOUNT&quot;
                    },
                    &quot;effectiveTime&quot;: {
                        &quot;unit&quot;: &quot;DAY&quot;,
                        &quot;number&quot;: 30
                    },
                    &quot;classification&quot;: &quot;SUGGESTED&quot;
                }
            },
            {
                &quot;id&quot;: &quot;52&quot;,
                &quot;name&quot;: &quot;INCR. SM VISTA + AHORRO&quot;,
                &quot;committedData&quot;: {
                    &quot;description&quot;: &quot;IMPORTE SOLES&quot;,
                    &quot;unitValue&quot;: {
                        &quot;amount&quot;: 100,
                        &quot;currency&quot;: &quot;PEN&quot;,
                        &quot;unitValueDetailType&quot;: &quot;AMOUNT&quot;
                    },
                    &quot;effectiveTime&quot;: {
                        &quot;unit&quot;: &quot;DAY&quot;,
                        &quot;number&quot;: 60
                    },
                    &quot;classification&quot;: &quot;SUGGESTED&quot;
                }
            },
            {
                &quot;id&quot;: &quot;52&quot;,
                &quot;name&quot;: &quot;INCR. SM VISTA + AHORRO&quot;,
                &quot;committedData&quot;: {
                    &quot;description&quot;: &quot;IMPORTE USD&quot;,
                    &quot;unitValue&quot;: {
                        &quot;amount&quot;: 100,
                        &quot;currency&quot;: &quot;USD&quot;,
                        &quot;unitValueDetailType&quot;: &quot;AMOUNT&quot;
                    },
                    &quot;effectiveTime&quot;: {
                        &quot;unit&quot;: &quot;DAY&quot;,
                        &quot;number&quot;: 30
                    },
                    &quot;classification&quot;: &quot;SUGGESTED&quot;
                }
            },
            {
                &quot;id&quot;: &quot;52&quot;,
                &quot;name&quot;: &quot;INCR. SM VISTA + AHORRO&quot;,
                &quot;committedData&quot;: {
                    &quot;description&quot;: &quot;IMPORTE USD&quot;,
                    &quot;unitValue&quot;: {
                        &quot;amount&quot;: 100,
                        &quot;currency&quot;: &quot;USD&quot;,
                        &quot;unitValueDetailType&quot;: &quot;AMOUNT&quot;
                    },
                    &quot;effectiveTime&quot;: {
                        &quot;unit&quot;: &quot;DAY&quot;,
                        &quot;number&quot;: 60
                    },
                    &quot;classification&quot;: &quot;SUGGESTED&quot;
                }
            },
            {
                &quot;id&quot;: &quot;52&quot;,
                &quot;name&quot;: &quot;INCR. SM VISTA + AHORRO&quot;,
                &quot;committedData&quot;: {
                    &quot;description&quot;: &quot;IMPORTE SOLES&quot;,
                    &quot;unitValue&quot;: {
                        &quot;amount&quot;: 100,
                        &quot;currency&quot;: &quot;PEN&quot;,
                        &quot;unitValueDetailType&quot;: &quot;AMOUNT&quot;
                    },
                    &quot;effectiveTime&quot;: {
                        &quot;unit&quot;: &quot;DAY&quot;,
                        &quot;number&quot;: 30
                    },
                    &quot;classification&quot;: &quot;EVALUATED&quot;
                }
            }
        ],
        &quot;isCoveredMinimunEvaluated&quot;: false,
        &quot;indicators&quot;: [
            {
                &quot;id&quot;: &quot;RECOVERY_MINIMUN_REQUIRED_MSG&quot;,
                &quot;value&quot;: &quot;El compromiso no cubre el minimo requerido USD 5449630.14 (100.00% Variacion)&quot;
            },
            {
                &quot;id&quot;: &quot;MARGIN_FINANCIAL_RECOVERY&quot;,
                &quot;value&quot;: &quot;5449630.14&quot;
            },
            {
                &quot;id&quot;: &quot;CURRENCY_FINANCIAL_RECOVERY&quot;,
                &quot;value&quot;: &quot;PEN&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_CLIENT_VARIATION&quot;,
                &quot;value&quot;: &quot;0.015557&quot;
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
                &quot;value&quot;: &quot;5449630.138628&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                &quot;value&quot;: &quot;553123.513184&quot;
            },
            {
                &quot;id&quot;: &quot;RAROEC_OPERATION_LOST_FINANCIAL_MARGIN&quot;,
                &quot;value&quot;: &quot;438311.563076&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_CLIENT_LOST_FINANCIAL_MARGIN&quot;,
                &quot;value&quot;: &quot;5449630.138628&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                &quot;value&quot;: &quot;0.107978&quot;
            },
            {
                &quot;id&quot;: &quot;RAROEC_CLIENT_STOCK_MONTH_ACTIVE&quot;,
                &quot;value&quot;: &quot;0.283415&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_THRESHOLD_CLIENT&quot;,
                &quot;value&quot;: &quot;1.078&quot;
            },
            {
                &quot;id&quot;: &quot;RAROEC_THRESHOLD_OPERATION&quot;,
                &quot;value&quot;: &quot;2.094&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_CLIENT_POST&quot;,
                &quot;value&quot;: &quot;0.123535&quot;
            },
            {
                &quot;id&quot;: &quot;RAROEC_CLIENT_POST&quot;,
                &quot;value&quot;: &quot;0.328035&quot;
            },
            {
                &quot;id&quot;: &quot;RORC_OPERATION&quot;,
                &quot;value&quot;: &quot;0.242233&quot;
            },
            {
                &quot;id&quot;: &quot;RAROEC_OPERATION&quot;,
                &quot;value&quot;: &quot;0.706212&quot;
            },
            {
                &quot;id&quot;: &quot;PASS_THRESHOLD_RORC&quot;,
                &quot;value&quot;: &quot;0&quot;
            },
            {
                &quot;id&quot;: &quot;PASS_THRESHOLD_RAROEC_OPERATION&quot;,
                &quot;value&quot;: &quot;0&quot;
            },
            {
                &quot;id&quot;: &quot;PASS_THRESHOLD&quot;,
                &quot;value&quot;: &quot;0&quot;
            },
            {
                &quot;id&quot;: &quot;KEY_PRUEBA&quot;,
                &quot;value&quot;: &quot;VALOR_PRUEBA&quot;
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
