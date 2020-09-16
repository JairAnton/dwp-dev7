<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Demo Opportunity DynamicTable</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Columns_Table_Configuration__c</field>
        <value xsi:type="xsd:string">{
    &quot;model_1&quot;: [
        {
            &quot;label&quot;: &quot;Oportunidad&quot;,
            &quot;fieldName&quot;: &quot;URL__Id&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__AccountId&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Account.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Gestor del cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__Account.OwnerId&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Account.Owner.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Monto&quot;,
            &quot;fieldName&quot;: &quot;Amount&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;typeAttributes&quot;: {
                &quot;formatStyle&quot;:&quot;currency&quot;,
&quot;currencyDisplayAs&quot; : &quot;code&quot;
            }
        }
    ],
    &quot;model_2&quot;: [
        {
            &quot;label&quot;: &quot;Oportunidad&quot;,
            &quot;fieldName&quot;: &quot;URL__Id&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__AccountId&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Account.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Gestor del cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__Account.OwnerId&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;Account.Owner.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Monto&quot;,
            &quot;fieldName&quot;: &quot;Amount&quot;,
            &quot;type&quot;: &quot;currency&quot;,
            &quot;typeAttributes&quot;: {
                &quot;formatStyle&quot;: &quot;currency&quot;,
&quot;currencyDisplayAs&quot; : &quot;code&quot;
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>Filters__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;label&quot;: &quot;Todas las oportunidades&quot;,
        &quot;code&quot;: &quot;model_1&quot;,
        &quot;developerName&quot;: &quot;AllOpportunities&quot;,
        &quot;sobjectType&quot;: &quot;Opportunity&quot;,
        &quot;queryFields&quot;: &quot;Name, AccountId, Account.Name,  Account.OwnerId, Account.Owner.Name, Amount&quot;,
        &quot;queryFilters&quot;: &quot;&quot;,
        &quot;defaultFilter&quot;: true
    },
    {
        &quot;label&quot;: &quot;Mis oportunidades&quot;,
        &quot;code&quot;: &quot;model_2&quot;,
        &quot;developerName&quot;: &quot;MyOpportunities&quot;,
        &quot;sobjectType&quot;: &quot;Opportunity&quot;,
        &quot;queryFields&quot;: &quot;Name, AccountId, Account.Name, Account.OwnerId, Account.Owner.Name, Amount&quot;,
        &quot;queryFilters&quot;: &quot;OwnerId =: USER_ID&quot;,
        &quot;defaultFilter&quot;: false
    }
]</value>
    </values>
    <values>
        <field>Replace_Fields_Configuration__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
