({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    },
    getInfo : function(component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.getInfoAnalist");
        action.setParams({
            "recordIdOppLineItem" : inputObject.opportunityLineItem
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var objSetup = {'nameProd': ret.lstOppLineItem[0].Product2.Name};
                if(!ret.lstInfoIsEmpty){
                    var lstTile = [];
                    
                    for(var i in ret.lstField){
                        var strValue = ret.lstInfo[0][ret.lstField[i]];
                        if(ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_values__c != undefined && ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_values__c!=''){
                            var lovValues = ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_values__c.split(',');
                            var lovLabels = ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__LoV_labels__c.split(',');
                            var posVal = lovValues.indexOf(strValue);
                            alert(lovValues);
                            alert(lovLabels);
                            
                            strValue = lovLabels[posVal];
                        }
                        var tile = {
                            'label': ret.mapMapfieldConfig[ret.lstField[i].toString()].fprd__Label__c,
                            'value': strValue
                        }
                        lstTile.push(tile);
                    }
                    objSetup['lstTile']=lstTile;
                }
                
                objSetup['getInfoButtons'] = helper.getInfoButtons(inputObject.approvalMethod, ret.caseOpen); 
				component.set('v.objSetup',objSetup);
				var objectInput = {
                    'IdOppLineItem':inputObject.opportunityLineItem,
					'approvalMethod':inputObject.approvalMethod,
                    'dinamicInput':'-'
                };
				component.set('v.objectInput',objectInput);
            }
            if(inputObject.approvalMethod === 'Web'){
                helper.removeColumns(component, event, helper);
             }
            component.set('v.isLoad',true);
            component.set('v.hasHeader',true);
            component.set('v.showSpinner',false);
        }); 
        $A.enqueueAction(action);
    },
    getInfoButtons : function(strType, hasCaseOpen) {
        var returnObj = {
            'COTIZADOR':{
                'lstButtons':[
                    {
                        'label':$A.get('$Label.c.OppPriceDecision06'),
                        'style':'koromiko',
                        'icon': 'utility:reply',
                        'id': '0',
                        'StageName':'04',
                        'opportunity_status_type':'13',
                        'styleAudit' : $A.get('$Label.c.AuditStyleDeny'),
                        'nameAudit' : $A.get('$Label.c.OppStatusLabel13'),
                        'elevateCase': false,
                        'statusCase': '04'
                    },
                    {
                        'label':$A.get('$Label.c.OppPriceDecision05'),
                        'style':'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName':'04',
                        'opportunity_status_type':'10',
                        'styleAudit' : $A.get('$Label.c.AuditStyleApprove'),
                        'nameAudit' : $A.get('$Label.c.OppStatusLabel10'),
                        'elevateCase': false,
                        'statusCase': '03'
                    }
                ]
            },
            'Tarifario':{
                'lstButtons':[
                    {
                        'label':$A.get('$Label.c.OppPriceDecision06'),
                        'style':'koromiko',
                        'icon': 'utility:reply',
                        'id': '0',
                        'StageName':'04',
                        'opportunity_status_type':'13',
                        'styleAudit' : $A.get('$Label.c.AuditStyleDeny'),
                        'nameAudit' : $A.get('$Label.c.OppStatusLabel13'),
                        'elevateCase': false,
                        'statusCase': '04'
                    },
                    {
                        'label':$A.get('$Label.c.OppPriceDecision05'),
                        'style':'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName':'04',
                        'opportunity_status_type':'10',
                        'styleAudit' : $A.get('$Label.c.AuditStyleApprove'),
                        'nameAudit' : $A.get('$Label.c.OppStatusLabel10'),
                        'elevateCase': false,
                        'statusCase': '03'
                    }
                ]
            },
            'Web':{
                'lstButtons':[
                    {
                        'label':$A.get('$Label.c.OppPriceDecision06'),
                        'style':'koromiko',
                        'icon': 'utility:reply',
                        'id': '0',
                        'StageName':'04',
                        'opportunity_status_type':'13',
                        'styleAudit' : $A.get('$Label.c.AuditStyleDeny'),
                        'nameAudit' : $A.get('$Label.c.OppStatusLabel13'),
                        'elevateCase': false,
                        'statusCase': '04',
                        'wsPhase': 'RETURN'
                    },
                    {
                        'label':$A.get('$Label.c.OppPriceDecision05'),
                        'style':'salem',
                        'icon': 'utility:check',
                        'id': '1',
                        'StageName':'04',
                        'opportunity_status_type':'10',
                        'styleAudit' : $A.get('$Label.c.AuditStyleApprove'),
                        'nameAudit' : $A.get('$Label.c.OppStatusLabel10'),
                        'elevateCase': false,
                        'statusCase': '03',
                        'wsPhase': 'APPROVE'
                    }
                ]
            },
        };
        if(hasCaseOpen){
            returnObj['Tarifario'].lstButtons.push({
                'label':$A.get('$Label.c.OppPriceDecision02'),
                'style':'science-blue',
                'icon': 'utility:share',
                'id': '2',
                'StageName':'04',
                'opportunity_status_type':'09',
                'styleAudit' : $A.get('$Label.c.AuditStyleElevate'),
                'nameAudit' : $A.get('$Label.c.OppStatusLabel09'),
                'elevateCase': true,
                'statusCase': '02'
            });
            returnObj['COTIZADOR'].lstButtons.push({
                'label':$A.get('$Label.c.OppPriceDecision02'),
                'style':'science-blue',
                'icon': 'utility:share',
                'id': '2',
                'StageName':'04',
                'opportunity_status_type':'09',
                'styleAudit' : $A.get('$Label.c.AuditStyleElevate'),
                'nameAudit' : $A.get('$Label.c.OppStatusLabel09'),
                'elevateCase': true,
                'statusCase': '02'
            });
            returnObj['Web'].lstButtons.push({
                'label':$A.get('$Label.c.OppPriceDecision02'),
                'style':'science-blue',
                'icon': 'utility:share',
                'id': '2',
                'StageName':'04',
                'opportunity_status_type':'09',
                'styleAudit' : $A.get('$Label.c.AuditStyleElevate'),
                'nameAudit' : $A.get('$Label.c.OppStatusLabel09'),
                'elevateCase': true,
                'statusCase': '02',
                'wsPhase': 'RAISE'
            });
        }
        return returnObj[strType];
    },
    doContinue : function(cmp, evt, helper) {
        cmp.set('v.hasHeader',false);
        cmp.set('v.showSpinner',true);
        var storeHTML = document.getElementById('storeHTML');
        var objSetup = cmp.get('v.objSetup');
        var inputObject = cmp.get('v.inputAttributes');
        //$A.get('e.force:refreshView').fire();
        var action = cmp.get("c.saveDecisionAnalist");
        action.setParams({
            "recordId" : inputObject.recordId,
            "statusOpp" : objSetup['btnSelectConfig'].opportunity_status_type,
            "stageName" : objSetup['btnSelectConfig'].StageName,
            "elevateCase" : objSetup['btnSelectConfig'].elevateCase,
            "styleAudit" : objSetup['btnSelectConfig'].styleAudit,
            "nameAudit" : objSetup['btnSelectConfig'].nameAudit,
            "strComments" : null,
            "recordOli" : cmp.get('v.objectInput').IdOppLineItem,
            "lstApiField" : inputObject['lstApiField'],
            "lstValue" : inputObject['lstvalueField'],
            "statusCase" : objSetup['btnSelectConfig'].statusCase,
            "storeHtml" : storeHTML.innerHTML,
            "approvalMethod" : inputObject.approvalMethod,
            "wsPhase" : objSetup['btnSelectConfig'].wsPhase,
            "validDate" : inputObject.validityDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if(ret.isOk){
                    alert(ret.getQuote);
                    alert(inputObject.changeDate);
                    //if(ret.getQuote && !inputObject.changeDate && inputObject.option==='1'){
                    if(ret.getQuote){
                        if(inputObject.changeDate){
                            alert('no getquote1');
                        	helper.gotoListView(cmp, evt, helper);
                        }
                        else{
                            alert('getquote');
                            inputObject['auditDetailId'] = ret.auditDetailId;
                            cmp.set('v.inputAttributes', inputObject);
                            helper.getQuote(cmp, evt, helper);
                        }
                    }
                    else{
                        alert('no getquote2');
                        helper.gotoListView(cmp, evt, helper);
                    }
                }else{
                    var lstError = [];
                    lstError.push(ret.errorMessage);
                    cmp.set('v.isOk',false);
                    cmp.set('v.hasHeader',false);
                    cmp.set('v.lstError',lstError);
                    cmp.set('v.showSpinner',false);
                }
            }
        }); 
        $A.enqueueAction(action);

    },
    removeColumns : function(cmp, evt, helper) {
        var headers = cmp.get('v.inputAttributes').headerinput.slice();
        headers.splice(1,2);
        cmp.set('v.lstHeadersHtml', headers);
    },
    gotoListView : function(component, evt, helper) {
        var action = component.get("c.redirect");
        action.setParams({});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if(!res.isError){
                    var nav = $A.get("e.force:navigateToList");
                    nav.setParams({
                        "listViewId" : res.listView.Id,
                        "listViewName" : null,
                        "scope" : "Case"
                    });
                    nav.fire();
                } else {
                    helper.closeMe(cmp, evt, helper);
                }
            } else {
                helper.closeMe(cmp, evt, helper);
            }
        });
        $A.enqueueAction(action);
    },
    getQuote : function(component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.saveValidityDate");
        alert(inputObject.opportunityLineItem);
        alert(inputObject.auditDetailId);
        alert(inputObject.validityDate);
        action.setParams({
            "idOLI" : inputObject.opportunityLineItem,
            "auditDetailId" : inputObject.auditDetailId,
            "validDate" : inputObject.validityDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.gotoListView(component, event, helper);
            }
        }); 
        $A.enqueueAction(action);
    },
})