({
    init: function (component, event) {
        component.set("v.load", false);
        if (component.get('v.replaceId')) {
            var action = component.get("c.getAP");
            action.setParams({
                "recordId": component.get('v.recordId')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                if (state === "SUCCESS") {
                    if (result === null || result === undefined) {
                        component.set("v.error", true);
                        component.set("v.load", true);
                    } else {
                        component.set("v.parentId", result[0].acpl__participant_id__c);
                        component.set("v.load", true);
                    }
                } else {
                    component.set("v.error", true);
                    component.set("v.load", true);
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.parentId", component.get('v.recordId'));
            component.set("v.load", true);
        }
    },

    refreshOnAura: function (component, event) {
        $A.get('e.force:refreshView').fire();
    }
})