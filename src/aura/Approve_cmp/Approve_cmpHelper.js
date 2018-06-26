({
    closeMe : function(component, event) {
        component.destroy();
    },
    Reevaluar : function(component, event){
        var updateRisk = component.get('v.RiskVal');
        var updatePrice = component.get('v.PriceVal'); 
        var inputObject = component.get('v.inputAttributes');
        var save_action  
        if(updateRisk){
            save_action = component.get("c.setToRisk");  
        }
        else {
            if(updatePrice){  
                save_action = component.get("c.setToPrice");   
            }
            else{  
                save_action = component.get("c.updateOpp");   
            }}
        
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
            }
        });
        $A.enqueueAction(action);                   
        
    },
    risk : function(component,event){
    
        var cmpTarget1 = component.find('btnRisk');
		var cmpTarget2 = component.find('btnPrice');
		$A.util.removeClass(cmpTarget1, 'slds-button slds-button_neutral');	
		$A.util.removeClass(cmpTarget2, 'slds-button slds-button_success');

        $A.util.addClass(cmpTarget1, 'slds-button slds-button_success');
        $A.util.addClass(cmpTarget2, 'slds-button slds-button_neutral');
        
        component.set('v.RiskVal',true);
        component.set('v.PriceVal',false);

        
       }
    ,
    price : function(component,event){
        var cmpTarget1 = component.find('btnRisk');
		var cmpTarget2 = component.find('btnPrice');
		$A.util.removeClass(cmpTarget1, 'slds-button slds-button_success');	
		$A.util.removeClass(cmpTarget2, 'slds-button slds-button_neutral');

        $A.util.addClass(cmpTarget1, 'slds-button slds-button_neutral');
        $A.util.addClass(cmpTarget2, 'slds-button slds-button_success');
        
        component.set('v.RiskVal',false);
        component.set('v.PriceVal',true);        
            
        }
    
,
    
 })