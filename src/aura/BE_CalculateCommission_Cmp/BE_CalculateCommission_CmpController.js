({
    close: function (component, event, helper) {
        helper.closeMe(component, event, helper);
    },
    doInit: function (cmp, evt, helper) {
        helper.getInfo(cmp, evt, helper);
    }
})