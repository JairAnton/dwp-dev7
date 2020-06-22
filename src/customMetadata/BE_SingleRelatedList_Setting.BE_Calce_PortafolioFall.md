<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Calce - Caida de Cartera</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;Cuenta&quot;,
            &quot;fieldName&quot;: &quot;AccountId&quot;,
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
            &quot;label&quot;: &quot;Contrato&quot;,
            &quot;fieldName&quot;: &quot;contract_number__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Producto&quot;,
            &quot;fieldName&quot;: &quot;Name&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;F.VCTO&quot;,
            &quot;fieldName&quot;: &quot;close_date__c&quot;,
            &quot;type&quot;: &quot;date-local&quot;
        },
        {
            &quot;label&quot;: &quot;M.ORIGINAL&quot;,
            &quot;fieldName&quot;: &quot;amount__c&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;editable&quot;:true,
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
            &quot;label&quot;: &quot;I.CANCELADO&quot;,
            &quot;fieldName&quot;: &quot;amount_cancelled__c&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;editable&quot;: true,
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
            &quot;label&quot;: &quot;PRORROGA&quot;,
            &quot;fieldName&quot;: &quot;extension__c&quot;,
            &quot;type&quot;: &quot;boolean&quot;,
            &quot;editable&quot;: true
        },
        {
            &quot;label&quot;: &quot;RETOMA&quot;,
            &quot;fieldName&quot;: &quot;return__c&quot;,
            &quot;type&quot;: &quot;boolean&quot;,
            &quot;editable&quot;: true
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:nil="true"/>
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
        <value xsi:type="xsd:string">{
    &quot;readClassName&quot;: &quot;BE_CalcePortafolioFall_Ctr&quot;,
    &quot;updateClassName&quot;: &quot;BE_CalcePortafolioFall_Ctr&quot;
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Calce_Details__c</value>
    </values>
</CustomMetadata>
