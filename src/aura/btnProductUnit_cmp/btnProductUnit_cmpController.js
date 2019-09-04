({
	doInit : function(component, event, helper) {
		var action=component.get("c.sendProductUnit");
        action.setParams({"oppId" : component.get("v.inputAttributes.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                var error = res.isError ? "error" : "success";
                toastEvent.setParams({
                    "message": res.msg,
                    "type": error
        		});
            } else {
                toastEvent.setParams({
                    "message": "$Label.Dwp_msgGenericError",
                    "type": "error"
                });
            }
            toastEvent.fire();
            $A.get('e.force:refreshView').fire();
            helper.destroyCmp(component, event, helper);
        });
        $A.enqueueAction(action);
	}

})
