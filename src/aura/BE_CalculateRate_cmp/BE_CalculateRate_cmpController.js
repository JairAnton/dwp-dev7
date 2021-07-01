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
        var alerta = document.getElementById("idAlertInd");
        alerta.classList.add("slds-hide");
    },
    closeAlertMar: function () {
        var alerta = document.getElementById("idAlertMar").classList.add("slds-hide");
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