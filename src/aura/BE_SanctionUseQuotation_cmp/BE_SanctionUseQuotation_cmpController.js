({
    close : function(component, event, helper) {
        helper.closeMe(component, event, helper);
    },
    doContinue: function(cmp, evt, helper) {
        helper.continue(cmp, evt, helper);
    },
    onSelectedQuotation: function(cmp, evt, helper) {
        helper.getComments(cmp, evt, helper);
    },
    closeAlert: function (cmp, evt, helper) {
        var alerta = document.getElementById("idAlert");
        alerta.classList.add("slds-hide");
    }
})
