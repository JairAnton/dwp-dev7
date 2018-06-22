({
    init: function(component){
        var flow = component.find("flowData");
        var inputVariables = [{
            name :"valor1",
            type :"SObject",
            value :component.get("v.inputAttributes").recordId
        }];
         console.log('log0');
        flow.startFlow("Motivo_Descarte_Oportunidad_V0",inputVariables);
         console.log('log1');
    },
	handleStatusChange : function(component, event, helper) {
        
        if(event.getParam("status")==="FINISHED"){
            console.log('log3');
            var outputVar = component.get("v.inputAttributes").recordId;
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
          		"recordId": outputVar,
          		"slideDevName": "related"
        	});
            urlEvent.fire();
        }
	}
})