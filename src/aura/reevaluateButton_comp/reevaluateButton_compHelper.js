({
    closeMe : function(component, event) {
		component.destroy();
	},
    Reevaluar : function(component, event) {
        var inputObject = component.get('v.inputAttributes');
        var save_action = component.get("c.updateOpp");
        save_action.setParams({Idopp : inputObject.recordId });
        $A.enqueueAction(save_action);
        component.destroy();
 
	}
 
})
