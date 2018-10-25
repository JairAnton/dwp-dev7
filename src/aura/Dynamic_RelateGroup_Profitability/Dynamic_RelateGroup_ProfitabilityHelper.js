({
	ConsultaProducto_helper : function(component, event) {
        var items = [];
		var opp = component.get("v.recordId");
        var action = component.get("c.recuperaServicio");
        action.setParams({
            "idAccount" : opp
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arr = response.getReturnValue();
                arr.forEach(function(element) {
                    items.push({ value: element, label: element });
                });
                component.set("v.options", items);
            }
        });
        $A.enqueueAction(action);
	},
    BtnNeutral: function(component, event, helper){
        component.find("BtnTotal").set("v.variant", "Neutral");
        component.find("BtnPEN").set("v.variant", "Neutral");
        component.find("BtnUSD").set("v.variant", "Neutral");
    }
})
