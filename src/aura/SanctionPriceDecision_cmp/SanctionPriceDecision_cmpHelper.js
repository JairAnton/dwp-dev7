({
    closeMe: function (component, event) {
        $A.get('e.force:refreshView').fire();
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    getInfo: function (component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        if (inputObject.approvalMethod == 'Web') {
            component.set('v.enableContinue', true);
        }
        var action = component.get("c.getInfo");
        action.setParams({
            "recordIdOppLineItem": inputObject.opportunityLineItem
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var objSetup = {
                    'nameProd': ret.lstOppLineItem[0].Product2.Name,
                    'validityDate': ret.lstOppLineItem[0].validityDate__c,
                    'statusType': ret.lstOppLineItem[0].Opportunity.opportunity_status_type__c
                };
                if (!ret.lstInfoIsEmpty) {
                    objSetup['lstTile'] = helper.setFields(ret);
                }
                objSetup['getInfoButtons'] = helper.getInfoButtons(inputObject.approvalMethod, ret.lstOppLineItem[0]);
                component.set('v.objSetup', objSetup);

                /**getSanctionPriceInfo**/
                if (ret.sanctionPriceInfo != null) {
                    if (ret.sanctionPriceInfo.length > 5) {
                        ret.sanctionPriceInfo[6].value = ret.sanctionPriceInfo[6].value.toFixed(2);
                    }
                    component.set("v.positionSanctionPrice", ret.sanctionPriceInfo);
                }
            }
        });
        $A.enqueueAction(action);
        component.set("v.refreshComp", true);
    },
    getInfoButtons: function (strType, objOli) {
        var returnObj = {
            'COTIZA Beta': {
                'lstButtons': [
                    {
                        'label': $A.get('$Label.c.OppPriceDecision03'),
                        'style': 'salem',
                        'icon': 'utility:check',
                        'id': '0',
                        'StageName': '04',
                        'opportunity_status_type': '08',
                        'styleAudit': $A.get('$Label.c.AuditStyleApproveTop'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel08'),
                        'createCase': false
                    },
                    {
                        'label': $A.get('$Label.c.OppPriceDecision04'),
                        'style': 'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName': '04',
                        'opportunity_status_type': '11',
                        'styleAudit': $A.get('$Label.c.AuditStyleApproveTop'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel11'),
                        'createCase': false
                    }
                ]
            },
            'COTIZADOR': {
                'lstButtons': [
                    {
                        'label': $A.get('$Label.c.OppPriceDecision01'),
                        'style': 'salem',
                        'icon': 'utility:check',
                        'id': '0',
                        'StageName': '04',
                        'opportunity_status_type': '08',
                        'styleAudit': $A.get('$Label.c.AuditStyleApproveTop'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel08'),
                        'createCase': false
                    },
                    {
                        'label': $A.get('$Label.c.OppPriceDecision02_long'),
                        'style': 'science-blue',
                        'icon': 'utility:share',
                        'id': '1',
                        'StageName': '04',
                        'opportunity_status_type': '09',
                        'styleAudit': $A.get('$Label.c.AuditStyleApproveTop'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel09'),
                        'createCase': true
                    }
                ]
            }
        };

        if (strType == 'Tarifario') {
            if (objOli.minimun_fee_per__c <= objOli.proposed_fee_per__c) {
                returnObj['Tarifario'] = {
                    'lstButtons': [
                        {
                            'label': $A.get('$Label.c.OppPriceDecision01'),
                            'style': 'salem',
                            'icon': 'utility:check',
                            'id': '0',
                            'StageName': '04',
                            'opportunity_status_type': '08',
                            'styleAudit': $A.get('$Label.c.AuditStyleApproveTop'),
                            'nameAudit': $A.get('$Label.c.OppStatusLabel08'),
                            'createCase': false
                        }
                    ]
                };
            } else {
                returnObj['Tarifario'] = {
                    'lstButtons': [
                        {
                            'label': $A.get('$Label.c.OppPriceDecision02_long'),
                            'style': 'science-blue',
                            'icon': 'utility:share',
                            'id': '0',
                            'StageName': '04',
                            'opportunity_status_type': '09',
                            'styleAudit': $A.get('$Label.c.AuditStyleElevate'),
                            'nameAudit': $A.get('$Label.c.OppStatusLabel09'),
                            'createCase': true
                        }
                    ]
                };
            }
        }
        return returnObj[strType];
    },
    doContinue: function (cmp, evt, helper) {
        var storeHTML = document.getElementById('storeHTML');
        var objSetup = cmp.get('v.objSetup');
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.saveDecision");
        action.setParams({
            "recordId": inputObject.recordId,
            "status_opp": objSetup['btnSelectConfig'].opportunity_status_type,
            "stageName": objSetup['btnSelectConfig'].StageName,
            "createCase": objSetup['btnSelectConfig'].createCase,
            "styleAudit": objSetup['btnSelectConfig'].styleAudit,
            "nameAudit": objSetup['btnSelectConfig'].nameAudit,
            "strComments": null,
            "storeHtml": storeHTML.innerHTML
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    $A.get('e.force:refreshView').fire();
                    helper.closeMe(cmp, evt, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    doContinueWeb: function (cmp, evt, helper) {
        var storeHTML = document.getElementById('storeHTML');
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.saveAuditWeb");
        action.setParams({
            "auditRecordId": inputObject.auditRecordId,
            "storeHtml": storeHTML.innerHTML
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    helper.closeMe(cmp, evt, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    setFields: function (ret) {
        var lstTile = [];
        for (var i in ret.lstField) {
            var strValue = ret.lstInfo[0][ret.lstField[i]];
            if (ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_values__c !== undefined &&
                ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_values__c !== '') {
                var lovValues = ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_values__c.split(',');
                var lovLabels = ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_labels__c.split(',');
                var posVal = lovValues.indexOf(strValue);
                strValue = lovLabels[posVal];
            }
            if (ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__Type__c === 'currency' && !isNaN(strValue)) {
                var val = Math.round(Number(strValue) * 100) / 100;
                var parts = val.toString().split(".");
                strValue = ret.lstOppLineItem[0].Opportunity.CurrencyIsoCode + ' ' + parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",") + (parts[1] ? "." + parts[1] : ".00");
            }
            var tile = {
                'label': ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__Label__c,
                'value': strValue
            }
            lstTile.push(tile);
        }
        return lstTile;
    },
    htmlObject: function (inputObject, evt) {
        var today = new Date();
        var originalHtml = inputObject.htmlInput;
        inputObject.htmlInput = '';
        if ((inputObject.label === 'Last price quote date' || inputObject.label === 'Fecha de sanción') && (evt.target.id !== '2')) {
            inputObject.htmlInput = String(today.getDate()).padStart(2, '0') + '/' + String(today.getMonth() + 1).padStart(2, '0') + '/' + today.getFullYear();
        } else if ((inputObject.label === 'validityDate' || inputObject.label === 'Validez TEA') && (evt.target.id === '1')) {
            inputObject.htmlInput = '#validityDate#';
        } else if (inputObject.label === 'Assigned_analyst' || inputObject.label === 'Analista asignado') {
            inputObject.htmlInput = '#Assigned_analyst#';
        } else if (inputObject.label !== 'validityDate' && inputObject.label !== 'Validez TEA' &&
            inputObject.label !== 'Assigned_analyst' && inputObject.label !== 'Analista asignado') {
            inputObject.htmlInput = originalHtml;
        }
        return inputObject;
    },
})
