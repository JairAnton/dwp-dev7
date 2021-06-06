({
    init : function(cmp, evt, helper) {
        helper.getUsers(cmp, evt, helper);
    },
    handleSave : function(cmp, evt, helper) {
        helper.saveMethod(cmp, evt, helper);
    },
    handleClose : function(component, evt, helper) {
        helper.closeMethod(component, evt, helper);
    }
})