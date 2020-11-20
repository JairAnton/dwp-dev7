({
	doRedirect : function(cmp, event, helper) {
        var action = cmp.get("c.getRecordTypeId");
        action.setParams({
            "developerName" : cmp.get("v.recordTypeDevName")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var createTaskEvent = $A.get("e.force:createRecord");
                createTaskEvent.setParams({
                    "entityApiName": "Task",
                    "defaultFieldValues": {
                        'slmt__management_plan_meeting_id__c' : cmp.get("v.recordId")
                    },
                    "recordTypeId": response.getReturnValue(),
                    "navigationLocation": "RELATED_LIST"
                });
                createTaskEvent.fire();
            }
        });
        $A.enqueueAction(action);
	}
})