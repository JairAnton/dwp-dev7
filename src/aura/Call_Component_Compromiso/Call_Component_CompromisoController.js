({
    init: function(component){
        component.set("v.title" , "Compromiso");
        //component.set("v.recordId" ,component.get("v.inputAttributes").recordId);
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
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Success!",
                message: "Cotizacion Terminada", 
                type: "success" 
            });
            toastEvent.fire(); 
            var outputVar = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": outputVar,
                "slideDevName": "related"
            });
            urlEvent.fire();
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
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Error Message!",
                message: "Cotizacion Terminada", 
                type: "error" 
            });
            toastEvent.fire(); 
            var outputVar = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": outputVar,
                "slideDevName": "related"
            });
            urlEvent.fire();
        }
        
    }
})