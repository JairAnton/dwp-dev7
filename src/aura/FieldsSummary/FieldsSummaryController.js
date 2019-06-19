({
	doContinue : function(cmp, evt, helper) {
        var action = cmp.get("c.doSave");
        action.setParams({
            "recordId" : cmp.get('v.OpportunityId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                if(ret.isOk) {
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(action);
	}
})