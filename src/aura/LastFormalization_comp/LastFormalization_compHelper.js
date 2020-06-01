({
    handleShowToast: function (cmp, event, helper) {
        $A.util.removeClass(cmp.find('divToast'), "slds-hide");
        window.setTimeout(
            $A.getCallback(function () {
                if (cmp.isValid()) {
                    $A.util.addClass(cmp.find('divToast'), "slds-is-relative");
                }
            }), 0
        );
    },
    bringData: function (cmp, evt, helper) {
        var inputObject = cmp.get('v.inputAttributes');
        cmp.set('v.recordId', inputObject.recordId);
        var OpportunityId = cmp.get("v.recordId");
    },
    Actions: function (component, event, helper) {
        component.find("btnContinue").set("v.disabled", true);
        var OpportunityId = component.get("v.recordId");
        var action = component.get("c.setLastFormalization");
        var sanAction = component.get("v.Action");
        var body = component.find("txtComments").get("v.value");
        var ContractNumber = component.find("txtContract").get("v.value");

        if ((sanAction == 'btnApprove' && ContractNumber.length > 0) || (sanAction == 'btnRaise') || (sanAction == 'btnBack' && body.length > 0)) {
            action.setParams({
                "OpportunityId": OpportunityId,
                "Action": sanAction,
                "Body": body,
                "ContractNumber": ContractNumber
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue().success == true) {
                        $A.get('e.force:refreshView').fire();
                        helper.navigateToRecord(component, event, helper);
                    } else if (response.getReturnValue().showErrorMessage) {
                        component.set('v.errorlst', response.getReturnValue().errorMessage);
                        component.set('v.optionToDisplay', '02');
                        component.set('v.hasHeader', false);
                    }
                } else if (state === "INCOMPLETE" || state === "ERROR") {
                    component.find("btnContinue").set("v.disabled", false);
                    component.set("v.errMessage", response.getReturnValue());
                    helper.handleShowToast(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        } else {
            if (sanAction == 'btnApprove') {
                component.set("v.errMessage", "El número de contrato es obligatorio.");
                helper.handleShowToast(component, event, helper);
            } else {
                component.set("v.errMessage", "El comentario es obligatorio.");
                helper.handleShowToast(component, event, helper);
            }
        }
    },
    navigateToRecord: function (component, event, helper) {
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: component.get("v.recordId"),
            slideDevName: "SEGUIMIENTO"
        });
        navEvent.fire();
    }
    ,
    getContractNumber: function (component, event, helper) {
        var action = component.get("c.getOppContractNumber");
        action.setParams({ "oppId": component.get("v.inputAttributes.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find("txtContract").set("v.value", response);
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "message": (message ? message : "$Label.Dwp_msgGenericError"),
                    "type": (type ? type : "error")
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})
