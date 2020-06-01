({
    getInfo: function (cmp, event, helper) {
        var action = cmp.get('c.getInfoContainer');
        action.setParams({
            recordId: cmp.get('v.recordId')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                cmp.set('v.showSection', ret.showSection);
            }
        }));
        $A.enqueueAction(action);
    }
})
