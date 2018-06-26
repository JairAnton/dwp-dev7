({
    closeMe : function(component, event) {
        component.destroy();
    },
       ini : function(component, event) { 
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.start");
        action.setParams({recordId : inputObject.recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue()=="Risk"){ 
                    component.set('v.Risk', true);
                }
                if (response.getReturnValue()=="Price"){ 
                    component.set('v.Price', true);
                }
            }
        });
        
        $A.enqueueAction(action);                   
        
    },
    risk : function(component,event){
     
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.approveRisk");
        action.setParams({Id : inputObject.recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
                    if (state === "SUCCESS") {
               
            }
        });
        
        $A.enqueueAction(action);    
       

     var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId":inputObject.recordId,
            "slideDevName": "related"
        });
        urlEvent.fire();
        component.destroy();        
       }
    ,
    price : function(component,event){
        
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.approvePrice");
        action.setParams({Id : inputObject.recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
                    if (state === "SUCCESS") {
               
                  }
        });
        
        $A.enqueueAction(action);    
       

     var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId":inputObject.recordId,
            "slideDevName": "related"
        });
        urlEvent.fire();
        component.destroy();      
        
       
    }
    
 })