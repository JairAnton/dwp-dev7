({
    handleClose: function (component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    doInit: function (cmp, event, helper) {
        helper.loadData(cmp, event, helper);
    },
})
