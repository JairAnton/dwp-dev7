({
    closeMe : function(component, event) {
		component.destroy();
	},
    PDF : function(component, event) {
        var inputObject = component.get('v.inputAttributes');        
        var save_action = component.get("c.PDF_formalization");
        save_action.setParams({recordId : inputObject.recordId});      
        $A.enqueueAction(save_action);
        var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
          		"recordId":inputObject.recordId,
          		"slideDevName": "related"
                });
            urlEvent.fire();
        component.destroy();
	
	}
    
})