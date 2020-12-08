({
    doInit : function(cmp, evt, helper) {
        helper.getTypes(cmp, evt);
    },
    close : function(cmp, evt) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
		homeEvent.setParams({
			"scope": cmp.get('v.sObjectName')
		});
		homeEvent.fire();
    },
    doContinue: function(cmp, evt, helper) {
        helper.loadForm(cmp, evt);
    }
})
