<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>AP Acciones Comerciales - Clientes PC</label>
    <protected>false</protected>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;TIPO DE ACCIÓN&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_comm_plan_event_type_name__c&quot;,
            &quot;type&quot;: &quot;picklist&quot;
        },
        {
            &quot;label&quot;: &quot;FECHA ESTIMADA&quot;,
            &quot;fieldName&quot;: &quot;acpl__gf_event_date__c&quot;,
            &quot;type&quot;: &quot;Date&quot;
        },
        {
            &quot;label&quot;: &quot;COMENTARIOS&quot;,
            &quot;fieldName&quot;: &quot;Comments__c&quot;,
            &quot;type&quot;: &quot;textArea&quot;
        },
        {
            &quot;type&quot;: &quot;action&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowActions&quot;: [
                    {
                        &quot;name&quot;: &quot;view&quot;,
                        &quot;objectApiName&quot;: &quot;acpl__Commercial_Plan_Event__c&quot;,
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Ver detalle&quot;,
                            &quot;en-US&quot;: &quot;View detail&quot;
                        },
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Detalle de la acción&quot;,
                            &quot;en-US&quot;: &quot;Commercial action detail&quot;
                        }
                    },
                    {
                        &quot;name&quot;: &quot;update&quot;,
                        &quot;className&quot;: &quot;BE_CreateCommercialPlantEvent_cls&quot;,
                        &quot;objectApiName&quot;: &quot;acpl__Commercial_Plan_Event__c&quot;,
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Editar acción&quot;,
                            &quot;en-US&quot;: &quot;Edit action&quot;
                        },
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Editar acción&quot;,
                            &quot;en-US&quot;: &quot;Edit action&quot;
                        },
                        &quot;fields&quot;: [
                            {
                                &quot;fieldName&quot;: &quot;acpl__gf_comm_plan_event_type_name__c&quot;,
                                &quot;required&quot;: &quot;true&quot;
                            },
                            {
                                &quot;fieldName&quot;: &quot;acpl__gf_event_date__c&quot;,
                                &quot;required&quot;: &quot;true&quot;
                            },
                            {
                                &quot;fieldName&quot;: &quot;Comments__c&quot;
                            },
                {
                    &quot;fieldName&quot;: &quot;Asiggned_User__c&quot;
                },
                            {
                                &quot;fieldName&quot;: &quot;acpl__gf_account_planning_id__c&quot;,
                                &quot;disabled&quot;: true 
                            },
{
                    &quot;fieldName&quot;: &quot;Product__c&quot;
                }
                        ]
                    },
                    {
                        &quot;name&quot;: &quot;delete&quot;,
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Eliminar acción&quot;,
                            &quot;en-US&quot;: &quot;Delete action&quot;
                        },
                        &quot;className&quot;: &quot;&quot;,
                        &quot;objectApiName&quot;: &quot;acpl__Commercial_Plan_Event__c&quot;,
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Eliminar acción comercial&quot;,
                            &quot;en-US&quot;: &quot;Delete commercial  action&quot;
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
        <value xsi:type="xsd:string">toLabel(acpl__gf_comm_plan_event_type_name__c),acpl__gf_event_date__c,Comments__c</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">acpl__gf_account_planning_id__c=:recordId</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;name&quot;: &quot;insert&quot;,
&quot;className&quot;: &quot;BE_CreateCommercialPlantEvent_cls&quot;,
            &quot;objectApiName&quot;: &quot;acpl__Commercial_Plan_Event__c&quot;,
            &quot;defaultValue&quot;: &quot;acpl__gf_account_planning_id__c&quot;,
            &quot;redirect&quot;: false,
            &quot;label&quot;: {
                &quot;es&quot;: &quot;Agregar acción&quot;,
                &quot;en-US&quot;: &quot;Add Action&quot;
            },
            &quot;title&quot;: {
                &quot;es&quot;: &quot;Nueva acción&quot;,
                &quot;en-US&quot;: &quot;New action&quot;
            },
            &quot;fields&quot;: [
                {
                    &quot;fieldName&quot;: &quot;acpl__gf_comm_plan_event_type_name__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;acpl__gf_event_date__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Comments__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Asiggned_User__c&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;acpl__gf_account_planning_id__c&quot;,
                    &quot;value&quot;: &quot;recordId&quot;,
                    &quot;required&quot;: &quot;true&quot;,
                    &quot;disabled&quot;: true
                }
            ]
        }
    ]
}</value>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">6.0</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
    &quot;updateClassName&quot;: &quot;BE_CreateCommercialPlantEvent_cls&quot;,
    &quot;refreshView&quot;: true
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">acpl__Commercial_Plan_Event__c</value>
    </values>
</CustomMetadata>
