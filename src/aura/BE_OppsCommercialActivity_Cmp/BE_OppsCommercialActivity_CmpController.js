({
	doInit : function(cmp, event, helper) {
		var accountId = cmp.get('v.recordId');
        var relatedOpps = cmp.get('c.getOppInfo');
        relatedOpps.setParams({
    		'accId' : accountId
    	});

        relatedOpps.setCallback(this, function(response) {
            console.log("estado cintillo de oportunidades"+response.getState());
    		if(response.getState() === 'SUCCESS'){
                var resultData = JSON.parse(response.getReturnValue());
            	cmp.set('v.data', resultData);
            }
        });
         $A.enqueueAction(relatedOpps);
	}
})