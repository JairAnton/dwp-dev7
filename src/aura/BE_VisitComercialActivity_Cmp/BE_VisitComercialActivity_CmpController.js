({
	doInit : function(cmp, event, helper){
		var accountId = cmp.get("v.recordId");
        var relatedVisits = cmp.get("c.getVisitInfo");
        relatedVisits.setParams({
    		"accId" : accountId
    	});
        relatedVisits.setCallback(this, function(response){
    		if(response.getState() === "SUCCESS"){
                var resultData = JSON.parse(response.getReturnValue());
            	cmp.set("v.data", resultData);
            }
        });
         $A.enqueueAction(relatedVisits);
	}
})
