<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AnalyzeRate</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">AnalyzeRate</value>
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
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">{
    &quot;fees&quot;: #lstFees#,
    &quot;financialIndicators&quot;:[
        {
            &quot;id&quot;: &quot;TACTICAL_FACTOR&quot;,
            &quot;value&quot;: &quot;1&quot;
        }
    ],
    &quot;interestRates&quot;: {
        &quot;effectiveRates&quot;: [
            {
                &quot;id&quot;: &quot;REQUESTED_TEA&quot;,
                &quot;percentage&quot;: &quot;#strRequestedTea#&quot;
            }
        ]
    },
    &quot;liquidityIndicators&quot;: #lstLiquitidyIndicators#,
    &quot;product&quot;: {
        &quot;id&quot;: &quot;#productId#&quot;,
        &quot;requestedAmount&quot;: {
            &quot;amount&quot;: &quot;#strAmount#&quot;,
            &quot;currency&quot;: &quot;#currencyIsoCode#&quot;
        }
    }
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
        &quot;interestRates&quot;: {
            &quot;effectiveRates&quot;: [
                {
                    &quot;id&quot;: &quot;ADJUSTED_TEA&quot;,
                    &quot;percentage&quot;: 0.0418
                }
            ]
        },
        &quot;financialIndicators&quot;: [
            {
                &quot;id&quot;: &quot;RAR&quot;,
                &quot;value&quot;: &quot;0.5041&quot;
            }
        ],
        &quot;liquidityIndicators&quot;: [
            {
                &quot;id&quot;: &quot;ADDITIONAL_LIQUIDITY_MARGIN_BASED_ON_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.005
                }
            },
            {
                &quot;id&quot;: &quot;MINIMUM_LIQUIDITY_MARGIN_BASED_ON_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.005
                }
            },
            {
                &quot;id&quot;: &quot;COMMERCIAL_LIQUIDITY_MARGIN_BASED_ON_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.042
                }
            },
            {
                &quot;id&quot;: &quot;LIQUIDITY_MARGIN_BASED_ON_REQUESTED_TEA&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.1178
                }
            },
            {
                &quot;id&quot;: &quot;BENEFIT_BEFORE_TAX&quot;,
                &quot;detail&quot;: {
                    &quot;percentage&quot;: 0.0888
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
