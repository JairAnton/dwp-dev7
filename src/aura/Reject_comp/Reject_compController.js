({
	init: function (component, event, helper) {
		helper.doInit(component, event, helper);
	},
	close: function (component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
	onChangeRejectReason: function (component, event, helper) {
		if (event.getSource().get("v.value") == '02' || event.getSource().get("v.value") == '03') {
			component.set("v.Box1", true);
			component.set("v.Box2", false);
		}
		else if (event.getSource().get("v.value") == '05') {
			component.set("v.Box1", false);
			component.set("v.Box2", true);
		}
		else {
			component.set("v.Box1", false);
			component.set("v.Box2", false);
		}
	},
	save: function (component, evt, helper) {
		helper.doSave(component, evt, helper);
	}
})