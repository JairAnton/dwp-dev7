({
	init : function(component,event, helper){
        var action = component.get("c.getUrlPage");
        var params = {"reportDeveloperName": component.get('v.reportName'), "sObjType": component.get("v.sObjTypeReference"), 
                      "field": component.get("v.fieldReference"), "recordId" : component.get("v.recordId")};
        action.setParams({"params" : JSON.stringify(params)});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                if(result.isError) {
                    component.set("v.handleError", true);
                } else {
                    component.set("v.url", result.url);
                	component.set("v.showReport", true);
                }
            } else {
                component.set("v.handleError", true);
                console.log("Error Be_Dynamic_ReportChart_cmp");
                console.log(JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
	}
})
