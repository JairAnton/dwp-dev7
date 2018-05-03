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
    close: function(cmp, event, helper) {
    	$A.util.addClass(cmp.find('divToast'), "slds-hide");
	},
	restSaveRecord: function(component, event, helper) {
    	var OppName = component.find("txtlblOpportunityName");
    	var AccountId = component.get("v.recordId");
	    var closeDate=component.find("dtCloseDate").get("v.value");
	    var planningDate=component.find("dtPlanningDate").get("v.value");
	    var probability=component.find("selSuccessPro").get("v.value");

	    var Amount=component.find("txtAmount").get("v.value");
	    var CurrencyIsoCode=component.find("selCurrency").get("v.value");
	    var Comment=component.find("txtComments").get("v.value");
	    var errMsg=false;
	    var now = new Date();

		if(OppName.get("v.validity").valid) {
			
    		//var OppName = component.find("txtlblOpportunityName").get("v.value");
	        // continue processing
	        if(!$A.util.isEmpty(closeDate) && !$A.util.isEmpty(planningDate))
	        {
	        	
	        	if(closeDate<planningDate)
	        	{
	        		component.set("v.errMessage",component.get("v.lblCloseDate")+" "+ $A.get("$Label.c.DateHigherThan")+" "+component.get("v.lblPlanningDate"));
	        		helper.handleShowToast(component,event,helper);   
	        		errMsg=true;
	        	}
	        	
	        }
	       
	        if(!$A.util.isEmpty(closeDate))
	        {
	        	if(closeDate<now)
	        	{
	        		component.set("v.errMessage",component.get("v.lblCloseDate")+ $A.get("$Label.c.DateHigherThan")+ $A.get("$Label.c.Today"));
	        		helper.handleShowToast(component,event,helper);   
	        		errMsg=true;
	        	}
	        }
	        
	        if(!$A.util.isEmpty(planningDate))
	        {
	        	if(planningDate<now)
	        	{
	        		component.set("v.errMessage",component.get("v.lblPlaningDate")+ $A.get("$Label.c.DateHigherThan")+ $A.get("$Label.c.Today"));
	        		helper.handleShowToast(component,event,helper);   
	        		errMsg=true;
	        	}
	        }
	        if(!errMsg)
	        {   	 
	        		event.getSource().set("v.disabled", true);
	        		
	        		var action =  component.get("c.InsertOpportunity");           	            	            
	                action.setParams({
	                    "OpportunityName":OppName.get("v.value"),  
	                    "AccountId":AccountId,
	                    "cAmount": $A.util.isEmpty(Amount) ? 0 : Amount,
	                    "CloseDate":closeDate,
	                    "PlanningDate":planningDate,
	                    "cCurrencyIsoCode": CurrencyIsoCode,
	                    "cComment": Comment,
	                    "cProbability": probability
	                });
	                action.setCallback(this, function(response) {
	                  
	                    var state = response.getState();
	                    if (state === "SUCCESS") {      
	                      
	                       var result = response.getReturnValue();   
	                       component.set("v.recordIdOpp",result);
	                       helper.close(component, event, helper);
	                       helper.navigateToRecord(component, event, helper);
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
	        	}     
	    } else {
	    	
	        OppName.showHelpMessageIfInvalid();
	    }
	},
	navigateToRecord : function(component, event, helper) {
         var navEvent = $A.get("e.force:navigateToSObject");
         navEvent.setParams({
              recordId: component.get("v.recordIdOpp"),
              slideDevName: "detail"
         });
         navEvent.fire(); 
    }
})