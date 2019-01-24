({
	deleteRecord : function(cmp, evt, helper) {
		
		var action = cmp.get("c.deleteCommitment");
		action.setParams({
			"recordId" : cmp.get('v.row').id
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				//var ret = response.getReturnValue(); // 2018/11/27 - 16:56 CORRECCION DEUDA TECNICA Ernesto
				var compEvent = cmp.getEvent("CommitmentsDelete");
				compEvent.fire();
			}
		}); 
		$A.enqueueAction(action);
	}
})