<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Calce - Nuevas Oportunidades Lectura</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;CLIENTE&quot;,
            &quot;fieldName&quot;: &quot;account_id__c&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;account_id__r&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;PRODUCTO&quot;,
            &quot;fieldName&quot;: &quot;product_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;N. OPORTUNIDAD&quot;,
            &quot;fieldName&quot;: &quot;opportunity_id__c&quot;,
            &quot;type&quot;: &quot;customurl&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                },
                &quot;isCustom&quot;: true,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;fieldName&quot;: &quot;opportunity_id__c&quot;
            }
        },
        {
            &quot;label&quot;: &quot;F. DE CIERRE&quot;,
            &quot;fieldName&quot;: &quot;close_date__c&quot;,
            &quot;type&quot;: &quot;date-local&quot;
        },
        {
            &quot;label&quot;: &quot;IMPORTE&quot;,
            &quot;fieldName&quot;: &quot;amount_cancelled__c&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;typeAttributes&quot;: {
                &quot;minimumFractionDigits&quot;: &quot;2&quot;,
                &quot;maximumFractionDigits&quot;: &quot;2&quot;,
                &quot;currencyCode&quot;: {
                    &quot;fieldName&quot;: &quot;CurrencyIsoCode&quot;
                },
                &quot;currencyDisplayAs&quot;: &quot;code&quot;
            }
        },
        {
            &quot;label&quot;: &quot;ETAPA&quot;,
            &quot;fieldName&quot;: &quot;opportunity_stage_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">ID,Name,account_id__r.Name,product_name__c,close_date__c,calce_id__c,account_contract_id__c,opportunity_id__c,amount__c,amount_cancelled__c,opportunity_stage_name__c,return__c,extension__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">calce_id__c=:recordId AND sub_type__c=@@02@@</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Calce_Details__c</value>
    </values>
</CustomMetadata>
