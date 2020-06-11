({
	doInit : function(component, event, helper) {
        var jsonAllowed = {"profiles": component.get("v.exceptionProfile"), 
							"users": component.get("v.exceptionUsers")};
		var recordId = component.get("v.recordId");
        var action = component.get("c.getRecordToRedirect");
        action.setParams({"allowedView" : JSON.stringify(jsonAllowed), "sObjectType" : component.get("v.currentSObjectType"), 
                          "recordId" : recordId, "fieldName": component.get("v.fieldName")});
        action.setCallback(this, function(response){
            var status = response.getState();
            console.log('json => '+JSON.stringify(jsonAllowed));
            if(status === 'SUCCESS') {
                var result = response.getReturnValue();
                if(result.isSuccess) {
                    helper.redirectTo(component, event, helper, result);
                } else {
                    component.set("v.handleError", true);
                }
            } else {
                let errors = response.getError();
                console.log('Error: => '+errors[0].message);
                component.set("v.handleError", true);
            }
        });
        $A.enqueueAction(action);
	}
})