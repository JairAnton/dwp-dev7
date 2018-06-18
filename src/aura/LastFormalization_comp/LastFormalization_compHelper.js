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
	   	var inputObject = cmp.get('v.inputAttributes');
	   	cmp.set('v.recordId',inputObject.recordId);
        var OpportunityId = cmp.get("v.recordId");
	},
	Actions : function(component, event, helper) {
         var bValid=component.find("txtContract").get("v.validity").valid;
        
        if(bValid==='true');
        {
         
            
            var OpportunityId = component.get("v.recordId");
            var action = component.get("c.setLastFormalization");
            var sanAction = component.get("v.Action");
            var body = component.find("txtComments").get("v.value");
            var ContractNumber = component.find("txtContract").get("v.value");
           
                action.setParams({
                    "OpportunityId" : OpportunityId,
                    "Action" : sanAction,
                    "Body"  :  body,
                    "ContractNumber" : ContractNumber
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                       // component.set("v.errMessage",response.getReturnValue());
                        //helper.handleShowToast(component,event,helper);
                        if(response.getReturnValue()=="true")
                            helper.navigateToRecord(component, event, helper);

                    }
                    else if (state === "INCOMPLETE") {
                        component.set("v.errMessage",response.getReturnValue());
                        helper.handleShowToast(component,event,helper);
                                   
                    }
                    else if (state === "ERROR") {
                        component.set("v.errMessage",response.getReturnValue());
                        helper.handleShowToast(component,event,helper);
                    }
                    
                });
                $A.enqueueAction(action);
          
        }
    },
    navigateToRecord : function(component, event, helper) {
         var navEvent = $A.get("e.force:navigateToSObject");
         navEvent.setParams({
              recordId: component.get("v.recordId"),
              slideDevName: "SEGUIMIENTO"
         });
         navEvent.fire();
    }
 
 
})