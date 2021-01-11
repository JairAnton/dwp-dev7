<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AP Necesidad - Resumen</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;NECESIDAD&quot;,
            &quot;fieldName&quot;: &quot;bupl__gf_bus_pl_sales_goal_name__c&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;DETALLE&quot;,
            &quot;fieldName&quot;: &quot;bupl__gf_bus_pl_sales_goal_desc__c&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
			&quot;label&quot;: &quot;IMPORTE DE LA NECESIDAD&quot;,
			&quot;fieldName&quot;: &quot;bupl__gf_bus_pl_unlk_revenue_amount__c&quot;,
			&quot;type&quot;: &quot;customcurrency&quot;,
			&quot;typeAttributes&quot;: {
			&quot;isCustom&quot;: &quot;true&quot;,
			&quot;value&quot;: {
				&quot;fieldName&quot;: &quot;bupl__gf_bus_pl_unlk_revenue_amount__c&quot;
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
            &quot;label&quot;: &quot;LIMITANTE&quot;,
            &quot;fieldName&quot;: &quot;bupl__gf_bus_pl_cust_lock_name__c&quot;,
            &quot;type&quot;: &quot;textArea&quot;
        },
        {
            &quot;label&quot;: &quot;DETALLE&quot;,
            &quot;fieldName&quot;: &quot;bupl__gf_bus_pl_cust_lock_desc__c&quot;,
            &quot;type&quot;: &quot;textArea&quot;
        },
        {
            &quot;type&quot;: &quot;action&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowActions&quot;: [
                    {
                        &quot;name&quot;: &quot;view&quot;,
                        &quot;objectApiName&quot;: &quot;bupl__BP_Need__c&quot;,
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Ver detalle&quot;,
                            &quot;en-US&quot;: &quot;View detail&quot;
                        },
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Detalle de la necesidad&quot;,
                            &quot;en-US&quot;: &quot;Need Detail&quot;
                        }
                    }
                ]
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>FieldsQuery__c</field>
        <value xsi:type="xsd:string">toLabel(bupl__gf_bus_pl_sales_goal_name__c),bupl__gf_bus_pl_sales_goal_desc__c,bupl__gf_bus_pl_unlk_revenue_amount__c,toLabel(bupl__gf_bus_pl_cust_lock_name__c),bupl__gf_bus_pl_cust_lock_desc__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">acpl__gf_account_planning_id__c=:recordId order by bupl__gf_bus_pl_unlk_revenue_amount__c desc</value>
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
        <value xsi:type="xsd:string">bupl__BP_Need__c</value>
    </values>
</CustomMetadata>
