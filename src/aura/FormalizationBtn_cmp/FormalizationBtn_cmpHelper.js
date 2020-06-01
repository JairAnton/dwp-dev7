({
    closeMe: function (component, event) {
        component.destroy();
    },
    Formalization: function (component, event) {
        var inputObject = component.get('v.inputAttributes');
        var save_action = component.get("c.updateOpp");
        save_action.setParams({ Idopp: inputObject.recordId });
        $A.enqueueAction(save_action);
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId": inputObject.recordId,
            "slideDevName": "related"
        });
        urlEvent.fire();
        component.destroy();
    }
})
