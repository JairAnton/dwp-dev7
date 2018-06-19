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
                    message: "Compromiso Terminada",
                    type: "success"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
 
    },
    exit : function(cmp, event) {
        var outputVar = cmp.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId": outputVar,
            "slideDevName": "related"
        });
        urlEvent.fire();
    },
    reload : function(cmp, event) {
        var outputVar = component.get("v.recordId");
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId": outputVar,
            "slideDevName": "related"
        });
        urlEvent.fire();
    },
    calculaProducto : function(cmp, event) {
        var action = cmp.get("c.getOportunidadSytem");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
 
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()==="Web"){
                    cmp.set("v.cotiweb" , true);
                }else if(response.getReturnValue()==="Tarifario"){
                    cmp.set("v.cotiTarif" , true);
                }else if(response.getReturnValue()==="COTIZADOR"){
                    cmp.set("v.coticoti" , true);
                }else{
                    cmp.set("v.cotiweb" , false);
                    cmp.set("v.cotiTarif" , false);
                    cmp.set("v.coticoti" , false);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
		var now = new Date();
        var nowtime=($A.localizationService.formatDate(now, "YYYY-MM-DDTHH:mm:ss.SSSZ"));
        cmp.set("v.Today",nowtime);

    },
    gridDate: function(cmp, event){
        var action = cmp.get("c.getCompromisosSytem");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
 
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.rows", null);
                cmp.set("v.rows", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
    },
    Sancionar : function(component, event) {
      var action = cmp.get("c.sancionar");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
 
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.rows", null);
                cmp.set("v.rows", response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
 
    }
 
})
