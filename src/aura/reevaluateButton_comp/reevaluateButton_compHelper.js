({
    closeMe : function(component, event) {
        component.destroy();
    },
    Reevaluar : function(component, event) {
        var inputObject = component.get('v.inputAttributes');
        var save_action = component.get("c.updateOpp");
        save_action.setParams({Idopp : inputObject.recordId });
        $A.enqueueAction(save_action);
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId":inputObject.recordId,
            "slideDevName": "related"
        });
        urlEvent.fire();
        component.destroy();
        
    },
    ini : function(component, event) { 
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.start");
        action.setParams({Idopp : inputObject.recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue()=="Risk"){  
                    component.set('v.Risk', true);
                }
                if (response.getReturnValue()=="Price"){ 
                    component.set('v.Price', true);
                }
                if (response.getReturnValue()=="Both"){    
                    component.set('v.Price', true);
                    component.set('v.Risk', true);   
                }
            }
        });
        $A.enqueueAction(action);                   
        
    },
    risk : function(componet,event){
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.setToRisk");
        action.setParams({Idopp : inputObject.recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {}
            
        });},
    price : function(componet,event){
     var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.setToPrice");
        action.setParams({Idopp : inputObject.recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {}
            
        });
    
    }
                               
                               })