({
	closeMe: function (component, event) {
		var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
		cancelEvent.fire();
	},
	continue: function (cmp, evt, helper) {
		//Start spinner
        var spinnerMain = cmp.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
    	var inputObject = cmp.get('v.inputAttributes');
    	if (inputObject.approvalMethod === 'Web') {
			inputObject['finMarRecover'] = cmp.get('v.finMarRecover');
			inputObject['quotationStatusMessage'] = evt.getParam("data").quotationStatusMessage;
			inputObject['quotationStatusIcon'] = evt.getParam("data").quotationStatusIcon;
			inputObject['auditRecordId'] = evt.getParam("data").auditId;
		}
		var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
		compEvent.setParams({ 'inputAttributes': inputObject, 'nextComponent': 'c:SanctionPriceDecision_cmp' });
		compEvent.fire();
	},
    changeSugComm: function(cmp, evt, helper) {
        //Start spinner
        var spinnerMain = cmp.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
        var inputObject = cmp.get("v.inputAttributes");
        var sugComm = cmp.get('v.inputAttributes').sugCommitments;
        var checkboxes = document.querySelectorAll("input[type='checkbox']");
        var lstData = [];
        for(var i = 0; i < checkboxes.length; i++) {
            if(checkboxes[i].checked && checkboxes[i].checked !== sugComm[checkboxes[i].value].selected) {
                lstData = [];
                lstData.push(sugComm[checkboxes[i].value].id);
                lstData.push(sugComm[checkboxes[i].value].name);
                lstData.push(sugComm[checkboxes[i].value].committedData.unitValue.currencyType);
                lstData.push(sugComm[checkboxes[i].value].committedData.unitValue.amount);
                lstData.push(sugComm[checkboxes[i].value].committedData.effectiveTime.numberValue);
                lstData.push(sugComm[checkboxes[i].value].committedData.effectiveTime.unit);
            }
        }
        if(lstData.length>0) {
            var action = cmp.get("c.changeCommitment");
            action.setParams({
                "recordId": cmp.get('v.inputAttributes').recordId,
                "lstData": lstData,
                "oppLineItem": cmp.get('v.inputAttributes').opportunityLineItem
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var ret = response.getReturnValue();
                    inputObject['RORCOperation'] = ret.rorcOper;
                    helper.refresh(cmp, evt, helper);
                }
            });
            $A.enqueueAction(action);
        } else {
            $A.util.addClass(spinnerMain, "slds-hide");
        }
    },
    refresh: function(cmp, evt, helper) {
        var action = cmp.get("c.infoAnalyzeRate");
        action.setParams({
            "idOli": cmp.get('v.inputAttributes').opportunityLineItem,
            "tea": cmp.get('v.inputAttributes').proposed
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                cmp.set('v.finMarLost', ret.finMarLost);
                cmp.set('v.finMarRecover', ret.finMarRecover);
                cmp.set('v.rorcOper', ret.rorcOper);
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
                var inputObject = cmp.get("v.inputAttributes");
                inputObject['sugCommitments'] = sugCommitments;
                var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
                compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:SanctionPriceCommitments_cmp'});
                compEvent.fire();
            }
            //End spinner
            var spinnerMain = cmp.find("Spinner");
            $A.util.addClass(spinnerMain, "slds-hide");
        });
        $A.enqueueAction(action);
    },
	continueSummary: function(cmp, evt, helper) {
        cmp.set('v.isLoad', false);
        if(cmp.get('v.inputAttributes').approvalMethod === 'Web') {
            var action = cmp.get("c.requestQuote");
            action.setParams({
                "recordId": cmp.get('v.inputAttributes').recordId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var ret = response.getReturnValue();
                    helper.firstCall(ret, cmp, evt, helper);
                }
            });
            $A.enqueueAction(action);
        } else {
            var compEvent = cmp.getEvent("commitmentsEvent");
            compEvent.setParams({ "typeMode": 'DOCONTINUE' });
            compEvent.fire();
        }
    },
    firstCall: function(ret, cmp, evt, helper) {
        var compEvent = cmp.getEvent("commitmentsEvent");
        if(ret.success === 'true') {
            if(ret.nextCallout !== undefined && ret.nextCallout === true) {
                helper.secondCall(cmp, evt, helper);
            } else {
                compEvent = helper.callEvent(compEvent, 'DOCONTINUE', ret);
            }
        } else {
            compEvent = helper.callEvent(compEvent, 'DOERROR', ret);
        }
        compEvent.fire();
    },
    secondCall: function(cmp, evt, helper) {
        var action2 = cmp.get("c.requestQuote");
        action2.setParams({
            "recordId": cmp.get('v.inputAttributes').recordId
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                var compEvent = cmp.getEvent("commitmentsEvent");
                if(ret.success === 'true') {
                    compEvent = helper.callEvent(compEvent, 'DOCONTINUE', ret);
                } else {
                    compEvent = helper.callEvent(compEvent, 'DOERROR', ret);
                }
                compEvent.fire();
            }
        });
        $A.enqueueAction(action2);
    },
    callEvent : function(compEvent, tipe, ret) {
        if(tipe === 'DOERROR') {
            var otherData1 = { "errorCode": ret.errorMessage };
            compEvent.setParams({ "typeMode": tipe, "data": otherData1 });
        } else if(tipe === 'DOCONTINUE') {
            var otherData2 = {
                "quotationStatusMessage": ret.quotationStatusMessage,
                "auditId": ret.auditId,
                "quotationStatusIcon": ret.quotationStatusIcon
            };
            compEvent.setParams({ "typeMode": tipe, "data": otherData2 });
        }
        return compEvent;
    }
})