<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AP Variable de crecimiento - Resumen</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;FAMILIA DE PRODUCTO&quot;,
            &quot;fieldName&quot;: &quot;bupl__solution_category_id__c&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;PRODUCTO&quot;,
            &quot;fieldName&quot;: &quot;bupl__solution_category_desc__c&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;DETALLE&quot;,
            &quot;fieldName&quot;: &quot;bupl__gf_growth_drvr_prdt_desc__c&quot;,
            &quot;type&quot;: &quot;textArea&quot;
        },
        {
            &quot;type&quot;: &quot;action&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowActions&quot;: [
                    {
                        &quot;name&quot;: &quot;view&quot;,
                        &quot;objectApiName&quot;: &quot;bupl__BP_GrowthDriver__c&quot;,
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Ver detalle&quot;,
                            &quot;en-US&quot;: &quot;View detail&quot;
                        },
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Detalle de la variable de crecimiento&quot;,
                            &quot;en-US&quot;: &quot;Growth driver detail&quot;
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
        <value xsi:type="xsd:string">bupl__solution_category_id__c,bupl__solution_category_desc__c,bupl__gf_growth_drvr_prdt_desc__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">acpl__gf_account_planning_id__c=:recordId order by createdDate</value>
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
        <value xsi:type="xsd:string">bupl__BP_GrowthDriver__c</value>
    </values>
</CustomMetadata>