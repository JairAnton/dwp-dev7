({
    close : function(component, event, helper) {
	 	helper.closeMe(component, event, helper);
	},
    doReevaluate: function(component, event, helper) {
		helper.Reevaluate(component, event,helper);
    },
    doIni: function(component, event, helper) {
		helper.ini(component, event,helper);
    },
    doRisk: function(component, event, helper) {
		helper.risk(component, event,helper);
    },
    doPrice: function(component, event, helper) {
		helper.price(component, event,helper);
    }
 
})