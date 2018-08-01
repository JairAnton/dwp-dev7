({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    },
    getInfo : function(cmp, evt, helper){
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.getInfo");
        action.setParams({
            "recordId" : inputObject.recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var objectInput = {
                    'IdOppLineItem':ret.IdOppLineItem,
                    'approvalMethod':ret.approvalMethod,
                    'dinamicInput':'-'
                };
                if(ret.approvalMethod == 'Tarifario'){
                    objectInput['dinamicInput'] = ret.dynamicValue.toString() + ',-';
                }
                cmp.set('v.objectInput',objectInput);
                cmp.set('v.isLoad',true);
            }
        }); 
        $A.enqueueAction(action);
    },
    continue : function(cmp, evt, helper){
        var fieldsForm = cmp.find('fieldsForm');
        var valField = fieldsForm.validateSave();
        if(!valField){
            var inputObject=cmp.get('v.inputAttributes'); 
            var disabledButton = $A.get("e.c:disabledButton_evt");            
            disabledButton.setParams({ 
                "idOpp" : inputObject.recordId,
                "idButton" : 'idContinueSPE',
            });
            disabledButton.fire();
        }
    },
    doNextComponent : function(cmp, evt, helper){
        var message = evt.getParam("message");
		var isOk = evt.getParam("isOk");
        var inputObject=cmp.get('v.inputAttributes');
        inputObject['approvalMethod'] = cmp.get('v.objectInput').approvalMethod;
        inputObject['opportunityLineItem'] = cmp.get('v.objectInput').IdOppLineItem;
        if(isOk){
            var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
            compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceCommitments_cmp'});
            compEvent.fire();
        }else{
            var disabledButton = $A.get("e.c:disabledButton_evt");            
            disabledButton.setParams({ 
				"idOpp" : inputObject.recordId,
				"idButton" : 'idContinueSPE',
		 	});
			disabledButton.fire();
            cmp.set('v.checkError',true);
            cmp.set('v.errorMessage',message);
        }
    }
})