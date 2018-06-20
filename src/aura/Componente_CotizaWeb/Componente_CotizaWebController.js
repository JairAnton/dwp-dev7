({
    init : function(cmp, event, helper) {
        if(cmp.get("v.toButton"))
            cmp.set("v.recordId",cmp.get("v.inputAttributes").recordId);
 
        cmp.set("v.title" , "Cotización");
        var action = cmp.get("c.getOportunityLineItemID");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
 
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.mydata", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
 
        var actionModality = cmp.get("c.getOportunityModality");
        actionModality.setParams({
            "Filtro":cmp.get("v.recordId")
        });
 
        actionModality.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.Modality", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(actionModality);
 
        helper.calculaProducto(cmp, event, helper);
    },
    cancel : function(cmp, event, helper) {
        cmp.set("v.hide" , true);
    },
    cotiza : function(cmp, event, helper) {
        helper.cotiza(cmp, event, helper);
    },
    recarga:function(cmp, event, helper) {
        helper.exit(cmp, event, helper);
    },
    continua:function(cmp, event, helper) {
        cmp.set("v.title" , "Compromiso");
        helper.gridDate(cmp, event);
        cmp.set("v.table" , true);
        cmp.set("v.formcoti" , false);
    },
    nuevo:function(cmp, event, helper) {
        cmp.set("v.truthy" , true);
        cmp.set("v.table" , false);
    },
    closenew:function(cmp, event, helper) {
        helper.gridDate(cmp, event);
        $A.get('e.force:refreshView').fire();
        cmp.set("v.table" , true);
        cmp.set("v.truthy" , false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            message: "Compromiso Terminada",
            type: "success"
        });
        toastEvent.fire();
    },
    continuaCotiza:function(cmp, event, helper) {
        cmp.set("v.title" , "Sancionar");
        cmp.set("v.table" , false);
        cmp.set("v.formcoti" , false);
        cmp.set('v.cotizaBeta',true);
    },
    doSancionar:function(cmp, event, helper) {
     helper.Sanciona(cmp, event);
    }
 
 
})
