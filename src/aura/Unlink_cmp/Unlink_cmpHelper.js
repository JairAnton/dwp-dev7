({
    cancel: function (component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    unlink: function (component, event) {
        var inputObject = component.get('v.inputAttributes');
        var action = component.get('c.unlink');
        var msgUnlinked = $A.get("$Label.c.msgUnlinkedSIO");
        var msgEmptyAudit = $A.get("$Label.c.msgEmptyAudit");
        action.setParams({ Idopp: inputObject.recordId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() == "Updated") {
                    this.toastEvent('SUCCESS', msgUnlinked, 'success');
                } else if (response.getReturnValue() == "emptyAudit") {
                    this.toastEvent('ERROR', msgEmptyAudit, 'error');
                }
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    toastEvent: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})
