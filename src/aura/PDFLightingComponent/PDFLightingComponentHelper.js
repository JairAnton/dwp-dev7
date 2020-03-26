({
    closeMe : function(component, event) {
		component.destroy();
	},
    reasignCase : function(component, event, helper) {
        var action = component.get('c.reasignCase');
        action.setParams({"recordId" : component.get('v.inputAttributes.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(!res.isError) {
                    helper.msgAndClose(component, event, helper, res.msgSuccess, 'success', true);
                } else {
                    helper.msgAndClose(component, event, helper, res.msgError, '', true);
                }
            } else {
                helper.msgAndClose(component, event, helper, false, false, true);
            }
        });
        $A.enqueueAction(action);
    },
    PDF : function(component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var save_action = component.get("c.PDF_formalization");
        save_action.setParams({recordId : inputObject.recordId});
        save_action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var attachId = response.getReturnValue();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": attachId,
                    "slideDevName": "detail"
                });
                navEvt.fire();
                $A.get('e.force:refreshView').fire();
                component.destroy();
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(save_action);
    },
    msgAndClose : function(component, event, helper, message, type, close) {
        var toastEvent = $A.get("e.force:showToast");
        var message = (message ? message : $A.get("$Label.c.Dwp_msgGenericError"));
        toastEvent.setParams({
            "message": message,
            "type": (type ? type : "error")
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        if(close) {
            this.destroyCmp(component, event, helper);
        }
    }
})