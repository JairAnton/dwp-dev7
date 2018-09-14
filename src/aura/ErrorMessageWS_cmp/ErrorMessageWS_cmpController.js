({
  doCancelErrorModal: function(cmp, evt, helper) {
    var cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
    cancelEvent.fire();
  }
});