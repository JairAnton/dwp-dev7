({
    doInit : function(cmp, evt, helper){
        helper.getInfo(cmp, evt, helper);
    },
	toRed : function(component, event, helper) {
		
		// Navigate back to the record view
	    var homeEvent = $A.get("e.force:navigateToObjectHome");
	    homeEvent.setParams({
	        "scope": component.get('v.redirectObject')
	    });
	    homeEvent.fire();
	},
	cancel : function(cmp, evt, helper){

		// Navigate back to the record view
	    var homeEvent = $A.get("e.force:navigateToObjectHome");
	    homeEvent.setParams({
	        "scope": cmp.get('v.sObjectName')
	    });
	    homeEvent.fire();

	}
})