({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
	},
	continue : function(cmp, evt, helper){
		var inputObject=cmp.get('v.inputAttributes');
        var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
		compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceDecision_cmp'});
		compEvent.fire();
    }
})