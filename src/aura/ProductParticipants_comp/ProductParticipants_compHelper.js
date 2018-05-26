({
    handleShowToast: function(cmp, event, helper) {
        $A.util.removeClass(cmp.find('divToast'), "slds-hide");

        window.setTimeout(
          $A.getCallback(function() {
            if (cmp.isValid()) {
              $A.util.addClass(cmp.find('divToast'), "slds-is-relative");
            }
          }),0
        );
    },    
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

                var action2 = cmp.get("c.getParticipantDataByProduct");                
                
                action2.setParams({            
                    "IdOpportunity" : OpportunityId,
                    "IdProduct" : ProductId
                });
                action2.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        cmp.set("v.rowsP", response.getReturnValue());
                    }
                });        
                $A.enqueueAction(action2);
            }
        });        
        $A.enqueueAction(action);
        cmp.set("v.refreshTable",true);
	},
    deleteParticipant : function(cmp, evt, helper) {
        if(!evt.getSource().get("v.name"))
        {
            if(confirm("¿Desea continuar con la eliminación del registro?"))
            {
                var action = cmp.get("c.deleteParticipantDataByProduct");       
                action.setParams({
                    "IdProductParticipant" : evt.getSource().get("v.value")
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
        }
    }

})