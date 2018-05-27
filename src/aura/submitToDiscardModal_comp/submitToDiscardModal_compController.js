({
    init: function(component){
        var inputObject = component.get('v.inputAttributes');  
        component.set('v.recordId',inputObject.recordId);   
        var flow = component.find("flowData");
        var inputVariables = [{
            name :"valor1",
            type :"SObject",
            value :component.get("v.recordId")
        }];
         
        flow.startFlow("Motivo_Descarte_Oportunidad_V0",inputVariables);
         
    },
	handleStatusChange : function(component, event, helper) {
        
        if(event.getParam("status")==="FINISHED"){
            
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