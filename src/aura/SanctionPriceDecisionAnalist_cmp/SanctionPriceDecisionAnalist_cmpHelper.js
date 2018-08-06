({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    },
    getInfo : function(component, event, helper){
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
            component.set('v.isLoad',true);
        }); 
        $A.enqueueAction(action);
    },
    getInfoButtons : function(strType, hasCaseOpen){
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
            }
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
        }
        return returnObj[strType];
    },
    doContinue : function(cmp, evt, helper){
        var objSetup = cmp.get('v.objSetup');
        var inputObject = cmp.get('v.inputAttributes');
        //$A.get('e.force:refreshView').fire();
        var action = cmp.get("c.saveDecisionAnalist");
        action.setParams({
            "recordId" : inputObject.recordId,
            "status_opp" : objSetup['btnSelectConfig'].opportunity_status_type,
            "stageName" : objSetup['btnSelectConfig'].StageName,
            "elevateCase" : objSetup['btnSelectConfig'].elevateCase,
            "styleAudit" : objSetup['btnSelectConfig'].styleAudit,
            "nameAudit" : objSetup['btnSelectConfig'].nameAudit,
            "strComments" : cmp.get('v.strComments'),
            "recordOli" : cmp.get('v.objectInput').IdOppLineItem,
            "lstApiField" : inputObject['lstApiField'],
            "lstValue" : inputObject['lstvalueField'],
            "statusCase" : objSetup['btnSelectConfig'].statusCase
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if(ret.isOk){
                    $A.get('e.force:refreshView').fire();
                    helper.closeMe(cmp, evt, helper);
                }
            }
        }); 
        $A.enqueueAction(action);

    }
})