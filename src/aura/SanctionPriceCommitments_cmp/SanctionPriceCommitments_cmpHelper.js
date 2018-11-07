({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
	},
	continue : function(cmp, evt, helper){
		var inputObject=cmp.get('v.inputAttributes');
        if(inputObject.approvalMethod === 'Web'){
        	inputObject['quotationStatusMessage'] = evt.getParam("data").quotationStatusMessage;
    		inputObject['quotationStatusIcon'] = evt.getParam("data").quotationStatusIcon;
        	inputObject['auditRecordId'] = evt.getParam("data").auditId;
        }
        var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
		compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceDecision_cmp'});
		compEvent.fire();
    }
})