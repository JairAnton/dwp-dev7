({
	doInit : function(component, event, helper) {
        var inputAttributes = component.get("v.inputAttributes");
		var action = component.get("c.reasignCase");
        action.setParams({
            "caseId" : inputAttributes.recordId
        });
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            var oppId;
            if(state === 'SUCCESS') {
                var res = response.getReturnValue();
                if(!res.isError) {
                    oppId=res.oppId;
                    toastEvent.setParams({
                        "message": "¡Te autoasignaste esta petición exitosamente!",
                        "type": "success"
                	});
                } else {
                   toastEvent.setParams({
                        "message": res.msgError,
                        "type": "error"
                    });
                }
            } else {
                toastEvent.setParams({
                    "message": "$Label.Dwp_msgGenericError",
                    "type": "error"
                });
            }
            component.set("v.showSpinner", false);
            toastEvent.fire();
            if(oppId != null) {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": oppId
                });
                navEvt.fire();
            }
            helper.destroyCmp(component, event, helper);
        });
        $A.enqueueAction(action);
	}
    
})