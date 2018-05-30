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
        var OpportunityId = component.get("v.recordId");

        var action = component.get("c.setFormalization");
        var sanAction = component.get("v.Action");
        var body = component.get("v.comments");
        action.setParams({
            "OpportunityId" : OpportunityId,
            "Action" : sanAction,
            "Body"  :  body
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.errMessage",response.getReturnValue());
                helper.handleShowToast(component,event,helper);
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
            else if (state === "NoComments") {
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Success!",
                message: "Cotizacion Terminada",
                type: "success"
            });
        toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
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
