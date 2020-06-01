({
    doInit: function (cmp, evt, helper) {
        var action = cmp.get("c.getInfo");
        action.setParams({
            "recordId": cmp.get('v.recordId'), "isOkLabel": 'isOk'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    cmp.set('v.values', ret.values);
                    cmp.set('v.isOk', true);
                } else {
                    cmp.set('v.isOk', false);
                }
            }
        });
        $A.enqueueAction(action);
    }, doContinue: function (cmp, evt, helper) {
        var storeHTML = document.getElementById('storeHTML');
        var toastEvent = $A.get("e.force:showToast");
        var msg = $A.get("$Label.c.PriceApprovalLetterCredit");
        toastEvent.setParams({
            "title": "Success!", "message": msg, "type": "success"
        });
        var action = cmp.get("c.doSave");
        action.setParams({
            "recordId": cmp.get('v.OpportunityId'), "storeHtml": storeHTML.innerHTML, "isOkLabel": 'isOk'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (ret.isOk) {
                    $A.get('e.force:refreshView').fire();
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    }
})
