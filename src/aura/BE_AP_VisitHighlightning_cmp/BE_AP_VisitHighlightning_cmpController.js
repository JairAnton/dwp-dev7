({
    init: function (component, event) {
        component.set("v.load", false);
        component.set("v.error", false);
        var action = component.get("c.getVisitValues");
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var result = response.getReturnValue();
            if (state === "SUCCESS") {
                var titles = component.get("v.titles");
                var values = [];
                if(result !== null && result !== undefined) {
                    for (var i = 0; i < result.length; i++) {
                        values.push({ 'title': titles[i], 'value': result[i] });
                    }
                    component.set("v.values", values);
                    component.set("v.load", true);
                } else {
                    component.set("v.error", true);
                }
            } else {
                component.set("v.error", true);
            }
        });
        $A.enqueueAction(action);
    }
})
