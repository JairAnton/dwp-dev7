({
    getInfo : function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        var action = cmp.get("c.getStatusMeeting");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var ret = response.getReturnValue();
                if(ret.isSuccess) {
                    cmp.set('v.summary', ret.summary);
                    cmp.set('v.isError', false);
                } else {
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst', ret.message);
                }
            } else {
                cmp.set('v.isError', true);
                cmp.set('v.errorlst', 'Error inesperado, por favor comuniquese con su administrador.');
            }
        });
        $A.enqueueAction(action);
    },
    saveMethod : function(cmp, event, helper) {
        helper.saveRecord(cmp, event, helper);
    },
    saveCloneMethod : function(cmp, event, helper) {
        helper.saveRecord(cmp, event, helper);
        var navService = cmp.find("navService");
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: cmp.get('v.recordId'),
                objectApiName: 'slmt__Sales_Meeting__c',
                actionName: 'clone'
            }
        };
        event.preventDefault();
        navService.navigate(pageReference);
    },
    closeMethod : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    saveRecord : function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        var action = cmp.get("c.finalizeMeeting");
        action.setParams({
            "recordId": recordId,
            "summary": cmp.get('v.summary')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var ret;
            if(state === "SUCCESS") {
                ret = response.getReturnValue();
                var isSuccess = ret.isSuccess;
                if(isSuccess) {
                    helper.createMinutePdf(cmp, event);
                } else {
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst', ret.message);
                }
            } else {
                cmp.set('v.isError', true);
                cmp.set('v.errorlst', 'Error inesperado, por favor comuniquese con su administrador.');
            }
        });
        $A.enqueueAction(action);
    },
    createMinutePdf: function (cmp, evt) {
        var recordId = cmp.get('v.recordId');
        var actionSendMinute = cmp.get("c.sendMinute");
        actionSendMinute.setParams({
            "recordId": recordId
        });
        actionSendMinute.setCallback(this, function(response) {
            var state = response.getState();
            var ret;
            if(state === "SUCCESS") {
                ret = response.getReturnValue();
                var isSuccess = ret.isSuccess;
                if(isSuccess) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Exito!",
                        "message": "Reunión finalizada satisfactoriamente",
                        "type" : "success"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                } else {
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst', ret.message);
                }
            } else {
                cmp.set('v.isError', true);
                cmp.set('v.errorlst', 'Error inesperado, por favor comuniquese con su administrador.');
            }
        });
        $A.enqueueAction(actionSendMinute);
    }
})