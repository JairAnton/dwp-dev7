({
    doInit: function (cmp, event, helper) {
        helper.init(cmp, event, helper);
    },
    calculateJS: function (cmp, event, helper) {
        helper.calculatebutton(cmp, event, helper);
    },
    dateChange: function (cmp, evt, helper) {
        cmp.set('v.changeDate', true);
    },
    emitCommissionEvent: function (cmp, evt, helper) {
        helper.emitEventHelper(cmp, evt, helper);
    },
    handlerCommissionCall: function (cmp, evt, helper) {
        helper.handlerCommissionCallHelper(cmp, evt, helper);
    }
})