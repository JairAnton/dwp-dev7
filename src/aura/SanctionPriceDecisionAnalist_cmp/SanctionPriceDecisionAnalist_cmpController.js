({
	close : function(component, event, helper) {
		helper.closeMe(component, event, helper);
	},
	doInit : function(component, event, helper) {
		helper.getInfo(component, event, helper);
	},
	classChange : function(cmp, evt, helper) {
        var objSetup = cmp.get('v.objSetup');
		objSetup['btnSelectConfig'] = objSetup['getInfoButtons'].lstButtons[parseInt(evt.target.id)];
		cmp.set('v.objSetup',objSetup);
		cmp.set('v.enableContinue',true);
	},
	doContinue : function(cmp, evt, helper) {
		helper.doContinue(cmp, evt, helper);
	}
})