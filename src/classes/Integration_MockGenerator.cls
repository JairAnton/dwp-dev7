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
            when else {
                //nothing
            }
        }
        System.debug(res);
        return res;

    }
}