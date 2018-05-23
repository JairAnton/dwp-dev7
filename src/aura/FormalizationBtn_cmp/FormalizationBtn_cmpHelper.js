({
    closeMe : function(component, event) {
		component.destroy();
	},
    Formalization : function(component, event) {
        var inputObject = component.get('v.inputAttributes');        
        var save_action = component.get("c.updateOpp");
        save_action.setParams({Idopp : inputObject.recordId });
        $A.enqueueAction(save_action);
        alert('la oportunidad se ha mandado a formalizacíon ');
        component.destroy();
	
	}
    
})