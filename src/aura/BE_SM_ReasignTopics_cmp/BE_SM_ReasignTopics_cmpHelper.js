({
    getUsers : function(cmp, evt, helper) {
        var options = [];
        var recordId = cmp.get('v.recordId');
        var action = cmp.get("c.returnUsers");
        action.setParams({
            "slmtId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var conts = response.getReturnValue();
                for (var key in conts) {
                    options.push({value:key, label:conts[key]});
                }
                cmp.set("v.value",options[0].value);
                cmp.set("v.options",options);
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
    closeMethod : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    saveRecord : function(cmp, event, helper) {
        var recordId = cmp.get('v.recordId');
        var action = cmp.get("c.reasingTopics");
        action.setParams({
            "slmtId": recordId,
            "ownerId": cmp.get('v.value')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var ret;
            if(state === "SUCCESS") {
                ret = response.getReturnValue();
                var isSuccess = ret.isSuccess;
                if(isSuccess) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Exito!",
                        "message": "Temas asignados correctamente",
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
        $A.enqueueAction(action);
    }
})
