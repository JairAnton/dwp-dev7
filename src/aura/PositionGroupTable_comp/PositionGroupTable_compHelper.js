({
	bringData : function(cmp, evt, helper) {
        var action = cmp.get("c.getAccountBBVAInformation");
        var AccountId = cmp.get("v.recordId");
        
        action.setParams({
            "AccountId" : AccountId           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
            	     
                if(response.getReturnValue()!=null)
                {                   
                	
                    cmp.set("v.rows", response.getReturnValue());
                }
            }
        });        
        $A.enqueueAction(action);
       
	},
})