({
    redirectTo : function(component, event, helper, result) {
        if(!result.stayPage) {
            if((result.redirectTo === null || result.redirectTo === undefined || result.redirectTo === '')
              && component.get("v.redirectInFieldNull")) {
                helper.redirectToTab(component, event, component.get("v.redirectSObjectType"));
            } else if(result.redirectTo !== null && result.redirectTo !== undefined && result.redirectTo !== ''){
                helper.redirectToRecord(component, event, result.redirectTo);
            }
        }
	},
    redirectToTab : function(component, event, sobjType) {
		var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({"scope": sobjType});
        homeEvent.fire();
	},
	redirectToRecord : function(component, event, redirectTo) {
		var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({"recordId": redirectTo, "slideDevName": "detail"
    });
    navEvt.fire();
	}
})