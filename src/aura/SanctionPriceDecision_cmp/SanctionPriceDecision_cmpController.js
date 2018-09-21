({
	close : function(component, event, helper) {
		helper.closeMe(component, event, helper);
	},
	doInit : function(component, event, helper) {
		helper.getInfo(component, event, helper);
	},
	classChange : function(cmp, evt, helper){
        var objSetup = cmp.get('v.objSetup');
		objSetup['btnSelectConfig'] = objSetup['getInfoButtons'].lstButtons[parseInt(evt.target.id)];
		cmp.set('v.objSetup',objSetup);
		cmp.set('v.enableContinue',true);
	},
	doContinue : function(cmp, evt, helper){
		
        var inputAtt = cmp.get('v.inputAttributes');
        switch(inputAtt.approvalMethod) {
			case 'Web':
                helper.doContinueWeb(cmp, evt, helper);
				break;
			default:
				helper.doContinue(cmp, evt, helper);
		}
	}
})