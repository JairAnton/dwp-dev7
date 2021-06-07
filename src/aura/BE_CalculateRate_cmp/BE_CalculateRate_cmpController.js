({
    getCal: function (cmp, evt, helper) {
        helper.calRate(cmp, evt, helper);
    },
    showSpinner: function (component, event, helper) {
        component.set("v.spinner", true);
    },
    hideSpinner: function (component, event, helper) {
        component.set("v.spinner", false);
    },
    closeAlertInd: function (cmp, evt, helper) {
        var alerta = document.getElementById("idAlertInd");
        alerta.classList.add("slds-hide");
    },
    closeAlertMar: function (cmp, evt, helper) {
        var alerta = document.getElementById("idAlertMar");
        alerta.classList.add("slds-hide");
    },
    onCheckUseCommissions: function (cmp, evt, helper) {
        var checkCmp = cmp.find("useCommissionsCheckbox");
        cmp.set('v.useCommissionsCheckbox', checkCmp.get("v.value"));
    },
    emitCommissionEvent: function (cmp, evt, helper) {
        helper.emitEventHelper(cmp, evt, helper);
    },
    handlerCommissionCall: function (cmp, evt, helper) {
        helper.handlerCommissionCallHelper(cmp, evt, helper);
    }
})