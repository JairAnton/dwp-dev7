({
	deleteRecord : function(cmp, evt, helper) {
		var action = cmp.get("c.deleteCommitment");
		action.setParams({
			"recordId" : cmp.get('v.row').id
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var compEvent = cmp.getEvent("CommitmentsDelete");
				compEvent.fire();
			}
		});
		$A.enqueueAction(action);
	}
})