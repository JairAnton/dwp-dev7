@isTest
global class Integration_MockGenerator implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        System.debug(req);
        
        switch on req.getEndpoint(){
            when 'https://validation/ok' {
                System.assertEquals('https://validation/ok', req.getEndpoint());
                System.assertEquals('POST', req.getMethod());
                res.setHeader('access_token', '**************sessionToken*************');
                res.setHeader('tsec', '**************sessionToken*************');
                res.setBody('{}');
                res.setStatusCode(200);
            }
            when 'https://CompromiseProducts/ok/v0/products/3/compromise-products' {
                System.assertEquals('https://CompromiseProducts/ok/v0/products/3/compromise-products', req.getEndpoint()); 
                System.assertEquals('GET', req.getMethod());
                res.setBody('{"data":[{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"10","name":"INCR. SM VISTA + AHORRO\\t"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"11","name":"VISANET"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"12","name":"PAGO HABERES"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"13","name":"PAGO PROVEEDORES"},{"committableData":[{"currency":"PEN","description":"IMPORTE SOLES","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60},{"currency":"USD","description":"IMPORTE USD","discounts":[{"item":{"id":"TEA"},"percentage":0}],"unitType":"AMOUNT","validityDays":60}],"id":"14","name":"RECAUDOS"}]}');
                res.setStatusCode(200);
            }
            when 'https://ProductsQuote/ok'{
                System.assertEquals('https://CompromiseProducts/ok/v0/products/3/compromise-products', req.getEndpoint()); 
                System.assertEquals('GET', req.getMethod());
                res.setBody('{}');
                res.setStatusCode(200);
            }
            when 'https://SimulateRate/ok'{
                System.assertEquals('https://SimulateRate/ok', req.getEndpoint()); 
                System.assertEquals('POST', req.getMethod());
                res.setBody('{"data":{"calculationType":{"id":"UNIQUE"},"model":{"id":"2"},"businessAgent":{},"participant":{"identityDocuments":[{"documentType":{}}],"bank":{},"segment":{"subSegment":{"partitions":[]}},"delinquency":{"behaviorDebts":{"tacticalVariable":[]}},"strategicRelationships":[],"riskLevel":[]},"product":{"requestedAmount":{},"term":{},"guarantee":{}},"summary":[{"calculationId":"173380","financialIndicators":[{"id":"CLUSTER","value":"E1014"},{"id":"COLLECTIVE_FLAG","value":"false"},{"id":"TACTICAL_FACTOR","value":"1"}],"interestRates":{"effectiveRates":[{"id":"ADJUSTED_MODEL_TEA","percentage":0.00020},{"id":"MINIMUM_TEA","percentage":0.154},{"id":"SUGGESTED_TEA","percentage":0.165}]},"fees":[{"feeType":{"id":"EXPECTED_LOSS"},"detail":{"percentage":0.063162}},{"feeType":{"id":"FUNDING_COST"},"detail":{"percentage":0.0353}},{"feeType":{"id":"EFFICIENCY_COST"},"detail":{"percentage":0.0074}},{"feeType":{"id":"FINANCING_COST_STOCKHOLDER"},"detail":{"percentage":0.0147}},{"feeType":{"id":"FUNDING_COST_ADJUSTED"},"detail":{"percentage":0.0309}},{"feeType":{"id":"REGULATORY_CAPITAL"},"detail":{"percentage":0.1}},{"feeType":{"id":"ADDITIONAL_CAPITAL"},"detail":{"percentage":0.025}},{"feeType":{"id":"CAPITAL"},"detail":{"amount":2931.88,"currency":"PEN"}}],"liquidityIndicators":[{"id":"ADDITIONAL_SPREAD","detail":{"percentage":0.005}},{"id":"MINIMUM_SPREAD","detail":{"percentage":0.005}},{"id":"COMMERCIAL_SPREAD","detail":{"percentage":0.04}}]}]}}');
                res.setStatusCode(200);
            }
            when 'https://SimulateRate/ko'{
                System.assertEquals('https://SimulateRate/ko', req.getEndpoint()); 
                System.assertEquals('POST', req.getMethod());
                res.setBody('{"version":1,"severity":"FATAL","http-status":409,"error-code":"functionalError","error-message":"null","consumer-request-id":"cb034d49-fe9f-4ad4-bb05-ef0ae7cbc505","system-error-code":"functionalError","system-error-description":"Default functional error."}');
                res.setStatusCode(409);
            }
            when else {
                //nothing
            }
        }
        System.debug(res);
        return res;
        
    }
}