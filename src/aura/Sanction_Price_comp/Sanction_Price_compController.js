({
	init: function(component, event, helper) {
		component.set("v.lblComments", $A.get("$Label.c.Comments"));	
	    helper.bringData(component, event, helper); 
    },
	close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
	sanction : function(component, event, helper) {
		component.set('v.sanAction',event.getSource().get("v.name"));
		component.find("btnContinue").set("v.disabled", false);
	},
	continue : function(component, event, helper) {
		helper.sanctionActions(component, event, helper);
	},
	desestimar : function(cmp, event, helper) {	
		var inputObject=cmp.get('v.inputAttributes');  
	    var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
	    compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:submitToDiscardModal_comp' });
	    compEvent.fire();
	    
	}

})