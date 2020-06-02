<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>VisitButtonStripPeru</label>
    <protected>false</protected>
    <values>
        <field>dwp_kitv__ButtonStrip_Configuration__c</field>
        <value xsi:type="xsd:string">{
	&quot;left&quot;: [
		{
			&quot;name&quot;: &quot;button0&quot;,
			&quot;label&quot;: &quot;Nuevo tema&quot;,
			&quot;link&quot;: &quot;&quot;,
			&quot;variant&quot;: &quot;Brand&quot;,
			&quot;quickaction&quot;: &quot;dwp_kitv__Visit__c.dwp_kitv__New_Topic&quot;,
			&quot;criteria&quot;: [
				{
					&quot;field&quot;: &quot;dwp_kitv__visit_status_type__c&quot;,
					&quot;values&quot;: [&quot;06&quot;],
					&quot;equals&quot;: false
				}
			],
			&quot;logic&quot;: &quot;AND&quot;,
			&quot;show&quot;: true
		},
		{
			&quot;name&quot;: &quot;button1&quot;,
			&quot;label&quot;: &quot;Nuevo tema&quot;,
			&quot;link&quot;: &quot;&quot;,
			&quot;variant&quot;: &quot;Neutral&quot;,
			&quot;quickaction&quot;: &quot;&quot;,
			&quot;criteria&quot;: [
				{
					&quot;field&quot;: &quot;dwp_kitv__visit_status_type__c&quot;,
					&quot;values&quot;: [&quot;06&quot;],
					&quot;equals&quot;: true
				}
			],
			&quot;logic&quot;: &quot;AND&quot;,
			&quot;show&quot;: true
		}
    ],
	&quot;right&quot;: [
		{
			&quot;name&quot;: &quot;button2&quot;,
			&quot;label&quot;: &quot;Generar minuta&quot;,
			&quot;link&quot;: &quot;&quot;,
			&quot;variant&quot;: &quot;Brand&quot;,
			&quot;quickaction&quot;: &quot;dwp_kitv__Visit__c.dwp_kitv__Minutes&quot;,
			&quot;criteria&quot;: [
				{
					&quot;field&quot;: &quot;dwp_kitv__visit_status_type__c&quot;,
					&quot;values&quot;: [&quot;02&quot;],
					&quot;equals&quot;: true
				}
			],
			&quot;logic&quot;: &quot;AND&quot;,
			&quot;show&quot;: true
		},
		{
			&quot;name&quot;: &quot;button3&quot;,
			&quot;label&quot;: &quot;Generar minuta&quot;,
			&quot;link&quot;: &quot;&quot;,
			&quot;variant&quot;: &quot;Neutral&quot;,
			&quot;quickaction&quot;: &quot;&quot;,
			&quot;criteria&quot;: [
				{
					&quot;field&quot;: &quot;dwp_kitv__visit_status_type__c&quot;,
					&quot;values&quot;: [&quot;02&quot;],
					&quot;equals&quot;: false
				}
			],
			&quot;logic&quot;: &quot;AND&quot;,
			&quot;show&quot;: true
		}
	]
}</value>
    </values>
    <values>
        <field>dwp_kitv__Fields_to_Query__c</field>
        <value xsi:type="xsd:string">dwp_kitv__visit_status_type__c</value>
    </values>
    <values>
        <field>dwp_kitv__Object_to_query__c</field>
        <value xsi:type="xsd:string">dwp_kitv__Visit__c</value>
    </values>
</CustomMetadata>
