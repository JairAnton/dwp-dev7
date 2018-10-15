<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>GetQuotationRequest</label>
    <protected>false</protected>
    <values>
        <field>iaso__Authentication_Service__c</field>
        <value xsi:type="xsd:string">bbvaPeruGrantingTickets</value>
    </values>
    <values>
        <field>iaso__Custom_Setting__c</field>
        <value xsi:type="xsd:string">GetQuotationRequest</value>
    </values>
    <values>
        <field>iaso__Headers_Class__c</field>
        <value xsi:type="xsd:string">Header_helper</value>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Http_Headers_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;Content-Type&quot;: &quot;application/json&quot;, &quot;back-clientdocument&quot;:&quot;&quot;}</value>
    </values>
    <values>
        <field>iaso__Http_Method__c</field>
        <value xsi:type="xsd:string">GET</value>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Json_Input_Template_LTA__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Mock_LTA__c</field>
        <value xsi:type="xsd:string">{&quot;data&quot;:{&quot;id&quot;:&quot;1481404&quot;,&quot;status&quot;:{&quot;id&quot;:&quot;OPEN&quot;,&quot;name&quot;:&quot;ABIERTO&quot;},&quot;participant&quot;:{&quot;id&quot;:&quot;21944202&quot;,&quot;identityDocuments&quot;:[{&quot;documentType&quot;:{&quot;id&quot;:&quot;RUC&quot;},&quot;documentNumber&quot;:&quot;20511919861&quot;}],&quot;situation&quot;:{&quot;id&quot;:&quot;SLOW_PAYER&quot;},&quot;totalDaysAsCustomer&quot;:3178,&quot;bank&quot;:{&quot;branch&quot;:{&quot;id&quot;:&quot;0362&quot;,&quot;name&quot;:&quot;BE COLONIAL&quot;}},&quot;segment&quot;:{&quot;subSegment&quot;:{&quot;id&quot;:&quot;Negocios 1 - A&quot;,&quot;name&quot;:&quot;Negocios 1 - A&quot;,&quot;partitions&quot;:[{&quot;id&quot;:&quot;RETAIL_BANKING&quot;,&quot;value&quot;:&quot;NORMAL 3&quot;}]},&quot;id&quot;:&quot;50100&quot;,&quot;name&quot;:&quot;NEGOCIOS 1 AV&quot;},&quot;bureau&quot;:{&quot;score&quot;:75.63101,&quot;id&quot;:&quot;G8&quot;},&quot;totalBanks&quot;:0,&quot;delinquency&quot;:{&quot;maxOverdueDays&quot;:0},&quot;riskTag&quot;:&quot;6&quot;,&quot;grossMargin&quot;:{&quot;percentage&quot;:&quot;52176.0&quot;},&quot;propensityLevel&quot;:0,&quot;relatedFamilies&quot;:1,&quot;membershipDate&quot;:&quot;2006-07-10T00:00:00.000-0500&quot;,&quot;detail&quot;:{&quot;businessName&quot;:&quot;CONVEYOR SYSTEMS SAC&quot;,&quot;bankingData&quot;:{&quot;classification&quot;:{&quot;id&quot;:&quot;BUSINESS_BANKING&quot;,&quot;name&quot;:&quot;BUSINESS_BANKING&quot;},&quot;adjustedBanking&quot;:{&quot;id&quot;:&quot;50100&quot;,&quot;name&quot;:&quot;BEC&quot;},&quot;id&quot;:&quot;2685&quot;,&quot;name&quot;:&quot;BEC&quot;},&quot;financialGroup&quot;:{&quot;id&quot;:&quot;28921&quot;},&quot;riskAssessment&quot;:{&quot;tag&quot;:&quot;6&quot;},&quot;financialStatement&quot;:{&quot;tag&quot;:&quot;0&quot;},&quot;liabilities&quot;:[{&quot;id&quot;:&quot;DEBT_MAX_OB&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEBT_CORPORATIVE&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEUDA_GRAN_EMPRESA&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEUDA_MEDIANA_EMPRESA&quot;,&quot;amount&quot;:1115511.46,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEBT_OTROS_TIPOS&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEDID_DIRECTA_SF&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEBD_DIRECTA_BBVA&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEUDA_MAX_COMERCIAL_RCC&quot;,&quot;amount&quot;:0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;DEBT_MAX_PERSONAL_RCC&quot;,&quot;amount&quot;:0.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;SALDO_DEUDA_INDIRECTA_SF&quot;,&quot;amount&quot;:0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;SALDO_DEUDA_INDIRECTA_BANK&quot;,&quot;amount&quot;:254904.41,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;SALDO_MEDIO_PASIVO&quot;,&quot;amount&quot;:135.0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;id&quot;:&quot;MEDIUM_COUNTS_BALANCE&quot;,&quot;amount&quot;:636807.0,&quot;currency&quot;:&quot;PEN&quot;}],&quot;transactionalflows&quot;:{&quot;collections&quot;:[{&quot;amount&quot;:0,&quot;currency&quot;:&quot;USD&quot;}],&quot;payments&quot;:[{&quot;amount&quot;:0,&quot;currency&quot;:&quot;PEN&quot;},{&quot;amount&quot;:0,&quot;currency&quot;:&quot;USD&quot;}]}},&quot;taxpayer&quot;:{&quot;taxpayerType&quot;:{&quot;id&quot;:&quot;LEGAL_PERSON&quot;}}},&quot;quotations&quot;:[{&quot;status&quot;:{&quot;id&quot;:&quot;REQUESTED&quot;,&quot;name&quot;:&quot;SOLICITADA&quot;},&quot;validityDate&quot;:&quot;2018-10-24T12:58:15.421-0500&quot;,&quot;id&quot;:&quot;1473004&quot;,&quot;version&quot;:&quot;1&quot;,&quot;interestRates&quot;:{&quot;effectiveRates&quot;:[{&quot;id&quot;:&quot;TEA_OF_MODEL&quot;,&quot;percentage&quot;:0.1602},{&quot;id&quot;:&quot;MINIMUM_TEA&quot;,&quot;percentage&quot;:0.161},{&quot;id&quot;:&quot;SUGGESTED_TEA&quot;,&quot;percentage&quot;:0.175},{&quot;id&quot;:&quot;MINIMUM_TEA_OF_MODEL&quot;,&quot;percentage&quot;:0.161},{&quot;id&quot;:&quot;SUGGESTED_TEA_OF_MODEL&quot;,&quot;percentage&quot;:0.175},{&quot;id&quot;:&quot;TEA_OF_AUTONOMY&quot;,&quot;percentage&quot;:0.160962}]},&quot;comment&quot;:&quot;Create quotation request from DWP&quot;,&quot;product&quot;:{&quot;id&quot;:&quot;11&quot;,&quot;requestedAmount&quot;:{&quot;amount&quot;:400000.0,&quot;currency&quot;:&quot;PEN&quot;},&quot;name&quot;:&quot;Préstamo Comercial (CP)&quot;,&quot;guarantee&quot;:{&quot;coverage&quot;:100,&quot;classification&quot;:{&quot;id&quot;:&quot;47&quot;,&quot;name&quot;:&quot;SIN_GARANTIA&quot;}},&quot;contractingModality&quot;:{&quot;id&quot;:&quot;28&quot;,&quot;name&quot;:&quot;Linea Regular&quot;},&quot;term&quot;:{&quot;frequency&quot;:{&quot;id&quot;:&quot;MONTHLY&quot;,&quot;name&quot;:&quot;MES&quot;},&quot;termNumber&quot;:11}},&quot;businessAgents&quot;:[{&quot;position&quot;:{&quot;id&quot;:&quot;CZ2&quot;,&quot;name&quot;:&quot;ESPEC PRECIOS BANCA MIN&quot;},&quot;id&quot;:&quot;P012677&quot;,&quot;firstName&quot;:&quot;IRMA BEATRIZ&quot;,&quot;lastName&quot;:&quot;COLLANTES&quot;,&quot;secondLastName&quot;:&quot;BOHORQUEZ&quot;,&quot;workTeam&quot;:{&quot;id&quot;:&quot;ANA_PRE_BEC&quot;,&quot;name&quot;:&quot;Analista de Precios BEC&quot;},&quot;classification&quot;:{&quot;involvements&quot;:[{&quot;involvementType&quot;:{&quot;id&quot;:&quot;ASSIGNED&quot;,&quot;description&quot;:&quot;Usuario asignado a la cotización&quot;}}]}},{&quot;position&quot;:{&quot;id&quot;:&quot;E0B&quot;,&quot;name&quot;:&quot;ASISTENTE BEC&quot;},&quot;id&quot;:&quot;P022023&quot;,&quot;firstName&quot;:&quot;DEYANIRA&quot;,&quot;lastName&quot;:&quot;FERNANDEZ&quot;,&quot;secondLastName&quot;:&quot;MALDONADO&quot;,&quot;workTeam&quot;:{&quot;id&quot;:&quot;EJE_BEC&quot;,&quot;name&quot;:&quot;Ejecutivo BEC&quot;},&quot;classification&quot;:{&quot;involvements&quot;:[{&quot;involvementType&quot;:{&quot;id&quot;:&quot;REGISTERED&quot;,&quot;description&quot;:&quot;Usuario que registra la cotización&quot;}}]}}],&quot;bank&quot;:{&quot;branch&quot;:{&quot;id&quot;:&quot;0397&quot;,&quot;name&quot;:&quot;BANCA EMPRESAS REPUBLICA DE PANAMA&quot;}},&quot;disbursement&quot;:{&quot;status&quot;:{&quot;id&quot;:&quot;PENDING&quot;,&quot;description&quot;:&quot;PENDIENTE&quot;}},&quot;profitabilityIndicators&quot;:[{&quot;id&quot;:&quot;PROFITABILITY_FOR_RISK_OF_MODEL_TEA&quot;,&quot;percentage&quot;:0.215},{&quot;id&quot;:&quot;PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA&quot;,&quot;percentage&quot;:-0.6303},{&quot;id&quot;:&quot;BENEFIT_BEFORE_TAX_OF_OPERATION&quot;,&quot;percentage&quot;:0.0384},{&quot;id&quot;:&quot;BENEFIT_BEFORE_TAX_OF_REQUESTED_TEA&quot;,&quot;percentage&quot;:-0.1126},{&quot;id&quot;:&quot;BENEFIT_BEFORE_TAX_OF_MINIMUM_TEA&quot;,&quot;percentage&quot;:0.0384}],&quot;liquidityIndicators&quot;:[{&quot;id&quot;:&quot;SPREAD_MINIMUM_LIMIT&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.0}},{&quot;id&quot;:&quot;ADDITIONAL_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;MINIMUM_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;COMMERCIAL_SPREAD&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.04}},{&quot;id&quot;:&quot;SPREAD_OF_OPERATION&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.1237}},{&quot;id&quot;:&quot;ADDITIONAL_SPREAD_OF_REQUESTED_TEA&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0.005}},{&quot;id&quot;:&quot;COMMERCIAL_SPREAD_OF_REQUESTED_TEA&quot;,&quot;detail&quot;:{&quot;percentage&quot;:0}},{&quot;id&quot;:&quot;MINIMUM_SPREAD_OF_REQUESTED_TEA&quot;,&quot;detail&quot;:{&quot;percentage&quot;:-0.1126}},{&quot;id&quot;:&quot;SPREAD_OF_REQUESTED_TEA&quot;,&quot;detail&quot;:{&quot;percentage&quot;:-0.0273}}],&quot;fees&quot;:[{&quot;feeType&quot;:{&quot;id&quot;:&quot;EXPECTED_LOSS&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.063162}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FUNDING_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0426}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FINANCING_COST_STOCKHOLDER&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0147}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;FUNDING_COST_ADJUSTED&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0373}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;EFFICIENCY_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.0074}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;REGULATORY_CAPITAL&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.1}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;ADDITIONAL_CAPITAL&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.025}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;CAPITAL&quot;},&quot;detail&quot;:{&quot;amount&quot;:50000.0}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;OPPORTUNITY_COST&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.1175}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;EFFICIENCY_COST_FACTOR&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.164}},{&quot;feeType&quot;:{&quot;id&quot;:&quot;TAX_RATE&quot;},&quot;detail&quot;:{&quot;percentage&quot;:0.3}}],&quot;model&quot;:{&quot;id&quot;:&quot;2&quot;},&quot;creationDate&quot;:&quot;2018-10-09T12:58:15.399-0500&quot;,&quot;financialIndicators&quot;:[{&quot;id&quot;:&quot;TACTICAL_FACTOR&quot;,&quot;value&quot;:&quot;1&quot;},{&quot;id&quot;:&quot;FUNDING_COST_TERM&quot;,&quot;value&quot;:&quot;360&quot;},{&quot;id&quot;:&quot;FUNDING_COST_DATE&quot;,&quot;value&quot;:&quot;Thu Aug 16 00:00:00 PET 2018&quot;},{&quot;id&quot;:&quot;CLUSTER&quot;,&quot;value&quot;:&quot;E1006&quot;},{&quot;id&quot;:&quot;COLLECTIVE_FLAG&quot;,&quot;value&quot;:&quot;false&quot;}]}]}}</value>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA_TEMP__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>iaso__Querystring_Input_Template_LTA__c</field>
        <value xsi:type="xsd:string">/#quotationId#?expand=quotations</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA_TEMP__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>iaso__Retrieve_Mock_LTA__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
</CustomMetadata>
