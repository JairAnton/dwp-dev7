// NOSONAR
//NOSONAR
//CHECKSTYLE:OFF
({
    calRate: function (cmp, evt, helper) {
        cmp.set('v.disabled', 'true');
        var action = cmp.get("c.getInfoRORC");
        action.setParams({
            "recordId": cmp.get('v.recordId'),
            "tea": cmp.find("inputTEA").get("v.value"),
            "vdata": JSON.stringify(cmp.get('v.data')),
            "hasCommissions": cmp.get('v.useCommissionsCheckbox')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var generr = ret.errorCal;
                if (generr !== undefined) {
                    cmp.set('v.isErrorCal', true);
                    cmp.set('v.errorlstCal', generr);
                } else {
                    cmp.set('v.isErrorCal', false);
                    var resultData = JSON.parse(ret.fields);
                    cmp.set("v.data", resultData);
                    cmp.set("v.finMarLost", ret.finMarLost);
                    cmp.set("v.finMarRecover", ret.finMarRecover);
                    cmp.set("v.finMarLostCur", ret.finMarLostCur);
                    cmp.set("v.finMarRecoverCur", ret.finMarRecoverCur);
                    var sugCommitments = '';
                    if (ret.sugCommitments !== undefined) {
                        sugCommitments = helper.setCommitments(sugCommitments, ret);
                    }
                    cmp.set("v.sugCommitments", sugCommitments);
                    var alertInd = document.getElementById("idAlertInd");
                    alertInd.classList.remove("slds-hide");
                    var alertMar = document.getElementById("idAlertMar");
                    alertMar.classList.add("slds-hide");
                    if (ret.finMarLost > 0) {
                        alertMar.classList.remove("slds-hide");
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    setCommitments: function (sugCommitments, ret) {
        sugCommitments = JSON.parse(ret.sugCommitments);
        for (var i in sugCommitments) {
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
        return sugCommitments;
    },
    emitEventHelper: function (cmp, evt, helper) {
        var checkCmp = cmp.find("useCommissionsCheckbox");
        if (checkCmp.get("v.value")) {
            cmp.find('prodCommissionSectionId').updateCommissions();
        } else {
            this.calRate(cmp, evt, helper);
        }
    },
    handlerCommissionCallHelper: function (cmp, evt, helper) {
        this.calRate(cmp, evt, helper);
    },
    updateUseCommissions: function (cmp, evt, helper) {
        var checkCmp = cmp.find("useCommissionsCheckbox");
        cmp.set('v.useCommissionsCheckbox', checkCmp.get("v.value"));
        var action = cmp.get("c.setHasCommission");
        action.setParams({
            "recordId": cmp.get('v.recordId'),
            "hasCommission": cmp.get('v.useCommissionsCheckbox')
        });
        action.setCallback(this, function (response) { });
        $A.enqueueAction(action);
    }
})