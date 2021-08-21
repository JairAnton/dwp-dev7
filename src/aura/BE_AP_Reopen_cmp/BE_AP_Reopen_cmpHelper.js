({
    closeMe: function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    doContinue: function(component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.reopenAPValidated");
        action.setParams({
            "recordId" : inputObject.recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result) {
                    helper.showToast("Success", "El plan de cuenta ha sido reabierto con éxito! Ahora puede editarlo nuevamente.", "Success");
                } else {
                    helper.showToast("Error", "El plan de cuenta ha sido reabierto con éxito! Ahora puede editarlo nuevamente.", "Error");
                }
            } else {
                helper.showToast("Error", "El plan de cuenta no pudo ser reabierto con exito, inténtelo nuevamente.", "Error");
            }
            helper.closeMe(component, event);
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
    },
    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({"title": title, "message": message, "type": type});
        toastEvent.fire();
    }
})
