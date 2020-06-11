({
	doInit: function (component, event, helper) {
		var action = component.get("c.getRecordIdSobject");
        action.setParams({"sObjType" : component.get("v.sObjTypeReference"),
                          "field" : component.get("v.fieldReference"),
                          "recordId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                component.set("v.idRecord", result);
                component.set("v.showCmp", true);
            } else {
                component.set("v.handleError", true);
                console.log("Error Be_RelatedSobject_Dynamic_Tablecontent_Cmp");
                console.log(JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
	}
})