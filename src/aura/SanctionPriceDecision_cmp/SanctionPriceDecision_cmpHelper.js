({
    closeMe: function (component, event) {
        $A.get('e.force:refreshView').fire();
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    infoSetupObj: function (ret) {
        return {
            'nameProd': ret.lstOppLineItem[0].Product2.Name,
            'validityDate': ret.lstOppLineItem[0].validityDate__c,
            'statusType': ret.lstOppLineItem[0].Opportunity.opportunity_status_type__c,
            'lstTile': JSON.parse(ret.lstSummarize),
            'headers': [
                { label: 'COMISIÓN', fieldName: 'Product_Commission_Name__c', type: 'text' },
                { label: 'SOLICITADO (%)', fieldName: 'Requested_Rate_Value__c', type: 'text' },
                { label: 'AUTORIZADO (%)', fieldName: 'Authorized_Rate_Value__c', type: 'text' },
                { label: 'COMISIÓN FINAL', fieldName: 'Final_Rate__c	', type: 'text' }],
            'data': ret.comissions
        };
    },
    infoRows: function (objSetup) {
        var lstRows = [];

        for (var x in objSetup.data) {
            var lstCells = [];
            for (var i in objSetup.headers) {
                lstCells.push(objSetup.data[x][objSetup.headers[i].fieldName]);
            }
            lstRows.push(lstCells);
        }
        return lstRows;
    },
    getInfo: function (component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var uniqueNameTable = 'Manual_Proposal_Summarize';
        if (inputObject.approvalMethod == 'Web') {
            component.set('v.enableContinue', true);
            uniqueNameTable = 'Web_Proposal_Summarize';
        }
        var action = component.get("c.getInfo");
        action.setParams({
            "oliId": inputObject.opportunityLineItem,
            "uniqueNameTable": uniqueNameTable

        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var objSetup = this.infoSetupObj(ret);
                var lstRows = this.infoRows(objSetup);
                objSetup['getInfoButtons'] = helper.getInfoButtons(inputObject.approvalMethod, ret.lstOppLineItem[0]);
                component.set('v.objSetup', objSetup);
                component.set('v.dataComi', lstRows);
                component.set('v.headersComi', objSetup.headers);

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
    setCotizaBeta: function () {
        return {
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
        }
    },
    setCotizador: function () {
        return {
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
        };
    },
    getInfoButtons: function (strType, objOli) {
        var returnObj = {
            'COTIZA Beta': this.setCotizaBeta(),
            'COTIZADOR': this.setCotizador()
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
        console.log('-----------auditRecordId------------', inputObject.auditRecordId);
        action.setParams({
            "auditRecordId": inputObject.auditRecordId,
            "storeHtml": storeHTML.innerHTML
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    helper.createQuotePdf(cmp, evt, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },
    createQuotePdf: function (component, evt, helper) {
        var inputObject = component.get('v.inputAttributes');
        var actionPdf = component.get("c.createPdf");
        actionPdf.setParams({
            "recordId": inputObject.recordId
        });
        actionPdf.setCallback(this, function (responsePdf) {
            var statePdf = responsePdf.getState();
            if (statePdf === "SUCCESS") {
                helper.closeMe(component, evt, helper);
            }
        });
        $A.enqueueAction(actionPdf);
    },
    htmlObject: function (inputObject, evt) {
        var today = new Date();
        var originalHtml = inputObject.htmlInput;
        inputObject.htmlInput = '';
        if (this.optionOneHtml(inputObject, evt)) {
            inputObject.htmlInput = String(today.getDate()).padStart(2, '0') + '/' + String(today.getMonth() + 1).padStart(2, '0') + '/' + today.getFullYear();
        } else if (this.optionTwoHTML(inputObject, evt)) {
            inputObject.htmlInput = '#validityDate#';
        } else if (this.optionThreeHTML(inputObject, evt)) {
            inputObject.htmlInput = '#Assigned_analyst#';
        } else if (this.optionFourHTML(inputObject, evt)) {
            inputObject.htmlInput = originalHtml;
        }
        return inputObject;
    },
    optionOneHtml: function (inputObject, evt) {
        return (inputObject.label === 'Last price quote date' || inputObject.label === 'Fecha de sanción') && (evt.target.id !== '2');
    },
    optionTwoHTML: function (inputObject, evt) {
        return (inputObject.label === 'validityDate' || inputObject.label === 'Validez TEA') && (evt.target.id === '1');
    },
    optionThreeHTML: function (inputObject, evt) {
        return inputObject.label === 'Assigned_analyst' || inputObject.label === 'Analista asignado';
    },
    optionFourHTML: function (inputObject, evt) {
        return inputObject.label !== 'validityDate' && inputObject.label !== 'Validez TEA' && inputObject.label !== 'Assigned_analyst' && inputObject.label !== 'Analista asignado';
    }
})
