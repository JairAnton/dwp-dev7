({
	bringData : function(cmp, evt, helper) {
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

                var action2 = cmp.get("c.getGuaranteeDataByProduct");                
                
                action2.setParams({            
                    "IdOpportunity" : OpportunityId,
                    "IdProduct" : ProductId
                });
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set("v.rows", response.getReturnValue());
                    }
                });        
                $A.enqueueAction(action2);
            }
        });        
        $A.enqueueAction(action);
        cmp.set("v.refreshTable",true);
	},
    deleteGuarantee : function(cmp, evt, helper) {
       var action = cmp.get("c.deleteGuaranteeDataByProduct");
        action.setParams({
            "IdProductGuarantee" : evt.getSource().get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                                
                cmp.set("v.refreshTable",false);               
                helper.bringData(cmp, evt, helper); 
            }
        });        
        $A.enqueueAction(action);
    }

})