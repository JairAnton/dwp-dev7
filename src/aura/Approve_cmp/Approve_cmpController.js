({
    close : function(component, event, helper) {
	 	helper.closeMe(component, event, helper);
	},
    doApproval: function(component, event, helper) {
        if(component.get('v.Risk')){
           helper.risk(component, event, helper);  
        }
        if(component.get('v.Price')){
           helper.price(component, event, helper);  
        }
    },
    doIni: function(component, event, helper) {
		helper.ini(component, event,helper);
    }
})
