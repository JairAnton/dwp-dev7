({
	QueryMethod : function(component, event,var1) {
		var opp = component.get("v.recordId");
		
		var action = component.get("c.getVflasClient");
		action.setParams({
			"Idopp" : opp,
			"tipex" : var1,
		});  
		action.setCallback(this, function(response) {
			var state = response.getState();
            if (state === "SUCCESS") {
				component.set("v.varSaList", response.getReturnValue());
            }
		});
        $A.enqueueAction(action);
	}
})