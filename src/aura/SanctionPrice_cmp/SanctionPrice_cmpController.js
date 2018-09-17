({
    close : function(component, event, helper) {
        helper.closeMe(component, event, helper);
    },
    doContinue: function(cmp, evt, helper){
        helper.continue(cmp, evt, helper);
    },
    doInit: function(cmp, evt, helper){
        helper.getInfo(cmp, evt, helper);
    },
    saveResponse: function(cmp, evt, helper){
        helper.doNextComponent(cmp, evt, helper);
    }
})