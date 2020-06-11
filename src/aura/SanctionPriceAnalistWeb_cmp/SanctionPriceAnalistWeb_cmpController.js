({
    doInit: function (cmp, event, helper) {
        helper.init(cmp, event, helper);
    },
    calculateJS: function (cmp, event, helper) {
        helper.calculatebutton(cmp, event, helper);
    },
    dateChange: function (cmp, evt, helper) {
        cmp.set('v.changeDate', true);
    }
})
