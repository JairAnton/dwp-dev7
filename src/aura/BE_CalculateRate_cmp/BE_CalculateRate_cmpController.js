({
    getCal: function (cmp, evt, helper) {
        helper.calRate(cmp, evt, helper);
    },
    showSpinner: function (component) {
        component.set("v.spinner", true);
    },
    hideSpinner: function (component) {
        component.set("v.spinner", false);
    },
    onCheckUseCommissions: function (cmp, evt, helper) {
        helper.updateUseCommissions(cmp, evt, helper);
    },
    emitCommissionEvent: function (cmp, evt, helper) {
        helper.emitEventHelper(cmp, evt, helper);
    },
    handlerCommissionCall: function (cmp, evt, helper) {
        helper.handlerCommissionCallHelper(cmp, evt, helper);
    }
})