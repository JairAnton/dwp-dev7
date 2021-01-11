<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Vista Planes de Cuenta para Ejecutivos</label>
    <protected>false</protected>
    <values>
        <field>ClassName__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Columns_Table_Configuration__c</field>
        <value xsi:type="xsd:string">{
    &quot;priority&quot;: [
        {
            &quot;label&quot;: &quot;Cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__Id&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;acpl__participant_id__r.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Segmento&quot;,
            &quot;fieldName&quot;: &quot;segment_desc__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Estado&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_status_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Prioridad&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_priority_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Fecha de vencimiento&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_limit_date__c&quot;,
            &quot;type&quot;: &quot;date-local&quot;,
            &quot;typeAttributes&quot;: {
                &quot;month&quot;: &quot;2-digit&quot;,
                &quot;day&quot;: &quot;2-digit&quot;
            }
        }
    ],
    &quot;validated&quot;: [
        {
            &quot;label&quot;: &quot;Cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__Id&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;acpl__participant_id__r.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Segmento&quot;,
            &quot;fieldName&quot;: &quot;segment_desc__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Estado&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_status_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Prioridad&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_priority_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Fecha de vencimiento&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_limit_date__c&quot;,
            &quot;type&quot;: &quot;date-local&quot;,
            &quot;typeAttributes&quot;: {
                &quot;month&quot;: &quot;2-digit&quot;,
                &quot;day&quot;: &quot;2-digit&quot;
            }
        }
    ],
    &quot;closed_this_month&quot;: [
        {
            &quot;label&quot;: &quot;Cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__Id&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;acpl__participant_id__r.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Segmento&quot;,
            &quot;fieldName&quot;: &quot;segment_desc__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Estado&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_status_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Prioridad&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_priority_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Fecha de vencimiento&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_limit_date__c&quot;,
            &quot;type&quot;: &quot;date-local&quot;,
            &quot;typeAttributes&quot;: {
                &quot;month&quot;: &quot;2-digit&quot;,
                &quot;day&quot;: &quot;2-digit&quot;
            }
        }
    ],
    &quot;closed_next_month&quot;: [
        {
            &quot;label&quot;: &quot;Cliente&quot;,
            &quot;fieldName&quot;: &quot;URL__Id&quot;,
            &quot;type&quot;: &quot;url&quot;,
            &quot;typeAttributes&quot;: {
                &quot;label&quot;: {
                    &quot;fieldName&quot;: &quot;acpl__participant_id__r.Name&quot;
                },
                &quot;target&quot;: &quot;_self&quot;
            },
            &quot;sortable&quot;: true
        },
        {
            &quot;label&quot;: &quot;Segmento&quot;,
            &quot;fieldName&quot;: &quot;segment_desc__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Estado&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_status_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Prioridad&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_priority_type_name__c&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Fecha de vencimiento&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_ap_limit_date__c&quot;,
            &quot;type&quot;: &quot;date-local&quot;,
            &quot;typeAttributes&quot;: {
                &quot;month&quot;: &quot;2-digit&quot;,
                &quot;day&quot;: &quot;2-digit&quot;
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>Filters__c</field>
        <value xsi:type="xsd:string">[
    {
        &quot;label&quot;: &quot;Por prioridad&quot;,
        &quot;code&quot;: &quot;priority&quot;,
        &quot;developerName&quot;: &quot;Period_by_priority&quot;,
        &quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
        &quot;queryFields&quot;: &quot;acpl__participant_id__r.Name, segment_desc__c, toLabel(acpl__gf_ap_status_type_name__c), toLabel(acpl__gf_ap_priority_type_name__c), acpl__gf_ap_limit_date__c&quot;,
        &quot;queryFilters&quot;: &quot;RecordType.developerName = @@Account_Planning@@ AND acpl__gf_ap_substatus_type_name__c NOT IN (@@Expired@@) AND acpl__gf_ap_launch_name__c = @@Period by priority@@ ORDER BY Name&quot;,
        &quot;defaultFilter&quot;: true
    },
    {
        &quot;label&quot;: &quot;Todos los planes validados&quot;,
        &quot;code&quot;: &quot;validated&quot;,
        &quot;developerName&quot;: &quot;Account_Planning_validated&quot;,
        &quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
        &quot;queryFields&quot;: &quot;acpl__participant_id__r.Name, segment_desc__c, toLabel(acpl__gf_ap_status_type_name__c), toLabel(acpl__gf_ap_priority_type_name__c), acpl__gf_ap_limit_date__c&quot;,
        &quot;queryFilters&quot;: &quot;RecordType.developerName = @@Account_Planning@@ AND acpl__gf_ap_status_type_name__c = @@Validated@@ AND acpl__gf_ap_substatus_type_name__c = @@In place@@ ORDER BY Name&quot;,
        &quot;defaultFilter&quot;: false
    },
    {
        &quot;label&quot;: &quot;Planes que cierran este mes&quot;,
        &quot;code&quot;: &quot;closed_this_month&quot;,
        &quot;developerName&quot;: &quot;Account_Planning_closed_this_month&quot;,
        &quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
        &quot;queryFields&quot;: &quot;acpl__participant_id__r.Name, segment_desc__c, toLabel(acpl__gf_ap_status_type_name__c), toLabel(acpl__gf_ap_priority_type_name__c), acpl__gf_ap_limit_date__c&quot;,
        &quot;queryFilters&quot;: &quot;RecordType.developerName = @@Account_Planning@@ AND acpl__gf_ap_limit_date__c = THIS_MONTH AND acpl__gf_ap_substatus_type_name__c NOT IN(@@Expired@@, @@In place@@) ORDER BY Name&quot;,
        &quot;defaultFilter&quot;: false
    },
    {
        &quot;label&quot;: &quot;Planes que cierran el próximo mes&quot;,
        &quot;code&quot;: &quot;closed_next_month&quot;,
        &quot;developerName&quot;: &quot;Account_Planning_closed_next_month&quot;,
        &quot;sobjectType&quot;: &quot;acpl__Account_Planning__c&quot;,
        &quot;queryFields&quot;: &quot;acpl__participant_id__r.Name, segment_desc__c, toLabel(acpl__gf_ap_status_type_name__c), toLabel(acpl__gf_ap_priority_type_name__c), acpl__gf_ap_limit_date__c&quot;,
        &quot;queryFilters&quot;: &quot;RecordType.developerName = @@Account_Planning@@ AND acpl__gf_ap_limit_date__c = NEXT_MONTH AND acpl__gf_ap_substatus_type_name__c NOT IN(@@Expired@@, @@In place@@) ORDER BY Name&quot;,
        &quot;defaultFilter&quot;: false
    }
]</value>
    </values>
    <values>
        <field>Replace_Fields_Configuration__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
