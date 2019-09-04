({
    validateOwner : function(component, event, helper) {
        var action = component.get("c.validateSGof");
        action.setParams({"oppId" : component.get("v.inputAttributes.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(!res.isError) {
                    var cmpView = component.find("view");
                    cmpView.set("v.recordIdParent", component.get("v.inputAttributes.recordId"));
                    if(res.property === 'Empty' || res.property === 'Assigned') {
                        component.set("v.title", 'Reasignarse petición');
                        component.set("v.lblContinue", "Asignarmela");
                        cmpView.set("v.msgProperty", res.msg);
                        cmpView.set("v.dialog", res.dialog);
                        cmpView.set("v.showInterface", true);
                        component.set("v.loadView", true);
                        component.find("btnContinue").set("v.disabled", false);
                    } else {
                        helper.getInfo(component, event, helper);
                        component.set("v.lblContinue", "Continuar");
                        cmpView.set("v.showInterface", false);
                    }
                    cmpView.set("v.loadView", true);
                    component.set("v.loadView", true);
                    component.set("v.hasHeader", true);
                } else {
                    helper.msgAndClose(component, event, helper, res.msgError, '', true);
                }
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
    },
    reasignOwner : function(component, event, helper) {
    	var action = component.get("c.reasignCaseFromOpp");
        action.setParams({"oppId" :  component.get("v.inputAttributes.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var res = response.getReturnValue();
                if(!res.isError) {
                    helper.msgAndClose(component, event, helper, res.msgSuccess, 'success', true);
                } else {
                    helper.msgAndClose(component, event, helper, res.msgError, '', true);
                }
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
    },
    getInfo : function(component, event, helper) {
      	var action = component.get("c.getData");
        action.setParams({"oppId" : component.get("v.inputAttributes.recordId")});
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                var cmpView = component.find("view");
                if(!res.isError) {
                    cmpView.set("v.lblSend", res.lblSend);
                    cmpView.set("v.lblReturn", res.lblReturn);
                    cmpView.find("contractNumber").set("v.value", res.contractNumber);
                    cmpView.set("v.picklistValues", Object.values(res.picklistValues));
                    cmpView.set("v.mapPicklistValues", res.picklistValues);
                } else {
                    toastEvent.setParams({
                        "message": "$Label.Dwp_msgGenericError",
                        "type": "error"
                    });
                    toastEvent.fire();
                }
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
    },
    sentFormalize : function(component, event, helper) {
        const getKey = (obj,val) => Object.keys(obj).find(key => obj[key] === val);
		var action = component.get("c.sentToFormalize");
        var cmpView = component.find("view");
        var values = {"option" : cmpView.get("v.optionSelected"), "contractNumber" : cmpView.find("contractNumber").get("v.value"),
                      "comments" : cmpView.find("comments").get("v.value"), "fileName" : cmpView.get("v.fileName"),
                      "devolutionReason" : getKey(cmpView.get("v.mapPicklistValues"), cmpView.find("picklistField").get("v.value"))};
        action.setParams({
            "oppId" : component.get("v.inputAttributes.recordId"),
            "values" : JSON.stringify(values)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(res.success) {
                    if(res.listView) {
                        helper.redirect(component, event, helper, res.listView);
                    }
                    helper.msgAndClose(component, event, helper, res.msgSuccess, 'success', true);
                } else {
                    component.find("btnContinue").set("v.disabled", false);
                    cmpView.set("v.msgCorrection", res.errorMessage)
                    cmpView.set("v.showAlert", true);
                }
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
	},
    msgAndClose : function(component, event, helper, message, type, close) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": (message ? message : "$Label.Dwp_msgGenericError"),
            "type": (type ? type : "error")
        });
        toastEvent.fire();
        $A.get('e.force:refreshView').fire();
        if(close) {
            this.destroyCmp(component, event, helper);
        }
    },
    redirect : function(component, event, helper, listViewId) {
		var nav = $A.get("e.force:navigateToList");
        nav.setParams({
            "listViewId" : listViewId,
            "listViewName" : null,
            "scope" : "Case"
        });
        nav.fire();
    }

})