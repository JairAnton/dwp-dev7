({
	init : function(component, event, helper) {		
		//Static Labels
		component.set("v.lblTitle", $A.get("$Label.c.New_Opportunity"));
		component.set("v.lblAccountName", $A.get("$Label.c.AccountName"));
		component.set("v.lblOpportunityName", $A.get("$Label.c.OpportunityName"));
		component.set("v.lblPlanningDate", $A.get("$Label.c.PlannigDate"));
		component.set("v.lblCloseDate", $A.get("$Label.c.CloseDate"));
		component.set("v.lblAmount", $A.get("$Label.c.Amount"));
		component.set("v.lblCurrency", $A.get("$Label.c.Currency"));
		component.set("v.lblComments", $A.get("$Label.c.Comments"));	
		component.set("v.lblProbability", $A.get("$Label.c.Probability"));
		component.set("v.lblSave", $A.get("$Label.c.Save"));
		component.set("v.lblCancel", $A.get("$Label.c.Cancel"));


		var AccountId = component.get("v.recordId");
		var action =  component.get("c.getAccountName");           	            	            
		action.setParams({  
	                    "IdAccount":AccountId
	    });
	    action.setCallback(this, function(response) {
	                  
	    	var state = response.getState();
	    	if (state === "SUCCESS") {      
	                      
	                       var result = response.getReturnValue();   
	                       component.set("v.AccountName",result);
	                      
	    	}
	        else if (state === "INCOMPLETE") {
	                    	event.getSource().set("v.disabled", false);
	                       	component.set("v.errMessage","Error al ");
	                        helper.handleShowToast(component,event,helper);   
	        }
	        else if (state === "ERROR") {
	                    	
	                    	// var result = response.getReturnValue();
	                    	event.getSource().set("v.disabled", false);  
	                    	var errors = response.getError();
	            if (errors) {
	                if (errors[0] && errors[0].message) 
	                {	                                
	                            	component.set("v.errMessage","Error:"+errors[0].message );
	                }
	                else
	                {
	                    component.set("v.errMessage","Error:"+errors[0].message );
	                }
	            } else {                    
	                 component.set("v.errMessage","Unknown error");
	            }	                        
	                        helper.handleShowToast(component,event,helper);   
	         }
	    });        
	    $A.enqueueAction(action);     
	},
	 toggleDialog : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    cSaveAction: function(component, event, helper) {
	    helper.close(component, event, helper);
	    helper.restSaveRecord(component, event, helper);
    }

	
})