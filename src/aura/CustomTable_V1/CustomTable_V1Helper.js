({
    cotiza : function(component, event) {
        var action = component.get("c.getOportunidadSytem");
        action.setParams({
            "Filtro":component.get("v.recordId"),
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast"); 
                toastEvent.setParams({ 
                    title: "Success!",
                    message: "Cotizacion Realizada", 
                    type: "success" 
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
    } 
})