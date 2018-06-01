({
    producto : function(cmp, event, helper) {
        var action = cmp.get("c.getOportunidadSytem");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()==="Web"){
                    cmp.set("v.cotiweb" , true);
                }else {
                    cmp.set("v.cotiweb" , false);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
    }
})