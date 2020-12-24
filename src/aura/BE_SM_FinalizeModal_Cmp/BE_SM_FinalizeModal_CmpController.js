({
    doInit : function(cmp, evt, helper) {
        helper.getInfo(cmp, evt, helper);
    },
    showSpinner: function(cmp, evt, helper) {
        cmp.set("v.spinner", true);
    },
    hideSpinner : function(cmp,evt,helper) {
        cmp.set("v.spinner", false);
    },
    handleSave : function(cmp, evt, helper) {
        helper.saveMethod(cmp, evt, helper);
    },
    handleSaveClone : function(cmp, evt, helper) {
        helper.saveCloneMethod(cmp, evt, helper);
    },
    handleClose : function(component, evt, helper) {
        helper.closeMethod(component, evt, helper);
    }
})