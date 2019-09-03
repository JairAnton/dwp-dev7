({
    init: function(component){
        component.set("v.title" , "Compromiso");
        var flow = component.find("flowData");        
        var inputVariables = [{
            name :"ID_Init",
            type :"SObject",
            value :component.get("v.recordId")
        }];
        flow.startFlow("Compromisos",inputVariables);
    },
    destroyCmp: function (cmp, event, helper) {
        console.log("funciona");
        cmp.set("v.showModal",false);
    },
    handleStatusChange : function(component, event, helper) {
        if(event.getParam("status")==="FINISHED"){ 
            var toastEventF = $A.get("e.force:showToast");
            toastEventF.setParams({
                title: "Success!",
                message: "Cotizacion Terminada",
                type: "success"
            });
            toastEventF.fire();
            var outputVarF = component.get("v.recordId");  // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
            var urlEventF = $A.get("e.force:navigateToSObject");  // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
            urlEventF.setParams({
                "recordId": outputVarF,
                "slideDevName": "related"
            });
            urlEventF.fire();  // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
        }
        if(event.getParam("status")==="FINISHED_SCREEN"){
            var outputVar = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": outputVar,
                "slideDevName": "related"
            });
            urlEvent.fire();
        }
        if(event.getParam("status")==="ERROR"){
            var toastEventE = $A.get("e.force:showToast");   // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
            toastEventE.setParams({   // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
                title: "Error Message!",
                message: "Cotizacion Terminada",
                type: "error"
            });
            toastEventE.fire();   // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
            var outputVarE = component.get("v.recordId");  // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
            var urlEventE = $A.get("e.force:navigateToSObject");
            urlEventE.setParams({  // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
                "recordId": outputVarE,  // 2018/11/29 - 17:30 - CORRECCION DEUDA TECNICA
                "slideDevName": "related"
            });
            urlEventE.fire();
        }
    }
})
