({
	   bringData : function(cmp, evt, helper) {
	   	var inputObject = cmp.get('v.inputAttributes');  
	   	cmp.set('v.recordId',inputObject.recordId);	   	
        var action = cmp.get("c.getIdProductByOpportunity");
        var OpportunityId = cmp.get("v.recordId");
        var ProductId;
        action.setParams({
            "IdOpportunity" : OpportunityId           
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                       
                
                ProductId=response.getReturnValue()[0].Product2Id;
                cmp.set('v.ProductId',ProductId);                

                var action2 = cmp.get("c.getParticipantDataByProduct");                
                
                action2.setParams({            
                    "IdOpportunity" : OpportunityId,
                    "IdProduct" : ProductId
                });
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                    	alert('ok');
                        cmp.set("v.rowsP", response.getReturnValue());
                    }
                });        
                $A.enqueueAction(action2); 
            }
        });        
        $A.enqueueAction(action);
    
	}

})