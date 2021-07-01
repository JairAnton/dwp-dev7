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
    closeAlertInd: function () {
        document.getElementById("idAlertInd").classList.add("slds-hide");
    },
    closeAlertMar: function () {
        document.getElementById("idAlertMar").classList.add("slds-hide");
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
});