<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>BE_SalesMeeting</label>
    <protected>false</protected>
    <values>
        <field>Buttons__c</field>
        <value xsi:type="xsd:string">{
    &quot;buttons&quot;: [
        {
            &quot;label&quot;: &quot;Proyección mensual&quot;,
            &quot;name&quot;: &quot;button01&quot;,
            &quot;variant&quot;: &quot;brand&quot;,
            &quot;navigate&quot;: {
                &quot;type&quot;: &quot;standard__recordPage&quot;,
                &quot;attributes&quot;: {
                    &quot;apexClass&quot;: &quot;BE_SM_ManagementPlanLink_Cls&quot;,
                    &quot;objectApiName&quot;: &quot;Report&quot;,
                    &quot;actionName&quot;: &quot;view&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Calce&quot;,
            &quot;name&quot;: &quot;button02&quot;,
            &quot;variant&quot;: &quot;brand&quot;,
            &quot;navigate&quot;: {
                &quot;type&quot;: &quot;standard__objectPage&quot;,
                &quot;attributes&quot;: {
                    &quot;objectApiName&quot;: &quot;Calce__c&quot;,
                    &quot;actionName&quot;: &quot;list&quot;
                },
                &quot;state&quot;: {
                    &quot;filterName&quot;: &quot;BE_CalceLastSevenDay&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Planes comerciales oficina&quot;,
            &quot;name&quot;: &quot;button03&quot;,
            &quot;variant&quot;: &quot;brand&quot;,
            &quot;navigate&quot;: {
                &quot;type&quot;: &quot;standard__recordPage&quot;,
                &quot;attributes&quot;: {
                    &quot;filter&quot;: &quot;Title=@@Planes Comerciales Oficina@@&quot;,
                    &quot;objectApiName&quot;: &quot;Dashboard&quot;,
                    &quot;actionName&quot;: &quot;view&quot;
                }
            }
        },
        {
            &quot;label&quot;: &quot;Visitas&quot;,
            &quot;name&quot;: &quot;button04&quot;,
            &quot;variant&quot;: &quot;brand&quot;,
            &quot;navigate&quot;: {
                &quot;type&quot;: &quot;standard__recordPage&quot;,
                &quot;attributes&quot;: {
                    &quot;filter&quot;: &quot;Title=@@Panel de Visitas@@&quot;,
                    &quot;objectApiName&quot;: &quot;Dashboard&quot;,
                    &quot;actionName&quot;: &quot;view&quot;
                }
            }
        }
    ]
}</value>
    </values>
    <values>
        <field>Settings__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
