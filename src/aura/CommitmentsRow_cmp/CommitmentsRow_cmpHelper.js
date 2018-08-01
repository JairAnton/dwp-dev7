({
	deleteRecord : function(cmp, evt, helper) {
		console.log('delete',cmp.get('v.row').id);
		
		var action = cmp.get("c.deleteCommitment");
		action.setParams({
			"recordId" : cmp.get('v.row').id
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var ret = response.getReturnValue();
				console.log('ret: ', ret);
				var compEvent = cmp.getEvent("CommitmentsDelete");
				compEvent.fire();
			}
		}); 
		$A.enqueueAction(action);
	}
})