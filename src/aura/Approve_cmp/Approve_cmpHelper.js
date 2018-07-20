({
    
    closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
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
        var msgapprov = $A.get("$Label.c.approveSucess");
        action.setParams({Id : inputObject.recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();       		
            if (state === "SUCCESS") {
                if(response.getReturnValue() != 'Updated'){
                    this.toastEvent('Error!', response.getReturnValue(), 'error');
                }else{
                    this.toastEvent('Success!', msgapprov, 'success');
                }
                $A.get('e.force:refreshView').fire();        
            }
        });
        
        $A.enqueueAction(action);
        
    }
    ,
    price : function(component,event){
        
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.approvePrice");
        var msgapprov = $A.get("$Label.c.approveSucess");
        action.setParams({Id : inputObject.recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() != 'Updated'){
                    this.toastEvent('Error!', response.getReturnValue(), 'error');
                }else{
                    this.toastEvent('Success!', msgapprov, 'success');
                }
                $A.get('e.force:refreshView').fire();        
            }
        });
        
        $A.enqueueAction(action);
        
        
    }
    ,    
    toastEvent : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
    
})