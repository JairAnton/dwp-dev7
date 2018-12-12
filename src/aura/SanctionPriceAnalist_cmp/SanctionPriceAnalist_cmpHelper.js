({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    },
    getInfo : function(cmp, evt, helper){
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.getInfoAnalist");
        action.setParams({
            "recordId" : inputObject.recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                cmp.set('v.AccId',ret.AccId);
                cmp.set('v.type_of_quote',ret.type_of_quote);
                if(ret.type_of_quote==='COTIZA Beta')
                {
                  cmp.set('v.modalWidthCustom','37rem');
                }
                cmp.set('v.commercial_strategy',ret.commercial_strategy);
                var objectInput = {
                    'IdOppLineItem':ret.IdOppLineItem,
                    'approvalMethod':ret.approvalMethod,
                    'dinamicInput':'-'
                };
                if(ret.approvalMethod === 'Tarifario' && ret.dynamicValue !== undefined){
                    objectInput['dinamicInput'] = ret.dynamicValue.toString() + ',-';
                } else if(ret.approvalMethod == 'Web'){
                    cmp.set('v.isnotWeb',false)
                }
				cmp.set('v.objectInput',objectInput);
                cmp.set('v.isLoad',true);
            }
        }); 
        $A.enqueueAction(action);
    },
    continue : function(cmp, evt,helper){
    	var isOk = true;
		var lstApiField = [];
		var lstvalueField = [];
        var inputObject=cmp.get('v.inputAttributes');
    	var dynamicValuesInputJS;
        var lstApiFieldJS;
        var lstvalueFieldJS;
    	if(cmp.get('v.isnotWeb') == false){
            var analistWeb = cmp.find('analistWeb');		
            var recordId = cmp.get('v.inputAttributes.recordId');
            var inputtea = analistWeb.get('v.teainput');
            var datalst = analistWeb.get('v.data');
            var headerlst = analistWeb.get('v.headers');
            var spreadinput = analistWeb.get('v.spreadinput');
    		dynamicValuesInputJS = inputtea.toString();
			lstApiFieldJS = ['spread_per__c','proposed_apr_per__c'];
            lstvalueFieldJS = [spreadinput,inputtea];
    		inputObject['datainput'] = datalst;
    		inputObject['headerinput'] = headerlst;
        }else{
 			var fieldsForm = cmp.find('fieldsFormInput');
            var inputs = fieldsForm.find('input');
            if(inputs.length != undefined){
                for(var i in inputs){
                    if(inputs[i].find('inputField') != undefined){
                        lstApiField.push(inputs[i].get('v.fieldObject').ApiName);
                        lstvalueField.push(inputs[i].get('v.fieldObject').value);
                        inputs[i].find('inputField').reportValidity();
                        if(!inputs[i].find('inputField').checkValidity()){
                            isOk = false;
                        }
                    }
                }
            }else{
                if(inputs.find('inputField') != undefined){
                    lstApiField.push(inputs.get('v.fieldObject').ApiName);
                    lstvalueField.push(inputs.get('v.fieldObject').value);
                    inputs.find('inputField').reportValidity();
                    if(!inputs.find('inputField').checkValidity()){
                        isOk = false;
                    }
                }
            }
			dynamicValuesInputJS = lstvalueField.join(',');
			lstApiFieldJS = lstApiField;
            lstvalueFieldJS = lstvalueField;
 		}
        
        inputObject['dynamicValuesInput'] = dynamicValuesInputJS;
        inputObject['lstApiField'] = lstApiFieldJS;
        inputObject['lstvalueField'] = lstvalueFieldJS;
        inputObject['opportunityLineItem'] = cmp.get('v.objectInput').IdOppLineItem;
        inputObject['approvalMethod'] = cmp.get('v.objectInput').approvalMethod;
        if(isOk){
            var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
            compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceDecisionAnalist_cmp'});
            compEvent.fire();
        }else{
            var disabledButton = $A.get("e.c:disabledButton_evt");            
            disabledButton.setParams({ 
                "idOpp" : inputObject.recordId,
                "idButton" : 'idContinueSPA'
            });
            disabledButton.fire();
        } 

   },
       valide: function(cmp, evt,helper){
           if(cmp.get('v.isnotWeb') == false){
               var analistWeb = cmp.find('analistWeb');
               var inputtea = analistWeb.get('v.teainput');
               var datalst = analistWeb.get('v.data');
               var TeaAUT =parseInt(datalst[0].AUTH);
               var inputObject=cmp.get('v.inputAttributes');
               if(cmp.get('v.isnotWeb') == false && TeaAUT==inputtea){
                   helper.continue(cmp, evt, helper); }
               else{
                   var disabledButton = $A.get("e.c:disabledButton_evt");            
                   disabledButton.setParams({ 
                       "idOpp" : inputObject.recordId,
                       "idButton" : 'idContinueSPA'
                   });
                   disabledButton.fire();
                   var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                       title: "Error!",
                       message: $A.get('$Label.c.Error_TEA_no_calculada'),
                       type: "error"
                   });
                   toastEvent.fire();
               }
           }
           else{
               helper.continue(cmp, evt, helper); 
           }
       }
})