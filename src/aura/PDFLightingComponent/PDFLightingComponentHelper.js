({
    closeMe : function(component, event) {
		component.destroy();
	},
    PDF : function(component, event) {
        var inputObject = component.get('v.inputAttributes');
        var save_action = component.get("c.PDF_formalization");
        save_action.setParams({recordId : inputObject.recordId});
        save_action.setCallback(this, function(response) {
         var state = response.getReturnValue();
           if (state === "SUCCESS") {
       
        var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
          		"recordId":inputObject.recordId,
          		"slideDevName": "related"
                });
            urlEvent.fire();
            component.destroy();
         }else{
                alert(state);
           }
        
        });
        $A.enqueueAction(save_action);
 
 
    }
})
