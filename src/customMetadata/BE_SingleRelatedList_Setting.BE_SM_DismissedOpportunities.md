<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_SM_DismissedOpportunities</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;CLIENTE&quot;,
            &quot;fieldName&quot;: &quot;AccountId&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;Account&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;NOMBRE&quot;,
            &quot;fieldName&quot;: &quot;Id&quot;,
            &quot;type&quot;: &quot;customurl&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                },
                &quot;isCustom&quot;: true,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;fieldName&quot;: &quot;Id&quot;
            }
        },
        {
            &quot;label&quot;: &quot;ETAPA&quot;,
            &quot;fieldName&quot;: &quot;StageName&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;MONTO&quot;,
            &quot;fieldName&quot;: &quot;Amount&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;typeAttributes&quot;: {
                &quot;minimumFractionDigits&quot;: &quot;2&quot;,
                &quot;maximumFractionDigits&quot;: &quot;2&quot;,
                &quot;currencyCode&quot;: {
                    &quot;fieldName&quot;: &quot;CurrencyIsoCode&quot;
                }
            },
            &quot;cellAttributes&quot;: {
                &quot;alignment&quot;: &quot;right&quot;
            }
        },
        {
            &quot;label&quot;: &quot;FECHA DE CIERRE&quot;,
            &quot;fieldName&quot;: &quot;CloseDate&quot;,
            &quot;type&quot;: &quot;date-local&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">Account.Name, Name,toLabel(StageName),Amount,CloseDate</value>
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
&quot;readClassName&quot;: &quot;BE_SM_Opportunity_Dismissed_cls&quot;
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Opportunity</value>
    </values>
</CustomMetadata>
