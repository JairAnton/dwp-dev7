({
    init : function(cmp, event, helper) {    
        console.log("cotiza "+cmp.get("v.recordId"));
        var action = cmp.get("c.getCompromisosSytem");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                cmp.set("v.rows", response.getReturnValue());                
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
    },
    cancel : function(cmp, event, helper) {
        cmp.set("v.table" , true);
        cmp.set("v.Controls" , false);
        $A.get('e.force:refreshView').fire();
    },
    nuevo:function(cmp, event, helper) {
        cmp.set("v.Controls" , true);
        cmp.set("v.table" , false);
    },
    closenew:function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
        cmp.set("v.table" , true);
        cmp.set("v.Controls" , false);
        var toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({ 
            title: "Success!",
            message: "Compromiso Creado", 
            type: "success" 
        });
        toastEvent.fire();
    }
})