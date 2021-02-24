({
	close: function (component, event, helper) {
		helper.closeMe(component, event, helper);
	},
	doContinue: function (cmp, evt, helper) {
		helper.valide(cmp, evt, helper);
	},
	doInit: function (cmp, evt, helper) {
		helper.getInfo(cmp, evt, helper);
	},
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },
    hideSpinner : function(component,event,helper) {
        component.set("v.spinner", false);
    }
})
