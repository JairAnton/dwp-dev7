({
    productUnit: function (component, event, helper) {
        var action = component.get("c.sendProductUnitSgof");
        action.setParams({ "recordId": component.get("v.inputAttributes.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var error = res.isError ? "error" : "success";
                helper.msgAndClose(component, event, helper, res.msg, error, true);
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
    },
    msgAndClose: function (component, event, helper, message, type, close) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": (message ? message : $A.get("$Label.c.Dwp_msgGenericError")),
            "type": (type ? type : "error")
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        if (close) {
            this.destroyCmp(component, event, helper);
        }
    }
})
