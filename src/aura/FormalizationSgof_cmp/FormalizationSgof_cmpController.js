({
    doInit : function(component, event, helper) {
        helper.validateOwner(component, event, helper);
    },
    close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
    continue : function(component, event, helper) {
	    component.find("btnContinue").set("v.disabled", true);
    	var cmpView = component.find("view");
        if(cmpView.get("v.showInterface")) {
            helper.reasignOwner(component, event, helper, '', '');
        } else {
            helper.sentFormalize(component, event, helper);
        }
	},
    closeAlert : function(cmp, evt, helper) {
       	cmp.set("v.showAlert", false);
    },
    listenOption : function(component, event, helper) {
        var enable = event.getParam("activeContinue");
        component.find("btnContinue").set("v.disabled",enable);
    }

})