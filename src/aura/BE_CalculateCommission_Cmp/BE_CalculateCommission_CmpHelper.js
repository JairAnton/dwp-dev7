({
    closeMe: function (component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        $A.get('e.force:refreshView').fire();
        cancelEvent.fire();
    },
    getInfo: function (cmp, evt) {
        var inputObject = cmp.get('v.inputAttributes');
        console.log('inputObject: '+inputObject.recordId);
        var action = cmp.get("c.getOlis");
        action.setParams({
            "recordId": inputObject.recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var ret;
            var oli = '';
            if (state === "SUCCESS") {
                ret = response.getReturnValue();
                var generr = ret.genericError;
                if (generr != undefined) {
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst', generr);
                    cmp.set('v.hasHeader', false);
                } else {
                    cmp.set('v.hasHeader', true);
                    cmp.set('v.isError', false);
                    cmp.set('v.opportunityProducts', ret.olis);
                }
            }
            cmp.set('v.isLoad', true);
        });
        $A.enqueueAction(action);
    }
})