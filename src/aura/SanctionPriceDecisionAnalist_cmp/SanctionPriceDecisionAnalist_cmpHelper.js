({
    closeMe: function (component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    getInfo: function (component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var uniqueNameTable = 'Manual_Proposal_Summarize';
        if (inputObject.approvalMethod === 'Web') {
            uniqueNameTable = 'Web_Proposal_Summarize';
        }
        var action = component.get("c.getInfoAnalist");
        action.setParams({
            "oliId": inputObject.opportunityLineItem,
            "uniqueNameTable": uniqueNameTable
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var objSetup = { 'nameProd': ret.lstOppLineItem[0].Product2.Name };
                objSetup['lstTile'] = JSON.parse(ret.lstSummarize)
                objSetup['getInfoButtons'] = helper.getInfoButtons(inputObject.approvalMethod, ret.caseOpen);
                component.set('v.objSetup', objSetup);
                var objectInput = {
                    'IdOppLineItem': inputObject.opportunityLineItem,
                    'approvalMethod': inputObject.approvalMethod,
                    'dinamicInput': '-',
                    'headercommission': 
                    [
                        {label: 'COMISIÓN', fieldName: 'Product_Commission_Name__c', type: 'text'},
                        {label: 'SOLICITADO (%)', fieldName: 'Requested_Rate_Value__c', type: 'text'},
                        {label: 'AUTORIZADO (%)', fieldName: 'Authorized_Rate_Value__c', type: 'text'},
                        {label: 'COMISIÓN FINAL', fieldName: 'Commission_Calculation_Amount__c', type: 'text'}
                    ],
                    'comissions': ret.comissions
 
                };
                component.set('v.objectInput', objectInput);
				component.set('v.commissions', ret.commilist);
            }
            if (inputObject.approvalMethod === 'Web') {
                helper.removeColumns(component, event, helper);
            }
            component.set('v.isLoad', true);
            component.set('v.hasHeader', true);
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
    },
    getInfoButtons: function (strType, hasCaseOpen) {
        var returnObj = {
            'COTIZADOR': {
                'lstButtons': [
                    {
                        'label': $A.get('$Label.c.OppPriceDecision06'),
                        'style': 'koromiko',
                        'icon': 'utility:reply',
                        'id': '0',
                        'StageName': '04',
                        'opportunity_status_type': '13',
                        'styleAudit': $A.get('$Label.c.AuditStyleDeny'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel13'),
                        'elevateCase': false,
                        'statusCase': '04'
                    },
                    {
                        'label': $A.get('$Label.c.OppPriceDecision05'),
                        'style': 'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName': '04',
                        'opportunity_status_type': '10',
                        'styleAudit': $A.get('$Label.c.AuditStyleApprove'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel10'),
                        'elevateCase': false,
                        'statusCase': '03'
                    }
                ]
            },
            'Tarifario': {
                'lstButtons': [
                    {
                        'label': $A.get('$Label.c.OppPriceDecision06'),
                        'style': 'koromiko',
                        'icon': 'utility:reply',
                        'id': '0',
                        'StageName': '04',
                        'opportunity_status_type': '13',
                        'styleAudit': $A.get('$Label.c.AuditStyleDeny'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel13'),
                        'elevateCase': false,
                        'statusCase': '04'
                    },
                    {
                        'label': $A.get('$Label.c.OppPriceDecision05'),
                        'style': 'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName': '04',
                        'opportunity_status_type': '10',
                        'styleAudit': $A.get('$Label.c.AuditStyleApprove'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel10'),
                        'elevateCase': false,
                        'statusCase': '03'
                    }
                ]
            },
            'Web': {
                'lstButtons': [
                    {
                        'label': $A.get('$Label.c.OppPriceDecision06'),
                        'style': 'koromiko',
                        'icon': 'utility:reply',
                        'id': '0',
                        'StageName': '04',
                        'opportunity_status_type': '13',
                        'styleAudit': $A.get('$Label.c.AuditStyleDeny'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel13'),
                        'elevateCase': false,
                        'statusCase': '04',
                        'wsPhase': 'RETURN'
                    },
                    {
                        'label': $A.get('$Label.c.OppPriceDecision05'),
                        'style': 'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName': '04',
                        'opportunity_status_type': '10',
                        'styleAudit': $A.get('$Label.c.AuditStyleApprove'),
                        'nameAudit': $A.get('$Label.c.OppStatusLabel10'),
                        'elevateCase': false,
                        'statusCase': '03',
                        'wsPhase': 'APPROVE'
                    }
                ]
            },
        };
        if (hasCaseOpen) {
            returnObj['Tarifario'].lstButtons.push({
                'label': $A.get('$Label.c.OppPriceDecision02'),
                'style': 'science-blue',
                'icon': 'utility:share',
                'id': '2',
                'StageName': '04',
                'opportunity_status_type': '09',
                'styleAudit': $A.get('$Label.c.AuditStyleElevate'),
                'nameAudit': $A.get('$Label.c.OppStatusLabel09'),
                'elevateCase': true,
                'statusCase': '02'
            });
            returnObj['COTIZADOR'].lstButtons.push({
                'label': $A.get('$Label.c.OppPriceDecision02'),
                'style': 'science-blue',
                'icon': 'utility:share',
                'id': '2',
                'StageName': '04',
                'opportunity_status_type': '09',
                'styleAudit': $A.get('$Label.c.AuditStyleElevate'),
                'nameAudit': $A.get('$Label.c.OppStatusLabel09'),
                'elevateCase': true,
                'statusCase': '02'
            });
            returnObj['Web'].lstButtons.push({
                'label': $A.get('$Label.c.OppPriceDecision02'),
                'style': 'science-blue',
                'icon': 'utility:share',
                'id': '2',
                'StageName': '04',
                'opportunity_status_type': '09',
                'styleAudit': $A.get('$Label.c.AuditStyleElevate'),
                'nameAudit': $A.get('$Label.c.OppStatusLabel09'),
                'elevateCase': true,
                'statusCase': '02',
                'wsPhase': 'RAISE'
            });
        }
        return returnObj[strType];
    },
    doContinue: function (cmp, evt, helper) {
        cmp.set('v.hasHeader', false);
        cmp.set('v.showSpinner', true);
        var storeHTML = document.getElementById('storeHTML');
        var objSetup = cmp.get('v.objSetup');
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.saveDecisionAnalist");
        action.setParams({
            "jsonParams": JSON.stringify({
                "recordId": inputObject.recordId,
                "statusOpp": objSetup['btnSelectConfig'].opportunity_status_type,
                "stageName": objSetup['btnSelectConfig'].StageName,
                "styleAudit": objSetup['btnSelectConfig'].styleAudit,
                "nameAudit": objSetup['btnSelectConfig'].nameAudit,
                "strComments": null,
                "recordOli": cmp.get('v.objectInput').IdOppLineItem,
                "statusCase": objSetup['btnSelectConfig'].statusCase,
                "storeHtml": storeHTML.innerHTML,
                "approvalMethod": inputObject.approvalMethod,
                "wsPhase": objSetup['btnSelectConfig'].wsPhase,
                "validDate": inputObject.validityDate
            }),
            "elevateCase": objSetup['btnSelectConfig'].elevateCase,
            "lstApiField": inputObject['lstApiField'],
            "lstValue": inputObject['lstvalueField']
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    helper.gotoListView(cmp, evt, helper);
                } else {
                    var lstError = [];
                    lstError.push(ret.errorMessage);
                    cmp.set('v.isOk', false);
                    cmp.set('v.hasHeader', false);
                    cmp.set('v.lstError', lstError);
                    cmp.set('v.showSpinner', false);
                }
            }
        });
        $A.enqueueAction(action);

    },
    removeColumns: function (cmp, evt, helper) {
        var headers = cmp.get('v.inputAttributes').headerinput.slice();
        headers.splice(1, 2);
        cmp.set('v.lstHeadersHtml', headers);
    },
    gotoListView: function (component, evt, helper) {
        var action = component.get("c.redirect");
        action.setParams({});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (!res.isError) {
                    helper.createQuotePdf(component, evt, res);
                } else {
                    helper.closeMe(component, evt, helper);
                }
            } else {
                helper.closeMe(component, evt, helper);
            }
        });
        $A.enqueueAction(action);
    },
    createQuotePdf: function (component, evt, res) {
        var inputObject = component.get('v.inputAttributes');
        var actionPdf = component.get("c.createPdf");
        actionPdf.setParams({
            "recordId": inputObject.recordId
        });
        actionPdf.setCallback(this, function (responsePdf) {
            var statePdf = responsePdf.getState();
            if (statePdf === "SUCCESS") {
                var nav = $A.get("e.force:navigateToList");
                nav.setParams({
                    "listViewId": res.listView.Id,
                    "listViewName": null,
                    "scope": "Case"
                });
                nav.fire();
            }
        });
        $A.enqueueAction(actionPdf);
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