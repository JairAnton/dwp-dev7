@isTest
global class Integration_MockGenerator implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req) {
		// Optionally, only send a mock response for a specific endpoint
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');

		switch on req.getEndpoint() {
			when 'https://validation/ok' {
				System.assertEquals('https://validation/ok', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setHeader('access_token', '**************sessionToken*************');
				res.setHeader('tsec', '**************sessionToken*************');
				res.setBody('{}');
				res.setStatusCode(200);
			}
			when 'https://CompromiseProducts/ok/v1/products/3/compromise-products' {
				System.assertEquals('https://CompromiseProducts/ok/v1/products/3/compromise-products', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"data":[{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"10","name":"INCR. SM VISTA + AHORRO\\t"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"11","name":"VISANET"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"12","name":"PAGO HABERES"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"13","name":"PAGO PROVEEDORES"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"14","name":"RECAUDOS"}]}');
				res.setStatusCode(200);
			}
			when 'https://SimulateRate/ok' {
				System.assertEquals('https://SimulateRate/ok', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data":{"calculationType":{"id":"UNIQUE"},"model":{"id":"2"},"businessAgent":{},"participant":{"identityDocuments":[{"documentType":{}}],"bank":{},"segment":{"subSegment":{"partitions":[]}},"delinquency":{"behaviorDebts":{"tacticalVariable":[]}},"strategicRelationships":[],"riskLevel":[]},"product":{"requestedAmount":{},"term":{},"guarantee":{}},"summary":[{"financialIndicators":[{"id":"CLUSTER","value":"BE_PCOMCP_01987"},{"id":"COLLECTIVE_FLAG","value":"false"},{"id":"TACTICAL_FACTOR","value":"1"}],"interestRates":{"effectiveRates":[{"id":"ADJUSTED_MODEL_TEA","percentage":0.00030},{"id":"MINIMUM_TEA","percentage":0.0756},{"id":"SUGGESTED_TEA","percentage":0.0856}]},"fees":[{"feeType":{"id":"EXPECTED_LOSS"},"detail":{"percentage":0.001528}},{"feeType":{"id":"FUNDING_COST"},"detail":{"percentage":0.0256}},{"feeType":{"id":"EFFICIENCY_COST"},"detail":{"percentage":0.0}},{"feeType":{"id":"FINANCING_COST_STOCKHOLDER"},"detail":{"percentage":0.0164}},{"feeType":{"id":"FUNDING_COST_ADJUSTED"},"detail":{"percentage":0.0225}},{"feeType":{"id":"REGULATORY_CAPITAL"},"detail":{"percentage":0.1}},{"feeType":{"id":"ADDITIONAL_CAPITAL"},"detail":{"percentage":0.0228}},{"feeType":{"id":"CAPITAL"},"detail":{"amount":9824.0,"currency":"USD"}}],"liquidityIndicators":[{"id":"ADDITIONAL_SPREAD","detail":{"percentage":0.005}},{"id":"MINIMUM_SPREAD","detail":{"percentage":0.003}},{"id":"COMMERCIAL_SPREAD","detail":{"percentage":0.0133}}]}],"indicators":[{"id":"RORC_CLIENT_VARIATION","value":"0.000455"},{"id":"RORC_CLIENT_STOCK_PERIOD","value":"2019-12-01 00:00:00.0"},{"id":"RAROEC_CLIENT_STOCK_PERIOD","value":"2019-12-01 00:00:00.0"},{"id":"LOST_FINANCIAL_MARGIN","value":"0"},{"id":"RORC_OPERATION_LOST_FINANCIAL_MARGIN","value":"-2161.408763"},{"id":"RAROEC_OPERATION_LOST_FINANCIAL_MARGIN","value":"-2715.133926"},{"id":"RORC_CLIENT_LOST_FINANCIAL_MARGIN","value":"-120747.060712"},{"id":"RORC_CLIENT_STOCK_MONTH_ACTIVE","value":"0.107978"},{"id":"RAROEC_CLIENT_STOCK_MONTH_ACTIVE","value":"0.283415"},{"id":"RORC_THRESHOLD_CLIENT","value":"0.078"},{"id":"RAROEC_THRESHOLD_OPERATION","value":"0.094"},{"id":"RORC_CLIENT_POST","value":"0.108433"},{"id":"RAROEC_CLIENT_POST","value":"0.284656"},{"id":"RORC_OPERATION","value":"0.253434"},{"id":"RAROEC_OPERATION","value":"0.703360"},{"id":"PASS_THRESHOLD_RORC","value":"0"},{"id":"PASS_THRESHOLD_RAROEC_OPERATION","value":"0"},{"id":"PASS_THRESHOLD","value":"0"}]}}');
				res.setStatusCode(200);
			}
			when 'https://SimulateRate/ko' {
				System.assertEquals('https://SimulateRate/ko', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://CreateRequestElevated/OK' {
				System.assertEquals('https://CreateRequestElevated/OK', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data":{"id":"1468400","quotations":[{"businessAgents":[{"classification":{"involvements":[{"involvementType":{"description":"Usuario asignado a la cotización","id":"ASSIGNED"}}]},"firstName":"IRMA BEATRIZ","id":"P012677","lastName":"COLLANTES","secondLastName":"BOHORQUEZ","workTeam":{"id":"ANA_PRE_BEC","name":"Analista de Precios BEC"}}],"disbursement":{"status":{"description":"PENDIENTE","id":"PENDING"}},"id":"1464550","status":{"id":"REQUESTED","name":"SOLICITADA"},"version":"1"}],"status":{"id":"OPEN","name":"ABIERTO"}}}');
				res.setStatusCode(200);
			}
			when 'https://CreateRequestApproved/OK' {
				System.assertEquals('https://CreateRequestApproved/OK', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data":{"id":"1471556","status":{"id":"OPEN","name":"ABIERTO"},"quotations":[{"status":{"id":"TARIFY","name":"TARIFARIO"},"id":"1468706","version":"1","businessAgents":[{"id":"P024971","firstName":"JUAN ESTUARDO","lastName":"CEDRON","secondLastName":"DELGADO","workTeam":{"id":"EJE_BEC","name":"Ejecutivo BEC"},"classification":{"involvements":[{"involvementType":{"id":"ASSIGNED","description":"Usuario asignado a la cotización"}}]}}],"disbursement":{"status":{"id":"PENDING","description":"PENDIENTE"}}}]}}');
				res.setStatusCode(200);
			}
			when 'https://CreateRequest/KO_500' {
				System.assertEquals('https://CreateRequest/KO_500', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":500,"error-code":"errorRestConnector","error-message":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","consumer-request-id":"10d26ad6-9a90-45ac-a6dd-7e54e317bd3a","system-error-code":"errorRestConnector","system-error-description":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","system-error-cause":"Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada"}');
				res.setStatusCode(500);
			}
			when 'https://CreateRequest/KO_409' {
				System.assertEquals('https://CreateRequest/KO_409', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://ProductsQuote/ok?participant.id=123567' {
				System.assertEquals('https://ProductsQuote/ok?participant.id=123567', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"data":[{"id":"15","name":"Carta Fianza","contractingModalities":[{"id":"19","name":"Linea"},{"id":"15","name":"Subrogado"},{"id":"1","name":"Nuevo"},{"id":"14","name":"Prorroga"}],"productType":{"id":"LETTER_GUARANTEE"},"pricing":{"id":"17"}},{"id":"11","name":"Préstamo Comercial (CP)","contractingModalities":[{"id":"4","name":"Reprogramado"},{"id":"5","name":"Refinanciado"},{"id":"7","name":"Credito Puntual"},{"id":"8","name":"Linea Regular"},{"id":"9","name":"Credito Liquido"}],"productType":{"id":"COMMERCIAL_CONSUME"},"pricing":{"id":"3"}},{"id":"6","name":"FIA Importación","contractingModalities":[{"id":"16","name":"Canal Internet"},{"id":"15","name":"Subrogado"},{"id":"7","name":"Credito Puntual"},{"id":"8","name":"Linea Regular"},{"id":"14","name":"Prorroga"}],"productType":{"id":"TRADE_FINANCE"},"pricing":{"id":"7"}},{"id":"7","name":"FIA Exportación","contractingModalities":[{"id":"16","name":"Canal Internet"},{"id":"15","name":"Subrogado"},{"id":"7","name":"Credito Puntual"},{"id":"8","name":"Linea Regular"},{"id":"14","name":"Prorroga"}],"productType":{"id":"TRADE_FINANCE"},"pricing":{"id":"8"}},{"id":"12","name":"Forfaiting","contractingModalities":[{"id":"16","name":"Canal Internet"},{"id":"15","name":"Subrogado"},{"id":"7","name":"Credito Puntual"},{"id":"8","name":"Linea Regular"},{"id":"14","name":"Prorroga"}],"productType":{"id":"TRADE_FINANCE"},"pricing":{"id":"9"}}]}');
				res.setStatusCode(200);
			}
			when 'https://ProductsQuote/ko?participant.id=123567' {
				System.assertEquals('https://ProductsQuote/ko?participant.id=123567', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":500,"error-code":"errorRestConnector","error-message":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","consumer-request-id":"10d26ad6-9a90-45ac-a6dd-7e54e317bd3a","system-error-code":"errorRestConnector","system-error-description":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","system-error-cause":"Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada"}');
				res.setStatusCode(500);
			}
			when 'https://ProductsQuote/ko409?participant.id=123567' {
				System.assertEquals('https://ProductsQuote/ko409?participant.id=123567', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://CalculateRate/ok' {
				System.assertEquals('https://CalculateRate/ok', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data":{"calculationType":{"id":"UNIQUE"},"model":{"id":"2"},"businessAgent":{},"participant":{"identityDocuments":[{"documentType":{}}],"bank":{},"segment":{"subSegment":{"partitions":[]}},"delinquency":{"behaviorDebts":{"tacticalVariable":[]}},"strategicRelationships":[],"riskLevel":[]},"product":{"requestedAmount":{},"term":{},"guarantee":{}},"summary":[{"calculationId":"173380","financialIndicators":[{"id":"CLUSTER","value":"E1014"},{"id":"COLLECTIVE_FLAG","value":"false"},{"id":"TACTICAL_FACTOR","value":"1"}],"interestRates":{"effectiveRates":[{"id":"ADJUSTED_MODEL_TEA","percentage":0.00020},{"id":"MINIMUM_TEA","percentage":0.154},{"id":"SUGGESTED_TEA","percentage":0.165}]},"fees":[{"feeType":{"id":"EXPECTED_LOSS"},"detail":{"percentage":0.063162}},{"feeType":{"id":"FUNDING_COST"},"detail":{"percentage":0.0353}},{"feeType":{"id":"EFFICIENCY_COST"},"detail":{"percentage":0.0074}},{"feeType":{"id":"FINANCING_COST_STOCKHOLDER"},"detail":{"percentage":0.0147}},{"feeType":{"id":"FUNDING_COST_ADJUSTED"},"detail":{"percentage":0.0309}},{"feeType":{"id":"REGULATORY_CAPITAL"},"detail":{"percentage":0.1}},{"feeType":{"id":"ADDITIONAL_CAPITAL"},"detail":{"percentage":0.025}},{"feeType":{"id":"CAPITAL"},"detail":{"amount":2931.88,"currency":"PEN"}}],"liquidityIndicators":[{"id":"ADDITIONAL_SPREAD","detail":{"percentage":0.005}},{"id":"MINIMUM_SPREAD","detail":{"percentage":0.005}},{"id":"COMMERCIAL_SPREAD","detail":{"percentage":0.04}}]}]}}');
				res.setStatusCode(200);
			}
			when 'https://ModifyQuotationRequestRecover/OK/111/quotations/222' {
				System.assertEquals('https://ModifyQuotationRequestRecover/OK/111/quotations/222', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data": {"status": {"id": "RECOVERED","name": "RECUPERADA"},"id": "1469800","version": "1","businessAgents": [{"id": "P012170","firstName": "CECILIA","lastName": "AGUIRRE","secondLastName": "GONZALES","workTeam": {"id": "EJE_BEC","name": "Ejecutivo BEC"},"classification": {"involvements": [{"involvementType": {"id": "ASSIGNED","description": "Usuario asignado a la cotización"}}]}}],"disbursement": {"status": {"id": "PENDING","description": "PENDIENTE"}}}}');
				res.setStatusCode(200);
			}
			when 'https://ModifyQuotationRequestRecover/KO_409/111/quotations/222' {
				System.assertEquals('https://ModifyQuotationRequestRecover/KO_409/111/quotations/222', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://ModifyQuotationRequestRecover/KO_500/111/quotations/222' {
				System.assertEquals('https://ModifyQuotationRequestRecover/KO_500/111/quotations/222', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":500,"error-code":"errorRestConnector","error-message":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","consumer-request-id":"10d26ad6-9a90-45ac-a6dd-7e54e317bd3a","system-error-code":"errorRestConnector","system-error-description":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","system-error-cause":"Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada"}');
				res.setStatusCode(500);
			}
			when 'https://ModifyQuotationRequestRejection/OK/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestRejection/OK/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data": {"status": {"id": "REGISTER_LOST","name": "PERDIDA"},"id": "1469800","version": "1","businessAgents": [{"id": "P012170","firstName": "CECILIA","lastName": "AGUIRRE","secondLastName": "GONZALES","workTeam": {"id": "EJE_BEC","name": "Ejecutivo BEC"},"classification": {"involvements": [{"involvementType": {"id": "ASSIGNED","description": "Usuario asignado a la cotización"}}]}}],"disbursement": {"status": {"id": "PENDING","description": "PENDIENTE"}}}}');
				res.setStatusCode(200);
			}
			when 'https://ModifyQuotationRequestDisburse/OK/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestDisburse/OK/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data": {"status": {"id": "APPROVED","name": "APROBADO"},"id": "1469800","version": "1","businessAgents": [{"id": "P012170","firstName": "CECILIA","lastName": "AGUIRRE","secondLastName": "GONZALES","workTeam": {"id": "EJE_BEC","name": "Ejecutivo BEC"},"classification": {"involvements": [{"involvementType": {"id": "ASSIGNED","description": "Usuario asignado a la cotización"}}]}}],"disbursement": {"status": {"id": "DISBURSED","description": "DESEMBOLSADO"}}}}');
				res.setStatusCode(200);
			}
			when 'https://ModifyQuotationRequestDisburse/KO_409/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestDisburse/KO_409/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://ModifyQuotationRequestDisburse/KO_500/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestDisburse/KO_500/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":500,"error-code":"errorRestConnector","error-message":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","consumer-request-id":"10d26ad6-9a90-45ac-a6dd-7e54e317bd3a","system-error-code":"errorRestConnector","system-error-description":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","system-error-cause":"Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada"}');
				res.setStatusCode(500);
			}
			when 'https://ModifyQuotationRequestApproval/OK/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestApproval/OK/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data": {"status": {"id": "REQUESTED","name": "SOLICITADA"},"id": "1469800","version": "1","businessAgents": [{"id": "P012170","firstName": "CECILIA","lastName": "AGUIRRE","secondLastName": "GONZALES","workTeam": {"id": "EJE_BEC","name": "Ejecutivo BEC"},"classification": {"involvements": [{"involvementType": {"id": "ASSIGNED","description": "Usuario asignado a la cotización"}}]}}],"disbursement": {"status": {"id": "DISBURSED","description": "DESEMBOLSADO"}}}}');
				res.setStatusCode(200);
			}
			when 'https://ModifyQuotationRequestApproval/OK_2/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestApproval/OK_2/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data": {"status": {"id": "TARIFY","name": "TARIFARIO"},"id": "1469800","version": "1","businessAgents": [{"id": "P012170","firstName": "CECILIA","lastName": "AGUIRRE","secondLastName": "GONZALES","workTeam": {"id": "EJE_BEC","name": "Ejecutivo BEC"},"classification": {"involvements": [{"involvementType": {"id": "ASSIGNED","description": "Usuario asignado a la cotización"}}]}}],"disbursement": {"status": {"id": "DISBURSED","description": "DESEMBOLSADO"}}}}');
				res.setStatusCode(200);
			}
			when 'https://ModifyQuotationRequestApproval/KO_409/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestApproval/KO_409/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://ModifyQuotationRequestApproval/KO_500/1475650/quotations/1469800' {
				System.assertEquals('https://ModifyQuotationRequestApproval/KO_500/1475650/quotations/1469800', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":500,"error-code":"errorRestConnector","error-message":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","consumer-request-id":"10d26ad6-9a90-45ac-a6dd-7e54e317bd3a","system-error-code":"errorRestConnector","system-error-description":"There is an error interacting with RestConnector: Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada.","system-error-cause":"Connect to 118.180.35.119:8280 [/118.180.35.119] failed: Conexión rehusada"}');
				res.setStatusCode(500);
			}
			when 'https://CreateQuotationCommitment/ok/requests/111/quotations/111/commitments' {
				System.assertEquals('https://CreateQuotationCommitment/ok/requests/111/quotations/111/commitments', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data":{"id":"11050","status":{"id":"PENDING","name":"PENDIENTE"},"product":{"id":"23","committedData":{"validityDate":"2018-10-15T09:55:22.852-0500","unitValue":{"amount":345343,"currency":"PEN"}}}}}');
				res.setStatusCode(200);
			}
			when 'https://AnalyzeRate/OK' {
				System.assertEquals('https://AnalyzeRate/OK', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data":{"id":"238068","interestRates":{"effectiveRates":[{"id":"APPROVED_ADJUSTED_TEA","percentage":0}]},"financialIndicators":[{"id":"PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA","value":"0.0546"}],"liquidityIndicators":[{"detail":{"currency":"PEN"}},{"id":"ADDITIONAL_SPREAD_OF_REQUESTED_TEA","detail":{"percentage":0.005}},{"id":"MINIMUM_SPREAD_OF_REQUESTED_TEA","detail":{"percentage":0.003}},{"id":"COMMERCIAL_SPREAD_OF_REQUESTED_TEA","detail":{"percentage":0.0066}},{"id":"SPREAD_OF_OPERATION","detail":{"percentage":0.0275}},{"id":"BENEFIT_BEFORE_TAX","detail":{"percentage":0.0096}},{"id":"SPREAD_FINANTIAL","detail":{"percentage":0.05}},{"id":"SPREAD_REFERENTIAL","detail":{"percentage":0.005}}],"fees":[{"feeType":{"id":"RORC_CLIENT"},"detail":{"percentage":0.0971838}},{"feeType":{"id":"RORC_OPERATION"},"detail":{"percentage":0.1183}},{"feeType":{"id":"RORC_UPDATED"},"detail":{"percentage":0.0841}},{"feeType":{"id":"RORC_VARIATION"},"detail":{"percentage":-0.0130838}},{"feeType":{"id":"RORC_MODEL"},"detail":{"percentage":0.15455}},{"feeType":{"id":"RORC_APPROVED"},"detail":{"percentage":0.1183}}],"products":[{"id":"10","name":"INCR. SM VISTA + AHORRO","committedData":{"description":"IMPORTE SOLES","unitValue":{"amount":10.0,"currency":"PEN","unitValueDetailType":"AMOUNT"},"effectiveTime":{"unit":"DAY","number":30},"classification":"EVALUATED"}}],"indicators":[{"id":"CURRENCY_FINANCIAL_RECOVERY","value":"PEN"},{"id":"RORC_CLIENT_VARIATION","value":"0.000317"},{"id":"RORC_CLIENT_STOCK_PERIOD","value":"2019-12-01 00:00:00.0"},{"id":"RAROEC_CLIENT_STOCK_PERIOD","value":"2019-12-01 00:00:00.0"},{"id":"LOST_FINANCIAL_MARGIN","value":"0"},{"id":"RORC_OPERATION_LOST_FINANCIAL_MARGIN","value":"-1605.838663"},{"id":"RAROEC_OPERATION_LOST_FINANCIAL_MARGIN","value":"-2155.133926"},{"id":"RORC_CLIENT_LOST_FINANCIAL_MARGIN","value":"-120191.490612"},{"id":"RORC_CLIENT_STOCK_MONTH_ACTIVE","value":"0.107978"},{"id":"RAROEC_CLIENT_STOCK_MONTH_ACTIVE","value":"0.283415"},{"id":"RORC_THRESHOLD_CLIENT","value":"0.078"},{"id":"RAROEC_THRESHOLD_OPERATION","value":"0.094"},{"id":"RORC_CLIENT_POST","value":"0.108295"},{"id":"RAROEC_CLIENT_POST","value":"0.284302"},{"id":"RORC_OPERATION","value":"0.210523"},{"id":"RAROEC_OPERATION","value":"0.591936"},{"id":"PASS_THRESHOLD_RORC","value":"0"},{"id":"PASS_THRESHOLD_RAROEC_OPERATION","value":"0"},{"id":"PASS_THRESHOLD","value":"0"},{"id":"KEY_PRUEBA","value":"VALOR_PRUEBA"}]}}');
				res.setStatusCode(200);
			}
			when 'https://AnalyzeRate/KO' {
				System.assertEquals('https://AnalyzeRate/KO', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://GetQuotationRequest/OK/1111?expand=quotations' {
				System.assertEquals('https://GetQuotationRequest/OK/1111?expand=quotations', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"data":{"id":"1481404","status":{"id":"OPEN","name":"ABIERTO"},"participant":{"id":"21944202","identityDocuments":[{"documentType":{"id":"RUC"},"documentNumber":"20511919861"}],"situation":{"id":"SLOW_PAYER"},"totalDaysAsCustomer":3178,"bank":{"branch":{"id":"0362","name":"BE COLONIAL"}},"segment":{"subSegment":{"id":"Negocios 1 - A","name":"Negocios 1 - A","partitions":[{"id":"RETAIL_BANKING","value":"NORMAL 3"}]},"id":"50100","name":"NEGOCIOS 1 AV"},"bureau":{"score":75.63101,"id":"G8"},"totalBanks":0,"delinquency":{"maxOverdueDays":0},"riskTag":"6","grossMargin":{"percentage":"52176.0"},"propensityLevel":0,"relatedFamilies":1,"membershipDate":"2006-07-10T00:00:00.000-0500","detail":{"businessName":"CONVEYOR SYSTEMS SAC","bankingData":{"classification":{"id":"BUSINESS_BANKING","name":"BUSINESS_BANKING"},"adjustedBanking":{"id":"50100","name":"BEC"},"id":"2685","name":"BEC"},"financialGroup":{"id":"28921"},"riskAssessment":{"tag":"6"},"financialStatement":{"tag":"0"},"liabilities":[{"id":"DEBT_MAX_OB","amount":0.0,"currency":"PEN"},{"id":"DEBT_CORPORATIVE","amount":0.0,"currency":"PEN"},{"id":"DEUDA_GRAN_EMPRESA","amount":0.0,"currency":"PEN"},{"id":"DEUDA_MEDIANA_EMPRESA","amount":1115511.46,"currency":"PEN"},{"id":"DEBT_OTROS_TIPOS","amount":0.0,"currency":"PEN"},{"id":"DEDID_DIRECTA_SF","amount":0.0,"currency":"PEN"},{"id":"DEBD_DIRECTA_BBVA","amount":0.0,"currency":"PEN"},{"id":"DEUDA_MAX_COMERCIAL_RCC","amount":0,"currency":"PEN"},{"id":"DEBT_MAX_PERSONAL_RCC","amount":0.0,"currency":"PEN"},{"id":"SALDO_DEUDA_INDIRECTA_SF","amount":0,"currency":"PEN"},{"id":"SALDO_DEUDA_INDIRECTA_BANK","amount":254904.41,"currency":"PEN"},{"id":"SALDO_MEDIO_PASIVO","amount":135.0,"currency":"PEN"},{"id":"MEDIUM_COUNTS_BALANCE","amount":636807.0,"currency":"PEN"}],"transactionalflows":{"collections":[{"amount":0,"currency":"USD"}],"payments":[{"amount":0,"currency":"PEN"},{"amount":0,"currency":"USD"}]}},"taxpayer":{"taxpayerType":{"id":"LEGAL_PERSON"}}},"quotations":[{"status":{"id":"REQUESTED","name":"SOLICITADA"},"validityDate":"2018-10-24T12:58:15.421-0500","id":"1473004","version":"1","interestRates":{"effectiveRates":[{"id":"TEA_OF_MODEL","percentage":0.1602},{"id":"MINIMUM_TEA","percentage":0.161},{"id":"SUGGESTED_TEA","percentage":0.175},{"id":"MINIMUM_TEA_OF_MODEL","percentage":0.161},{"id":"SUGGESTED_TEA_OF_MODEL","percentage":0.175},{"id":"TEA_OF_AUTONOMY","percentage":0.160962}]},"comment":"Create quotation request from DWP","product":{"id":"11","requestedAmount":{"amount":400000.0,"currency":"PEN"},"name":"Préstamo Comercial (CP)","guarantee":{"coverage":100,"classification":{"id":"47","name":"SIN_GARANTIA"}},"contractingModality":{"id":"28","name":"Linea Regular"},"term":{"frequency":{"id":"MONTHLY","name":"MES"},"termNumber":11}},"businessAgents":[{"position":{"id":"CZ2","name":"ESPEC PRECIOS BANCA MIN"},"id":"P012677","firstName":"IRMA BEATRIZ","lastName":"COLLANTES","secondLastName":"BOHORQUEZ","workTeam":{"id":"ANA_PRE_BEC","name":"Analista de Precios BEC"},"classification":{"involvements":[{"involvementType":{"id":"ASSIGNED","description":"Usuario asignado a la cotización"}}]}},{"position":{"id":"E0B","name":"ASISTENTE BEC"},"id":"P022023","firstName":"DEYANIRA","lastName":"FERNANDEZ","secondLastName":"MALDONADO","workTeam":{"id":"EJE_BEC","name":"Ejecutivo BEC"},"classification":{"involvements":[{"involvementType":{"id":"REGISTERED","description":"Usuario que registra la cotización"}}]}}],"bank":{"branch":{"id":"0397","name":"BANCA EMPRESAS REPUBLICA DE PANAMA"}},"disbursement":{"status":{"id":"PENDING","description":"PENDIENTE"}},"profitabilityIndicators":[{"id":"PROFITABILITY_FOR_RISK_OF_MODEL_TEA","percentage":0.215},{"id":"PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA","percentage":-0.6303},{"id":"BENEFIT_BEFORE_TAX_OF_OPERATION","percentage":0.0384},{"id":"BENEFIT_BEFORE_TAX_OF_REQUESTED_TEA","percentage":-0.1126},{"id":"BENEFIT_BEFORE_TAX_OF_MINIMUM_TEA","percentage":0.0384}],"liquidityIndicators":[{"id":"SPREAD_MINIMUM_LIMIT","detail":{"percentage":0.0}},{"id":"ADDITIONAL_SPREAD","detail":{"percentage":0.005}},{"id":"MINIMUM_SPREAD","detail":{"percentage":0.005}},{"id":"COMMERCIAL_SPREAD","detail":{"percentage":0.04}},{"id":"SPREAD_OF_OPERATION","detail":{"percentage":0.1237}},{"id":"ADDITIONAL_SPREAD_OF_REQUESTED_TEA","detail":{"percentage":0.005}},{"id":"COMMERCIAL_SPREAD_OF_REQUESTED_TEA","detail":{"percentage":0}},{"id":"MINIMUM_SPREAD_OF_REQUESTED_TEA","detail":{"percentage":-0.1126}},{"id":"SPREAD_OF_REQUESTED_TEA","detail":{"percentage":-0.0273}}],"fees":[{"feeType":{"id":"EXPECTED_LOSS"},"detail":{"percentage":0.063162}},{"feeType":{"id":"FUNDING_COST"},"detail":{"percentage":0.0426}},{"feeType":{"id":"FINANCING_COST_STOCKHOLDER"},"detail":{"percentage":0.0147}},{"feeType":{"id":"FUNDING_COST_ADJUSTED"},"detail":{"percentage":0.0373}},{"feeType":{"id":"EFFICIENCY_COST"},"detail":{"percentage":0.0074}},{"feeType":{"id":"REGULATORY_CAPITAL"},"detail":{"percentage":0.1}},{"feeType":{"id":"ADDITIONAL_CAPITAL"},"detail":{"percentage":0.025}},{"feeType":{"id":"CAPITAL"},"detail":{"amount":50000.0}},{"feeType":{"id":"OPPORTUNITY_COST"},"detail":{"percentage":0.1175}},{"feeType":{"id":"EFFICIENCY_COST_FACTOR"},"detail":{"percentage":0.164}},{"feeType":{"id":"TAX_RATE"},"detail":{"percentage":0.3}}],"model":{"id":"2"},"creationDate":"2018-10-09T12:58:15.399-0500","financialIndicators":[{"id":"TACTICAL_FACTOR","value":"1"},{"id":"FUNDING_COST_TERM","value":"360"},{"id":"FUNDING_COST_DATE","value":"Thu Aug 16 00:00:00 PET 2018"},{"id":"CLUSTER","value":"E1006"},{"id":"COLLECTIVE_FLAG","value":"false"}]}]}}');
				res.setStatusCode(200);
			}
			when 'https://GetQuotationRequest/KO_409/1111?expand=quotations' {
				System.assertEquals('https://GetQuotationRequest/KO_409/1111?expand=quotations', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(409);
			}
			when 'https://GetQuotationRequest/KO_500/1111?expand=quotations' {
				System.assertEquals('https://GetQuotationRequest/KO_500/1111?expand=quotations', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
				res.setStatusCode(500);
			}
			when 'https://ListQuotationRequest/OK?paginationKey=1&pageSize=10&participant.id=26835866&expand=quotations' {
                System.assertEquals('https://ListQuotationRequest/OK?paginationKey=1&pageSize=10&participant.id=26835866&expand=quotations', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"data": [{"id": "283869","status": {"id": "OPEN","name": "ABIERTO"},"participant": {"id": "26835866","identityDocuments": [{"documentType": {"id": "RUC"},"documentNumber": "20601539722"}],"segment": {"id": "EMPRESA PEQUEÑA","name": "EMPRESA PEQUEÑA"},"detail": {"firstName": "CONSORCIO CHUQUIMAL","lastName": "","bankingData": {"adjustedBanking": {"id": "BEC","name": "BEC"}}}},"quotations": [{"status": {"id": "APPROVED","name": "APROBADA"},"approvalDate": "2020-12-07T10:51:25.906-0500","validityDate": "2020-12-22T15:53:13.538+0000","id": "297869","version": "2","interestRates": {"effectiveRates": [{"id": "TEA_OF_MODEL","percentage": 0.0978},{"id": "MINIMUM_TEA","percentage": 0.098},{"id": "SUGGESTED_TEA","percentage": 0.105},{"id": "MINIMUM_TEA_OF_MODEL","percentage": 0.098},{"id": "SUGGESTED_TEA_OF_MODEL","percentage": 0.105},{"id": "FINAL_TEA","percentage": 0.087},{"id": "APPROVED_TEA","percentage": 0.087},{"id": "REQUESTED_TEA","percentage": 0.085},{"id": "ADJUSTED_MODEL_TEA","percentage": 0.0002},{"id": "REQUESTED_ADJUSTED_TEA","percentage": 0},{"id": "APPROVED_ADJUSTED_TEA","percentage": 0}]},"comment": "Petición de evaluación de cotización desde DWP","product": {"id": "11","requestedAmount": {"amount": 250000,"currency": "PEN"},"name": "Préstamo Comercial (CP)","contractingModality": {"id": "7"},"term": {"frequency": {"id": "DAILY","name": "DIA"},"termNumber": 90}},"businessAgents": [{"id": "P023210","firstName": "RENZO","lastName": "LOLI","secondLastName": "OLIVA","classification": {"involvements": [{"involvementType": {"id": "ASSIGNED","description": "Usuario asignado a la cotización"}}]}},{"id": "P023210","firstName": "RENZO","lastName": "LOLI","secondLastName": "OLIVA","classification": {"involvements": [{"involvementType": {"id": "REGISTERED","description": "Usuario que registra la cotización"}}]}},{"id": "P012677","firstName": "IRMA BEATRIZ","lastName": "COLLANTES","secondLastName": "BOHORQUEZ","classification": {"involvements": [{"involvementType": {"id": "APPROVER","description": "Usuario que aprobó la cotización"}}]}}],"bank": {"branch": {"id": "0949"}},"disbursement": {"status": {"id": "PENDING","description": "PENDIENTE"}},"profitabilityIndicators": [{"id": "PROFITABILITY_FOR_RISK_OF_MODEL_TEA","percentage": 0.1915},{"id": "PROFITABILITY_FOR_RISK_OF_APPROVED_TEA","percentage": 0.1287},{"id": "PROFITABILITY_FOR_RISK_OF_REQUESTED_TEA","percentage": 0.1287}],"fees": [{"feeType": {"id": "EXPECTED_LOSS"},"detail": {"percentage": 0.018025}},{"feeType": {"id": "FUNDING_COST"},"detail": {"percentage": 0.0342}},{"feeType": {"id": "FINANCING_COST_STOCKHOLDER"},"detail": {"percentage": 0.0164}},{"feeType": {"id": "EFFICIENCY_COST"},"detail": {"percentage": 0}},{"feeType": {"id": "REGULATORY_CAPITAL"},"detail": {"percentage": 0.1}},{"feeType": {"id": "ADDITIONAL_CAPITAL"},"detail": {"percentage": 0.0228}},{"feeType": {"id": "CAPITAL"},"detail": {"percentage": 30700}},{"feeType": {"id": "OPPORTUNITY_COST"},"detail": {"percentage": 0.1336}},{"feeType": {"id": "EFFICIENCY_COST_FACTOR"},"detail": {"percentage": 0}},{"feeType": {"id": "TAX_RATE"},"detail": {"percentage": 0.3}},{"feeType": {"id": "FUNDING_COST_ADJUSTED"},"detail": {"percentage": 0.03}}],"creationDate": "2020-12-07T10:37:55.871-0500","lastUpdateDate": "2020-12-07T15:53:13.490+0000","indicators": [{"id": "QUOTATION_MIGRATED","value": "0"},{"id": "SEGMENT_NAME","value": "EMPRESA PEQUEÑA"},{"id": "SEGMENT_CODE","value": "30400"},{"id": "ENTAILMENT","value": "No Vinculado"},{"id": "RATING","value": ""},{"id": "PRINCIPAL_MANAGER_NAME","value": "GERARDO ANGEL PORTOCARRERO FERNANDEZ DAV"},{"id": "PRINCIPAL_MANAGER_CODE","value": "001855"},{"id": "BUSINESS_LINE_CODE","value": "45207"},{"id": "RORC_CLIENT_VARIATION","value": "-4.512537"},{"id": "RORC_CLIENT_STOCK_PERIOD","value": "2019-12-01 00:00:00.0"},{"id": "RAROEC_CLIENT_STOCK_PERIOD","value": "2019-12-01 00:00:00.0"},{"id": "LOST_FINANCIAL_MARGIN","value": "0"},{"id": "RORC_OPERATION_LOST_FINANCIAL_MARGIN","value": "-4043.818149"},{"id": "RAROEC_OPERATION_LOST_FINANCIAL_MARGIN","value": "-5727.580006"},{"id": "RORC_CLIENT_LOST_FINANCIAL_MARGIN","value": "-7055.734225"},{"id": "RORC_CLIENT_STOCK_MONTH_ACTIVE","value": "4.7"},{"id": "RAROEC_CLIENT_STOCK_MONTH_ACTIVE","value": "4.7"},{"id": "RORC_THRESHOLD_CLIENT","value": "0.078"},{"id": "RAROEC_THRESHOLD_OPERATION","value": "0.094"},{"id": "RORC_CLIENT_POST","value": "0.187463"},{"id": "RAROEC_CLIENT_POST","value": "0.336586"},{"id": "RORC_OPERATION","value": "0.141466"},{"id": "RAROEC_OPERATION","value": "0.256075"},{"id": "PASS_THRESHOLD_RORC","value": "1"},{"id": "PASS_THRESHOLD_RAROEC_OPERATION","value": "1"},{"id": "PASS_THRESHOLD","value": "1"}]}],"lastUpdateDate": "2020-12-07T15:53:13.480+0000"}],"pagination": {"links": {"first": "/quotations/v1/requests?participant.id=26835866&expand=quotations","last": "/quotations/v1/requests?participant.id=26835866&expand=quotations&paginationKey=LAST","next": "/quotations/v1/requests?participant.id=26835866&expand=quotations&paginationKey=2&pageSize=20"},"totalPages": 6,"totalElements": 117,"pageSize": 20}}');
				res.setStatusCode(200);
			}
			when 'https://CreateNonClient/204/v1/non-businesses' {
				System.assertEquals('https://CreateNonClient/204/v1/non-businesses', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setHeader('location', 'nonCLient/P00000001');
				res.setStatusCode(204);
			}
			when 'https://CreateNonClient/400/v1/non-businesses' {
				System.assertEquals('https://CreateNonClient/400/v1/non-businesses', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setHeader('responsewarningdescription', 'YA EXISTE EL NO CLIENTE');
				res.setStatusCode(400);
			}
			when 'https://ListClients/200/v0/businesses?identityDocument.documentType.id=RUC&identityDocument.documentNumber=20876543262' {
				System.assertEquals('https://ListClients/200/v0/businesses?identityDocument.documentType.id=RUC&identityDocument.documentNumber=20876543262', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"data": [{"businessDocuments": [{"businessDocumentType": {"id": "RUC","name": "R.U.C."},"documentNumber": "20978633995"}],"id": "77780583","formation": {"date": "1980-10-14","country": {"id": "PER","name": "PERU"},"businessType": {}},"membershipDate": "2007-08-14","legalName": "HIPERTEHUELCHE","businessGroup": {"id": "M02","name": "PERS.JURID.COMERCIA."},"bank": {"branch": {"id": "0102","name": "OF.CALLAO"}},"employeesNumber": 0,"annualSales": {"amount": 0,"currency": "PEN"},"economicActivity": {"id": "00000000112","name": "CULT.HORTALIZAS Y LEGUMBRES"}}]}');
				res.setStatusCode(200);
			}
			when 'https://ListClients/409/v0/businesses?identityDocument.documentType.id=RUC&identityDocument.documentNumber=20876543262' {
				System.assertEquals('https://ListClients/409/v0/businesses?identityDocument.documentType.id=RUC&identityDocument.documentNumber=20876543262', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setBody('{"version": 1,"severity": "FATAL","http-status": 409,"error-code": "PEE2008","error-message": "PERSONA INEXISTENTE","consumer-request-id": "2158b315-9712-4d8b-86fa-106c08ae9d7b","system-error-code": "functionalError","system-error-description": "Error funcional por defecto.","system-error-cause": "PEE2008: CONSULTA SOLO PARA PERSONA JURIDICA"}');
				res.setStatusCode(409);
			}
			when 'https://ListClients/500/v0/businesses?identityDocument.documentType.id=RUC&identityDocument.documentNumber=20876543262' {
				System.assertEquals('https://ListClients/500/v0/businesses?identityDocument.documentType.id=RUC&identityDocument.documentNumber=20876543262', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
				res.setStatusCode(500);
			}
			when 'https://ListNonClient/200' {
				System.assertEquals('https://ListNonClient/200', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"data": [{"id": "PE0011000009126","legalName": "BBVA SFSC COMPANY","creationDate": "2020-07-21T00:00:00.0-0500","businessDocuments": {"documentNumber": "20987654366","businessDocumentType": {"id": "RUC"}}}]}');
				res.setStatusCode(200);
			}
			when 'https://ListNonClient/400' {
				System.assertEquals('https://ListNonClient/400', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setStatusCode(400);
			}
			when 'https://ListNonClient/500' {
				System.assertEquals('https://ListNonClient/500', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setStatusCode(500);
			}
			when 'https://ModifyNonClient/204/v1/non-businesses/P0234234234' {
				System.assertEquals('https://ModifyNonClient/204/v1/non-businesses/P0234234234', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setStatusCode(204);
			}
			when 'https://ModifyNonClient/500/v1/non-businesses/P0234234234' {
				System.assertEquals('https://ModifyNonClient/500/v1/non-businesses/P0234234234', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setStatusCode(500);
			}
			when 'https://ModifyNonClient/400/v1/non-businesses/P0234234234' {
				System.assertEquals('https://ModifyNonClient/400/v1/non-businesses/P0234234234', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setStatusCode(400);
			}
			when 'https://CreateNonBusinessContact/204/20876543265/contacts' {
				System.assertEquals('https://CreateNonBusinessContact/204/20876543265/contacts', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setHeader('location', 'contact/00001');
				res.setBody('{"firstName": "JUAN MANUEL","lastName": "RODRIGUEZ","roleType": {"id":"OTHERS"},"contactDetails": [{"isPreferential":true,"contact":{"receivesNotifications":true,"number":"987654327","contactDetailType":"MOBILE"}},{"contact":{"receivesNotifications":true,"contactDetailType":"EMAIL","address":"test@gmail.com"}}]}');
				res.setStatusCode(204);
			}
			when 'https://CreateNonBusinessContact/500/20876543265/contacts' {
				System.assertEquals('https://CreateNonBusinessContact/500/20876543265/contacts', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setHeader('location', 'contact/00001');
				res.setBody('{"firstName": "JUAN DIEGO","lastName": "MENDOZA","roleType": {"id":"OTHERS"},"contactDetails": [{"isPreferential":true,"contact":{"receivesNotifications":true,"number":"987654327","contactDetailType":"MOBILE"}},{"contact":{"receivesNotifications":true,"contactDetailType":"EMAIL","address":"test@gmail.com"}}]}');
				res.setStatusCode(500);
			}
			when 'https://ModifyNonBusinessContact/204/20876543265/contacts/00001' {
				System.assertEquals('https://ModifyNonBusinessContact/204/20876543265/contacts/00001', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"firstName": "PEDRO DIEGO","lastName": "GARCÍA","roleType": {"id":"OTHERS"},"contactDetails": [{"isPreferential":true,"contact":{"receivesNotifications":true,"number":"987654327","contactDetailType":"MOBILE"}},{"contact":{"receivesNotifications":true,"contactDetailType":"EMAIL","address":"test@gmail.com"}}]}');
				res.setStatusCode(204);
			}
			when 'https://ModifyNonBusinessContact/500/20876543265/contacts/00001' {
				System.assertEquals('https://ModifyNonBusinessContact/500/20876543265/contacts/00001', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
				res.setBody('{"firstName": "EL","lastName": "BRAVO","roleType": {"id":"OTHERS"},"contactDetails": [{"isPreferential":true,"contact":{"receivesNotifications":true,"number":"987654327","contactDetailType":"MOBILE"}},{"contact":{"receivesNotifications":true,"contactDetailType":"EMAIL","address":"test@gmail.com"}}]}');
				res.setStatusCode(500);
			}
			when 'https://DeleteNonBusinessContact/204/20876543265/contacts/00001' {
				System.assertEquals('https://DeleteNonBusinessContact/204/20876543265/contacts/00001', req.getEndpoint());
				System.assertEquals('DELETE', req.getMethod());
				res.setBody('{"firstName": "MARTIN","lastName": "DIAZ","roleType": {"id":"OTHERS"},"contactDetails": [{"isPreferential":true,"contact":{"receivesNotifications":true,"number":"987654327","contactDetailType":"MOBILE"}},{"contact":{"receivesNotifications":true,"contactDetailType":"EMAIL","address":"test@gmail.com"}}]}');
				res.setStatusCode(204);
			}
			when 'https://DeleteNonBusinessContact/500/20876543265/contacts/00001' {
				System.assertEquals('https://DeleteNonBusinessContact/500/20876543265/contacts/00001', req.getEndpoint());
				System.assertEquals('DELETE', req.getMethod());
				res.setBody('{"firstName": "MICHEL","lastName": "MENDOZA","roleType": {"id":"OTHERS"},"contactDetails": [{"isPreferential":true,"contact":{"receivesNotifications":true,"number":"987654327","contactDetailType":"MOBILE"}},{"contact":{"receivesNotifications":true,"contactDetailType":"EMAIL","address":"test@gmail.com"}}]}');
				res.setStatusCode(500);
			}
            when 'https://CalculateCommission/OK' {
                System.assertEquals('https://CalculateCommission/OK', req.getEndpoint());
				System.assertEquals('POST', req.getMethod());
                res.setBody('{"data":{"fixedFee":{"id":"CO223"},"calculatedFee":{"id":"382","version":1,"calculatedAmount":{"amount":100000,"currency":"PEN"}},"rates":{"totalRates":{"amount":0.03,"currency":"USD"},"itemizeRates":[{"rateUnit":{"unitRateType":"PERCENTAGE","percentage":0.03}}]}}}');
                res.setStatusCode(200);
            }
            when 'https://ListCommissionRequests/OK' {
                System.assertEquals('https://ListCommissionRequests/OK', req.getEndpoint());
				System.assertEquals('GET', req.getMethod());
                res.setBody('{"data":[{"id":"CO239","name":"Por Liquidación Anticipada","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":false,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":5,"name":"SUGGESTED_RATE"}],"maximumValue":{"currency":"PEN"},"minimumValue":{"currency":"PEN"},"isTermIncluded":true,"paymenMethod":{"frequency":{"id":"MONTHLY"}},"term":{"frequency":{"id":"MONTHLY"},"number":12},"additionalAmount":{},"questionnaire":{"id":"CU0022","questions":[{"id":"2","outputType":"YES_OR_NOT","description":"El Plazo es mayor a 12?","parentId":"1","parentOutputType":"YES_OR_NOT","parentAnswerActivator":"SI"},{"id":"1","outputType":"YES_OR_NOT","description":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?"}]}},{"id":"CO235","name":"Por Liquidación Anticipada","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":false,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":5,"name":"SUGGESTED_RATE"}],"maximumValue":{"currency":"PEN"},"minimumValue":{"currency":"PEN"},"isTermIncluded":true,"paymenMethod":{"frequency":{"id":"MONTHLY"}},"term":{"frequency":{"id":"MONTHLY"},"number":12},"additionalAmount":{},"questionnaire":{"id":"CU0022","questions":[{"id":"2","outputType":"YES_OR_NOT","description":"El Plazo es mayor a 12?","parentId":"1","parentOutputType":"YES_OR_NOT","parentAnswerActivator":"SI"},{"id":"1","outputType":"YES_OR_NOT","description":"El tipo de prestamo es Cancelación Anticipada, Amortización Parcial o Prepago de cuotas?"}]}},{"id":"CO229","name":"Comisión de Estructuración","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":true,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":1,"name":"SUGGESTED_RATE"}],"maximumValue":{"currency":"PEN"},"minimumValue":{"amount":850,"currency":"PEN"},"isTermIncluded":false,"paymenMethod":{},"term":{},"additionalAmount":{}},{"id":"CO217","name":"Gestión Operativa","product":{"id":"5","modality":{"id":"8"}},"currency":"PEN","isNegotiable":true,"isRORCApplicable":true,"calculationType":"PERCENTAGE","settledValues":[{"settledValueType":"PERCENTAGE","percentage":20,"name":"SUGGESTED_RATE"}],"maximumValue":{"amount":700,"currency":"PEN"},"minimumValue":{"amount":120,"currency":"PEN"},"isTermIncluded":false,"paymenMethod":{},"term":{},"additionalAmount":{}}]}');
                res.setStatusCode(200);
            }
			when else {
				//nothing
			}
		}
		return res;
	}
}