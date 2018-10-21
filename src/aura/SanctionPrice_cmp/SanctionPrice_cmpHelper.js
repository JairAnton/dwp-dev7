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
                cmp.set('v.AccId',ret.AccId);
                cmp.set('v.type_of_quote',ret.type_of_quote);
                if(ret.type_of_quote=='COTIZA Beta')
                {
                  cmp.set('v.modalWidthCustom','37rem');
                }
                cmp.set('v.commercial_strategy',ret.commercial_strategy);                
                var objectInput = {
                    'IdOppLineItem':ret.IdOppLineItem,
                    'approvalMethod':ret.approvalMethod,
                    'dinamicInput':'-'
                };
                var generr = ret.genericError;
                cmp.set('v.hasHeader',true);
                if(ret.approvalMethod == 'Tarifario' && ret.dynamicValue!=undefined){            
                    objectInput['dinamicInput'] = ret.dynamicValue.toString() + ',-';
                    cmp.set('v.hasHeader',true);
                }else if (ret.approvalMethod == 'Web'){
                    if(generr != undefined){
                        cmp.set('v.isError', true);
                        cmp.set('v.errorlst',generr);
                        cmp.set('v.hasHeader',false);
                    }else{
                        cmp.set('v.hasHeader',true);
                    	cmp.set('v.isError', false);                        
                        objectInput['dinamicInput'] = ret.sugtea + ',' + ret.minimtea + ','+ret.proposed+',' + ret.spread;
                    }                    
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