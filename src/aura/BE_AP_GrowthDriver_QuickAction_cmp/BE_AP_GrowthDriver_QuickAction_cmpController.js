({
	doInit: function (component, event, helper) {
		component.set("v.load", false);
		component.set("v.error", false);
		var action = component.get("c.getMetadataConfig");
		action.setParams({
			"recordId": component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				if (result.isSuccess) {
					let targetHeadActions;
					if (result) {
						targetHeadActions = JSON.parse(result.data).values;
						targetHeadActions.forEach(element => {
							element.label = element.label['es'];
							element.fields.forEach(field => {
								switch (field.value) {
									case "recordId":
										field.value = component.get('v.recordId');
										break;
									default:
										break;
								}
							});
						});
					}
					component.set("v.modalSet", targetHeadActions[0]);
					component.set("v.load", true);
				} else {
					component.set("v.error", true);
					console.log(JSON.stringify(result))
				}
			} else {
				component.set("v.error", true);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	handleCloseStanModal: function (component, event) {
		$A.get("e.force:closeQuickAction").fire();
		if(event.getParam('isDML')) {
			$A.get('e.force:refreshView').fire();
		}
    }
})