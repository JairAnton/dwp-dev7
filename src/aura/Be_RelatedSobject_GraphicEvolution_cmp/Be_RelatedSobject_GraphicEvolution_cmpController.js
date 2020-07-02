({
	init : function(component,event, helper){
        var action = component.get("c.getRecordIdSobject");
        action.setParams({"sObjType" : component.get("v.sObjTypeReference"),
                          "field" : component.get("v.fieldReference"),
                          "recordId" : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if(state === "SUCCESS") {
                component.set("v.idRecord", result);
                helper.putFilters(component, event, helper);
                component.set("v.bGrafica",true);
            } else {
                component.set("v.handleError", true);
                console.log("Error Be_RelatedSobject_GraphicEvolution_cmp");
                console.log(JSON.stringify(result));
            }
        });
        $A.enqueueAction(action);
    },
	filtroGrafica : function(component,event,helper){
		component.set("v.bGrafica",false);
		component.set("v.sFiltro",component.find('selFiltro').get('v.value'));
		component.set("v.bGrafica",true);
    }
})
