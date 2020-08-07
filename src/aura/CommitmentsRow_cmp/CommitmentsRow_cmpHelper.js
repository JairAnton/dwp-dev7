({
	deleteRecord: function (cmp, evt, helper) {
        //Start spinner
        var spinnerMain = cmp.find("Spinner");
		$A.util.removeClass(spinnerMain, "slds-hide");
		var action = cmp.get("c.deleteCommitment");
		action.setParams({
			"recordId": cmp.get('v.row').id
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				helper.refresh(cmp, evt, helper);
			}
		});
		$A.enqueueAction(action);
	},
    editRecord : function(cmp, evt, helper) {
		var row = cmp.get('v.row');
        var compEvent = cmp.getEvent("commitmentsEvent");
        compEvent.setParams({"typeMode" : 'DONEW', "rowData" : row});
		compEvent.fire();
	},
    refresh: function(cmp, evt, helper) {
        var action = cmp.get("c.infoAnalyzeRate");
        action.setParams({
            "idOli": cmp.get('v.idOli'),
            "tea": cmp.get('v.proposedTea')
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
                var inputObject = cmp.get("v.inputObject");
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
})