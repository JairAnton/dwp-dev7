<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CA-CustomTeam</label>
    <protected>false</protected>
    <values>
        <field>BE_SingleRetatedListView__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Columns__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;label&quot;: &quot;&quot;,
            &quot;fieldName&quot;: &quot;UserOrGroupId&quot;,
            &quot;type&quot;: &quot;customlookup&quot;,
            &quot;typeAttributes&quot;: {
                &quot;isCustom&quot;: true,
                &quot;fieldName&quot;: &quot;Id&quot;,
                &quot;label&quot;: &quot;Name&quot;,
                &quot;objectApiName&quot;: &quot;UserOrGroup&quot;,
                &quot;rowData&quot;: {
                    &quot;fieldName&quot;: &quot;rowData&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Accesso&quot;,
            &quot;fieldName&quot;: &quot;AccessLevel&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Tipo&quot;,
            &quot;fieldName&quot;: &quot;RowCause&quot;,
            &quot;type&quot;: &quot;text&quot;
        },
        {
            &quot;label&quot;: &quot;Fecha de modificación&quot;,
            &quot;fieldName&quot;: &quot;LastModifiedDate&quot;,
            &quot;type&quot;: &quot;date-local&quot;
        },
        {
            &quot;type&quot;: &quot;action&quot;,
            &quot;typeAttributes&quot;: {
                &quot;rowActions&quot;: [
                    {
                        &quot;name&quot;: &quot;delete&quot;,
                        &quot;label&quot;: {
                            &quot;es&quot;: &quot;Eliminar&quot;,
                            &quot;en-US&quot;: &quot;Remove &quot;
                        },
                        &quot;className&quot;: &quot;&quot;,
                        &quot;objectApiName&quot;: &quot;altm__Commercial_Alert__Share&quot;,
                        &quot;title&quot;: {
                            &quot;es&quot;: &quot;Eliminar&quot;,
                            &quot;en-US&quot;: &quot;Delete &quot;
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
        <value xsi:type="xsd:string">toLabel(AccessLevel),UserOrGroup.Name,ParentId,toLabel(RowCause),UserOrGroup.UserRole.Name,LastModifiedDate</value>
    </values>
    <values>
        <field>Filter__c</field>
        <value xsi:type="xsd:string">ParentId=:recordId</value>
    </values>
    <values>
        <field>HeadActions__c</field>
        <value xsi:type="xsd:string">{
    &quot;values&quot;: [
        {
            &quot;name&quot;: &quot;insert&quot;,
            &quot;className&quot;: &quot;BE_CA_CustomTeam_Cls&quot;,
            &quot;objectApiName&quot;: &quot;ctcp__Custom_Team__c&quot;,
            &quot;defaultValue&quot;: &quot;Commercial_Alert__c&quot;,
            &quot;label&quot;: {
                &quot;es&quot;: &quot;Agregar&quot;,
                &quot;en-US&quot;: &quot;Add&quot;
            },
            &quot;title&quot;: {
                &quot;es&quot;: &quot;Agregar usuario al equipo de alerta&quot;,
                &quot;en-US&quot;: &quot;Add user to alert team&quot;
            },
            &quot;fields&quot;: [
                {
                    &quot;fieldName&quot;: &quot;OwnerId&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;ctcp__gf_team_users_desc__c&quot;,
                    &quot;required&quot;: &quot;true&quot;
                },
                {
                    &quot;fieldName&quot;: &quot;Commercial_Alert__c&quot;,
                    &quot;required&quot;: &quot;true&quot;,
                    &quot;disabled&quot;: &quot;true&quot;,
                    &quot;value&quot;: &quot;recordId&quot;
                }
            ]
        }
    ]
}</value>
    </values>
    <values>
        <field>NumberRows__c</field>
        <value xsi:type="xsd:double">5.0</value>
    </values>
    <values>
        <field>Order__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:type="xsd:string">{
&quot;readClassName&quot;: &quot;BE_CA_CustomTeam_Cls&quot;
}</value>
    </values>
    <values>
        <field>sObjectApiName__c</field>
        <value xsi:type="xsd:string">altm__Commercial_Alert__Share</value>
    </values>
</CustomMetadata>
