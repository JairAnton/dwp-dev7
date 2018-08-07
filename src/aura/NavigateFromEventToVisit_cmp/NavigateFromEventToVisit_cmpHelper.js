({
	initCmp : function(component, event, helper) {
        console.log('Navigate To');
		var action = component.get("c.getInfo");
		action.setParams({eventId: component.get('v.recordId')});
		action.setCallback(this, function(response){
			if (component.isValid() && response.getState() === "SUCCESS") {
                var ret = response.getReturnValue();
                if(ret!==''){
                	var navEvt = $A.get("e.force:navigateToSObject");
	                    navEvt.setParams({
	                        "recordId": ret,
	                        "slideDevName": "detail"
	                    });
	               	navEvt.fire();
                }
            }
            else{
                var mensaje = $A.get("$Label.c.lblErrorRetrievingVisit") + ' (Cmp: NavigateToEventVisita. Method: getInfo)';
                var toastError = $A.get("e.force:showToast");
                    toastError.setParams({
                            "title": "Error!",
                            "type": "error",
                            "message": mensaje
                    });
                toastError.fire();
            }
		});
		$A.enqueueAction(action);
	},
})