({
	newRecord: function (component, event, helper) {
		component.set('v.step', '2');
	},
	back: function (component, event, helper) {
		component.set('v.step', '1');
	},
	doSaveAssistent: function (component, event, helper) {
		var newRecord = component.find('newRecord');
		var responseNew = newRecord.saveAssistent();
		if (responseNew.isOk) {
			var lstCustom = component.get('v.lstDataCustom');
			lstCustom.push(responseNew.row);
			component.set('v.lstDataCustom', lstCustom);
			component.set('v.step', '1');
		}
	},
	changeStep: function (component, event, helper) {
		var strMessage = event.getParam("message");
		component.set('v.step', strMessage);
	},
	deleteRecords: function (cmp, evt, helper) {
		helper.doDeleteRecords(cmp, evt, helper);
	},
	save: function (cmp, evt, helper) {
		helper.saveAll(cmp, evt, helper);
	},
	init: function (cmp, event, helper) {
		helper.getData(cmp);
	},
	close: function (component, event, helper) {
		helper.closeMe(component, event, helper);
	}
})
