({
    Inits :function(component, event, helper) {
        var oppId = component.get("v.inputAttributes").recordId; 
        var actionOLI = component.get("c.getOppLI");  
        var saveSIO = component.get("c.saveSIO"); 
        
        actionOLI.setParams({
            "opp":oppId                     
        });
        actionOLI.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.recordOLI", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionOLI); 
		var a = component.get('c.InitValidateModali'); 
        $A.enqueueAction(a);
    },
    setValue : function(component, event, helper) {
        var fieldValue; 
        fieldValue= component.find('input_modal').get('v.value');
        (fieldValue=='Inside line')?component.set("v.showButton", true):component.set("v.showButton", false);      
        (fieldValue=='Requires authorization')?component.set("v.showSIO", true):component.set("v.showSIO", false);          
        var a = component.get('c.rerender'); 
        var action = component.get('c.getTasks');   
        var st = component.get('v.searchText'); 
        action.setParams({
            "val":st                     
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.mydata', response.getReturnValue());       
            }
        });
        $A.enqueueAction(action);    
        $A.enqueueAction(a);
    },
    renderload :function(component,event,helper){
        var fieldValue; 
        fieldValue= component.find('input_modal').get('v.value');
        (fieldValue=='Inside line')?component.set("v.showButton", true):component.set("v.showButton", false);      
        (fieldValue=='Requires authorization')?component.set("v.showSIO", true):component.set("v.showSIO", false);          
    },
    rerender : function(component,event,helper){
        this.reRender();
    },
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    saveModel: function(component, event, helper) { 
        var sel;  
        sel = component.get("v.selectedRow")
        component.set("v.isOpen", false);
        component.set("v.saveRow",sel);
        var oppId = component.get("v.inputAttributes").recordId; 
        var saveSIO = component.get('c.saveSIO');   
        saveSIO.setParams({
            "opp":oppId,
            "savedRow":sel
        });  
        saveSIO.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Etapa y estado actualizado correctamente ",
                    type: "success"
                });
                toastEvent.fire();
                var outputVar = component.get("v.inputAttributes").recordId;
                var urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    "recordId": outputVar,
                    "slideDevName": "related"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(saveSIO); 
    }, 
    selectedRow: function(component,event){
        var sel;
        sel = event.getSource().get("v.value");  
        component.set("v.selectedRow",sel);
        var a = component.get('c.rerender'); 
        $A.enqueueAction(a);  
    }, 
    sendApprove:function(component){
        var sendApproval = component.get('c.sendApproval'); 
        var oppId = component.get("v.inputAttributes").recordId;        
        sendApproval.setParams({
            "opp":oppId
        }); 
        sendApproval.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Etapa y estado actualizado correctamente ",
                    type: "success"
                });
                toastEvent.fire();
                var outputVar = component.get("v.inputAttributes").recordId;
                var urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    "recordId": outputVar,
                    "slideDevName": "related"
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(sendApproval);    
    },
    InitValidateModali: function(component){
        var oppId = component.get("v.inputAttributes").recordId; 
        var requestModality = component.get("c.requestModality"); 
        requestModality.setParams({
            "opp":oppId
        });
        requestModality.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var fro=response.getReturnValue();
                console.log('Valida '+(fro));
                if(fro!='' && fro!=null){
                    (fro=='Inside line')?component.set("v.showButton", true):component.set("v.showButton", false);      
                    (fro=='Requires authorization')?component.set("v.showSIO", true):component.set("v.showSIO", false);            
                    component.find('input_modal').set('v.value', fro);
                    console.log('Vl'+(component.find('input_modal').get('v.value')));
                }
            }
        });
        $A.enqueueAction(requestModality); 
    }
})