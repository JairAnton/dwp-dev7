({
    init: function (cmp, event, helper) {
        var pageReference = cmp.get("v.pageReference");
        cmp.set("v.sObject", pageReference.state.c__sObject);
    },

    reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})
