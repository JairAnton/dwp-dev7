({
    ini: function (component, event, helper) {
        var record = component.get('v.recordId');
        var action = component.get('c.AccountProfit');
        action.setParams({
            "recordId": record
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var str = response.getReturnValue();
                component.set('v.newAccountProfit', str);
            }
        });
        $A.enqueueAction(action);
    }
})
