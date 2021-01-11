<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Lista de Precios Vigentes</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;ID Cotiza&quot;,
            &quot;fieldName&quot;: &quot;price_quote_id__c&quot;,
            &quot;type&quot;: &quot;custombutton&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: &quot;true&quot;,
                &quot;fieldName&quot;: {
                    &quot;fieldName&quot;: &quot;Id&quot;
                },
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;price_quote_id__c&quot;
                },
                &quot;variant&quot;: &quot;base&quot;,
                &quot;component&quot;: &quot;filePreview&quot;,
				&quot;params&quot;:{&quot;fileId&quot; : &quot;Unique_id__c&quot;},
                &quot;iconName&quot;: &quot;utility:search&quot;,
                &quot;iconPosition&quot;: &quot;right&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Monto&quot;,
            &quot;fieldName&quot;: &quot;UnitPrice&quot;,
            &quot;type&quot;: &quot;customcurrency&quot;,
            &quot;typeAttributes&quot;: {
				&quot;isCustom&quot;: &quot;true&quot;,
                &quot;value&quot;: {
                    &quot;fieldName&quot;: &quot;UnitPrice&quot;
                },
                &quot;currencyCode&quot;: {
                    &quot;fieldName&quot;: &quot;CurrencyIsoCode&quot;
                },
                &quot;displayAs&quot;: &quot;code&quot;,
                &quot;maxFractionDigits&quot;: 2
            },
            &quot;cellAttributes&quot;: {
                &quot;alignment&quot;: &quot;right&quot;
            }
        },
        {
            &quot;label&quot;: &quot;Tasa aprobada&quot;,
            &quot;fieldName&quot;: &quot;proposed_apr_per__c&quot;,
            &quot;type&quot;: &quot;custompercent&quot;,
            &quot;typeAttributes&quot;: {
				&quot;isCustom&quot;: &quot;true&quot;,
                &quot;value&quot;: {
                    &quot;fieldName&quot;: &quot;proposed_apr_per__c&quot;
                },
                &quot;maxFractionDigits&quot;: 2
            },
            &quot;cellAttributes&quot;: {
                &quot;alignment&quot;: &quot;right&quot;
            }
        },
        {
            &quot;label&quot;: &quot;Plazo aprobado&quot;,
            &quot;fieldName&quot;: &quot;BE_Periodicity__c&quot;,
            &quot;type&quot;: &quot;text&quot;,
            &quot;cellAttributes&quot;: {
                &quot;alignment&quot;: &quot;right&quot;
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">OpportunityId, Opportunity.Account.Name, Product2.ProductCode, price_quote_id__c, UnitPrice, proposed_apr_per__c, proposed_fee_per__c, BE_Periodicity__c, Description</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">Opportunity.BE_HasApprovedQuote__c = true  AND Opportunity.AccountId =: clientId  AND Product2.ProductCode =: productId AND validityDate__c &gt;= TODAY</value>
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
    &quot;readClassName&quot;: &quot;BE_CurrentPriceList_cls&quot;,
	&quot;showCheckbox&quot;: true,
	&quot;maxRowSelection&quot;: 1
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">OpportunityLineItem</value>
    </values>
</CustomMetadata>
