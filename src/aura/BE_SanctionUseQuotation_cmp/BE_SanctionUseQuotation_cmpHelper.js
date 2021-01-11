({
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    },
    getComments : function(cmp, evt, helper) {
        var row = evt.getParam('selectedRows');
        cmp.set("v.idOli", row[0].Id);
        var action = cmp.get("c.getComments");
        action.setParams({
            "recordId" : row[0].OpportunityId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
            	cmp.set("v.comments", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    continue : function(cmp, evt, helper) {
    	var inputObject = cmp.get('v.inputAttributes');
    	var idOli = cmp.get('v.idOli');
    	var msgapprov = $A.get("$Label.c.approveSucess");
        var action = cmp.get("c.useQuotationPrice");
        action.setParams({
            "oppId" : inputObject.recordId,
    		"idOliSelected" : idOli
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    this.toastEvent('Success!', msgapprov, 'success');
                    $A.get('e.force:refreshView').fire();
                    helper.closeMe(cmp, event, helper);
                } else {
                    var lstError = [];
                    lstError.push(ret.errorMessage);
                    cmp.set('v.isOk', false);
                    cmp.set('v.isError', true);
                    cmp.set('v.hasHeader', false);
                    cmp.set('v.errorlst', lstError);
                }
            }
        });
        $A.enqueueAction(action);
    },
    toastEvent: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})
