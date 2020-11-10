<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Garantías de Otros</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;Tipo&quot;,
            &quot;fieldName&quot;: &quot;guarantee_type__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;N° Garantía&quot;,
            &quot;fieldName&quot;: &quot;Name&quot;,
            &quot;type&quot;: &quot;custombutton&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: &quot;true&quot;,
                &quot;fieldName&quot;: {
                    &quot;fieldName&quot;: &quot;Id&quot;
                },
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Name&quot;
                },
                &quot;component&quot;: &quot;c:bE_DynamicModalRecordForm_Lwc&quot;,
                &quot;params&quot;: {
                    &quot;idRecord&quot;: &quot;Id&quot;,
                    &quot;metaDataConfig&quot;: &quot;Guarantee_Detailes_Otros&quot;
                },
                &quot;iconName&quot;: &quot;utility:search&quot;,
                &quot;iconPosition&quot;: &quot;right&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Importe&quot;,
            &quot;fieldName&quot;: &quot;guaranteed_amount__c&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;typeAttributes&quot;: {
                &quot;currencyCode&quot;: {
                    &quot;fieldName&quot;: &quot;CurrencyIsoCode&quot;
                },
                &quot;currencyDisplayAs&quot;: &quot;code&quot;,
                &quot;minimumFractionDigits&quot;: 2,
                &quot;maximumFractionDigits&quot;: 2
            },
            &quot;cellAttributes&quot;: {
                &quot;alignment&quot;: &quot;right&quot;
            }
        },
        {
            &quot;label&quot;: &quot;Situación&quot;,
            &quot;fieldName&quot;: &quot;guarantee_status_type__c&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;F.Formalización&quot;,
            &quot;fieldName&quot;: &quot;guarantee_release_date__c&quot;,
            &quot;type&quot;: &quot;date&quot;
        },
        {
            &quot;label&quot;: &quot;Clase&quot;,
            &quot;fieldName&quot;: &quot;guarantee_class__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">toLabel(guarantee_type__c),Name,guaranteed_amount__c,toLabel(guarantee_status_type__c),guarantee_release_date__c,toLabel(guarantee_class__c)</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">account_id__c=:recordId AND guarantee_type__c IN (@@130@@,@@220@@,@@310@@,@@315@@) ORDER BY guarantee_release_date__c DESC NULLS LAST, guarantee_status_type__c ASC</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">Guarantee__c</value>
    </values>
</CustomMetadata>
