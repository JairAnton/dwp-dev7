({
    doCancelErrorModal: function(cmp, evt, helper) {
        var cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
        $A.get('e.force:refreshView').fire();
        cancelEvent.fire();
    }
});