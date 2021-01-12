({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    },
    calculateRate : function(cmp, evt) {
        var device = $A.get("$Browser.formFactor");
        if(device==='DESKTOP') {
            cmp.set('v.modalWidthCustom', '74rem');
        }
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.calculateRate");
        action.setParams({
            "recordId" : inputObject.recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var ret;
            if(state === "SUCCESS") {
                ret = response.getReturnValue();
                var generr = ret.genericError;
                if(generr !== undefined) {
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst', generr);
                    cmp.set('v.hasHeader', false);
                    cmp.set('v.isLoad', true);
                } else {
                    if(ret.approvalMethod === 'Web') {
                        this.getInfo(cmp, evt);
                    } else {
                        cmp.set('v.OppId', inputObject.recordId);
                        cmp.set('v.AccId',ret.AccId);
                        cmp.set('v.type_of_quote',ret.type_of_quote);
                        if(ret.type_of_quote==='COTIZA Beta' || ret.type_of_quote==='Carta de credito')
                        {
                            if(ret.type_of_quote==='Carta de credito'){
                                cmp.set('v.title','Sanción de Precio');
                            }
                            cmp.set('v.modalWidthCustom','37rem');
                        }
                        cmp.set('v.commercial_strategy',ret.commercial_strategy);
                        var objectInput = {
                            'IdOppLineItem':ret.IdOppLineItem,
                            'approvalMethod':ret.approvalMethod,
                            'pricingModelId':ret.pricingModelId,
                            'dinamicInput':'-'
                        };
                        cmp.set('v.hasHeader',true);
                        if(ret.approvalMethod === 'Tarifario' && ret.dynamicValue !== undefined){
                            objectInput['dinamicInput'] = ret.dynamicValue.toString() + ',-';
                            cmp.set('v.hasHeader',true);
                        }
                        cmp.set('v.objectInput',objectInput);
                        cmp.set('v.isLoad',true);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    getInfo : function(cmp, evt, helper) {
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.getInfo");
        action.setParams({
            "recordId" : inputObject.recordId
        });
        cmp.set('v.OppId', inputObject.recordId);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                cmp.set('v.AccId',ret.AccId);
                cmp.set('v.type_of_quote',ret.type_of_quote);
                if(ret.type_of_quote==='COTIZA Beta' || ret.type_of_quote==='Carta de credito') {
                    if(ret.type_of_quote==='Carta de credito') {
                        cmp.set('v.title','Sanción de Precio');
                    }
                    cmp.set('v.modalWidthCustom','37rem');
                }
                cmp.set('v.commercial_strategy',ret.commercial_strategy);
                var objectInput = {
                    'IdOppLineItem':ret.IdOppLineItem,
                    'approvalMethod':ret.approvalMethod,
                    'pricingModelId':ret.pricingModelId,
                    'dinamicInput':'-'
                };
                var generr = ret.genericError;
                cmp.set('v.hasHeader',true);
                if(ret.approvalMethod == 'Tarifario' && ret.dynamicValue!=undefined) {
                    objectInput['dinamicInput'] = ret.dynamicValue.toString() + ',-';
                    cmp.set('v.hasHeader',true);
                } else if(ret.approvalMethod == 'Web') {
                    cmp.set("v.showWebForm",true);
                    if(generr !== undefined) {
                        cmp.set('v.isError', true);
                        cmp.set('v.errorlst',generr);
                        cmp.set('v.hasHeader',false);
                    } else {
                        objectInput = this.readWebInfo(cmp, ret, objectInput);
                    }
                }
                cmp.set('v.objectInput',objectInput);
                cmp.set('v.isLoad',true);
            }
        });
        $A.enqueueAction(action);
    },
    readWebInfo : function(cmp, ret, objectInput) {
        cmp.set('v.hasHeader',true);
        cmp.set('v.isError', false);
        objectInput['sugtea'] = ret.sugtea;
        objectInput['minimtea'] = ret.minimtea;
        objectInput['rorc_client'] = ret.rorc_client;
        objectInput['proposed'] = ret.proposed;
        cmp.set("v.finMarLost", ret.finMarLost);
        cmp.set("v.finMarLostCur", ret.finMarLostCur);
        cmp.set("v.classHide", (ret.finMarLost>0)?'':'slds-hide');
        cmp.set("v.finMarRecover", ret.finMarRecover);
        cmp.set("v.finMarRecoverCur", ret.finMarRecoverCur);
        cmp.set("v.proposedEmpty", (ret.proposed)?false:true);
        var resultData = JSON.parse(ret.fields);
        var sugCommitments = '';
        if(ret.sugCommitments!==undefined) {
            sugCommitments = JSON.parse(ret.sugCommitments);
            for(var i in sugCommitments) {
                var indexVal = sugCommitments[i].id;
                indexVal += sugCommitments[i].committedData.unitValue.currencyType;
                indexVal += sugCommitments[i].committedData.effectiveTime.numberValue;
                if (ret.commIds.indexOf(indexVal) !== -1) {
                    sugCommitments[i].selected = true;
                } else {
                    sugCommitments[i].selected = false;
                }
                if (ret.commProdIds.indexOf(sugCommitments[i].id) !== -1) {
                    sugCommitments[i].disabled = true;
                } else {
                    sugCommitments[i].disabled = false;
                }
            }
        }
        cmp.set("v.data", resultData);
        cmp.set("v.sugCommitments", sugCommitments);
        return objectInput;
    },
    continue : function(cmp, evt, helper) {
    	if(cmp.get('v.objectInput').approvalMethod !== 'Web') {
            var fieldsForm;
            if(cmp.get('v.type_of_quote')==='Carta de credito') {
                fieldsForm = cmp.find('fieldsSummary');
            } else {
                fieldsForm = cmp.find('fieldsForm');
            }
            var valField = fieldsForm.validateSave();
			if(valField && cmp.get('v.type_of_quote')!=='Carta de credito') {
                helper.activeButton(cmp, evt, helper);
                helper.doNextComponent(cmp, evt, helper);
                cmp.set("v.btnCalculate",false);
            }
        }
		else {
            helper.activeButton(cmp, evt, helper);
			helper.doNextComponent(cmp, evt, helper);
			cmp.set("v.btnCalculate",false);
        }
    },
    doNextComponent : function(cmp, evt, helper) {
        //Start spinner
        var spinnerMain = cmp.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
        if(cmp.get('v.objectInput').approvalMethod === 'Web') {
            var inputObject = helper.getInputObject(cmp);
            if((inputObject['finMarLost'] !== undefined && inputObject['finMarLost'] > 0) || inputObject['minimtea'] > inputObject['proposed']) {
                var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
                compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceCommitments_cmp'});
                compEvent.fire();
            } else {
                var action = cmp.get("c.requestQuote");
                action.setParams({
                    "recordId": inputObject.recordId
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if(state === "SUCCESS") {
                        var ret = response.getReturnValue();
                        helper.firstCall(ret, cmp, evt, helper);
                    }
                });
                $A.enqueueAction(action);
            }
        } else {
            var inputObj = cmp.get('v.inputAttributes');
            inputObj['approvalMethod'] = cmp.get('v.objectInput').approvalMethod;
            inputObj['opportunityLineItem'] = cmp.get('v.objectInput').IdOppLineItem;
            inputObj['pricingModelId'] = cmp.get('v.objectInput').pricingModelId;
            var compEvt = cmp.getEvent('dynamicFlowWizardContinue');
            compEvt.setParams({'inputAttributes': inputObj, 'nextComponent':'c:SanctionPriceCommitments_cmp'});
            compEvt.fire();
        }
    },
    activeButton : function(cmp, evt, helper) {
        var inputObject=cmp.get('v.inputAttributes');
        var disabledButton = $A.get("e.c:disabledButton_evt");
        disabledButton.setParams({
            "idOpp" : inputObject.recordId,
            "idButton" : 'idContinueSPE',
        });
        disabledButton.fire();
    },
    doContinueNext : function(cmp, evt, helper) {
        //Start spinner
        var spinnerMain = cmp.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
        var inputObject=cmp.get('v.inputAttributes');
        if(cmp.get('v.objectInput').approvalMethod === 'Web') {
            inputObject['quotationStatusMessage'] = evt.getParam("data").quotationStatusMessage;
    		inputObject['quotationStatusIcon'] = evt.getParam("data").quotationStatusIcon;
        	inputObject['auditRecordId'] = evt.getParam("data").auditId;
            inputObject['opportunityLineItem'] = cmp.get('v.objectInput').IdOppLineItem;
        }
        var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
		compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceDecision_cmp'});
		compEvent.fire();
    },
    firstCall : function(ret, cmp, evt, helper) {
        var inputObject=cmp.get('v.inputAttributes');
        var compEvent = cmp.getEvent("commitmentsEvent");
        if(ret.success === 'true') {
            if(ret.nextCallout !== undefined && ret.nextCallout === true) {
                helper.secondCall(cmp, evt, helper);
            } else {
                compEvent = helper.callEvent(compEvent, inputObject, 'DOCONTINUE', ret);
            }
        } else {
            compEvent = helper.callEvent(compEvent, inputObject, 'DOERROR', ret);
        }
        compEvent.fire();
    },
    secondCall : function(cmp, evt, helper) {
        var inputObject=cmp.get('v.inputAttributes');
        var action2 = cmp.get("c.requestQuote");
        action2.setParams({
            "recordId": inputObject.recordId
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                var compEvent = cmp.getEvent("commitmentsEvent");
                if(ret.success === 'true') {
                    compEvent = helper.callEvent(compEvent, inputObject, 'DOCONTINUE', ret);
                } else {
                    compEvent = helper.callEvent(compEvent, inputObject, 'DOERROR', ret);
                }
                compEvent.fire();
            }
        });
        $A.enqueueAction(action2);
    },
    getInputObject : function(cmp) {
        var inputObject = cmp.get('v.inputAttributes');
        var data = cmp.find("CalculateRate").get('v.data');
        var sugCommitments = cmp.find("CalculateRate").get('v.sugCommitments');
        for(var i=0; i<data.length; i++) {
            if(data[i].apiName==='RORC_Operation__c') {
                inputObject['RORCOperation'] = data[i].valueField;
                break;
            }
        }
    	inputObject['approvalMethod'] = cmp.get('v.objectInput').approvalMethod;
        inputObject['opportunityLineItem'] = cmp.get('v.objectInput').IdOppLineItem;
        inputObject['pricingModelId'] = cmp.get('v.objectInput').pricingModelId;
        inputObject['minimtea'] = cmp.get('v.objectInput').minimtea;
        inputObject['proposed'] = cmp.find("CalculateRate").get('v.tea');
        inputObject['finMarLost'] = cmp.find("CalculateRate").get('v.finMarLost');
        inputObject['finMarLostCur'] = cmp.find("CalculateRate").get('v.finMarLostCur');
        inputObject['finMarRecover'] = cmp.find("CalculateRate").get('v.finMarRecover');
        inputObject['finMarRecoverCur'] = cmp.find("CalculateRate").get('v.finMarRecoverCur');
        if(sugCommitments==null) {
            inputObject['sugCommitments'] = cmp.get('v.sugCommitments');
        } else {
            inputObject['sugCommitments'] = sugCommitments;
        }
        inputObject['recordId'] = inputObject.recordId;
        return inputObject;
    },
    callEvent : function(compEvent, inputObject, tipe, ret) {
        if(tipe === 'DOERROR') {
            var otherData1 = { "errorCode": ret.errorMessage };
            compEvent.setParams({ "inputAttributes": inputObject, "typeMode": tipe, "data": otherData1 });
        } else if(tipe === 'DOCONTINUE') {
            var otherData2 = {
                "quotationStatusMessage": ret.quotationStatusMessage,
                "auditId": ret.auditId,
                "quotationStatusIcon": ret.quotationStatusIcon
            };
            compEvent.setParams({ "inputAttributes": inputObject, "typeMode": tipe, "data": otherData2 });
        }
        return compEvent;
    }
})
