({
    closeMe: function (component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    Reevaluate: function (component, event) {
        var updateRisk = component.get('v.RiskVal');
        var updatePrice = component.get('v.PriceVal');
        var inputObject = component.get('v.inputAttributes');
        var save_action;
        var callService;
        component.set('v.isLoad', false);
        component.set('v.hasHeader', false);
        if (updateRisk) {
            save_action = component.get("c.setToRisk");
        } else if (updatePrice) {
            save_action = component.get("c.setToPrice");
        }
        if (save_action != undefined) {
            save_action.setParams({ Idopp: inputObject.recordId });
            save_action.setCallback(this, function (response) {
                var state = response.getState();
                var ret = response.getReturnValue();
                if (state === "SUCCESS") {
                    var genericError = ret.genericError;
                    if (genericError != undefined) {
                        component.set('v.isError', true);
                        component.set('v.errorlst', genericError);
                        component.set('v.hasHeader', false);
                        component.set('v.isLoad', true);
                    } else if (ret.Updated != "Updated") {
                        this.toastEvent('Error!', response.getReturnValue(), 'error');
                        $A.get('e.force:refreshView').fire();
                    } else if (ret.Updated == "Updated") {
                        this.deletPdf(component, event, ret.idDocument);
                    }
                }
            });
            $A.enqueueAction(save_action);
        } else {
            component.set('v.isLoad', false);
            var disabledButton = $A.get("e.c:disabledButton_evt");
            disabledButton.setParams({
                "idOpp": inputObject.recordId,
                "idButton": 'idReevaluateOk',
            });
            disabledButton.fire();
        }
    },
    deletPdf: function (component, event, idDocDel) {
        var msgreeval = $A.get("$Label.c.reevalSuccess");
        var deletePdfAction = component.get("c.deleteQuotePdf");
        deletePdfAction.setParams({ idDoc: idDocDel });
        deletePdfAction.setCallback(this, function (response) {
            var state = response.getState();
            var ret = response.getReturnValue();
            if (state === "SUCCESS") {
                var genericError = ret.genericError;
                if (genericError !== undefined) {
                    component.set('v.isError', true);
                    component.set('v.errorlst', genericError);
                    component.set('v.hasHeader', false);
                    component.set('v.isLoad', true);
                } else {
                    this.toastEvent('Success!', msgreeval, 'success');
                    $A.get('e.force:refreshView').fire();
                }
            }
        });
        $A.enqueueAction(deletePdfAction);
    },
    ini: function (component, event) {
        var inputObject = component.get('v.inputAttributes');
        var action = component.get("c.start");
        action.setParams({ Idopp: inputObject.recordId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var ret = response.getReturnValue();
            var msg = ret.msg;
            if (state === "SUCCESS") {
                var genericError = ret.genericError;
                if (genericError != undefined) {
                    component.set('v.isError', true);
                    component.set('v.errorlst', genericError);
                    component.set('v.hasHeader', false);
                } else if (msg == "Risk") {
                    component.set('v.Risk', true);
                    component.set('v.hasHeader', true);
                    component.set('v.isError', false);
                } else if (msg == "Price") {
                    component.set('v.Price', true);
                    component.set('v.hasHeader', true);
                    component.set('v.isError', false);
                } else if (msg == "Both") {
                    component.set('v.Price', true);
                    component.set('v.Risk', true);
                    component.set('v.hasHeader', true);
                    component.set('v.isError', false);
                }
            }
            component.set('v.isLoad', true);
        });
        $A.enqueueAction(action);
    },
    risk: function (component, event) {
        var cmpTarget1 = component.find('btnRisk');
        var cmpTarget2 = component.find('btnPrice');
        $A.util.removeClass(cmpTarget1, 'slds-button slds-button_neutral');
        $A.util.removeClass(cmpTarget2, 'slds-button slds-button_success');

        $A.util.addClass(cmpTarget1, 'slds-button slds-button_success');
        $A.util.addClass(cmpTarget2, 'slds-button slds-button_neutral');

        component.set('v.RiskVal', true);
        component.set('v.PriceVal', false);
    },
    price: function (component, event) {
        var cmpTarget1 = component.find('btnRisk');
        var cmpTarget2 = component.find('btnPrice');
        $A.util.removeClass(cmpTarget1, 'slds-button slds-button_success');
        $A.util.removeClass(cmpTarget2, 'slds-button slds-button_neutral');

        $A.util.addClass(cmpTarget1, 'slds-button slds-button_neutral');
        $A.util.addClass(cmpTarget2, 'slds-button slds-button_success');

        component.set('v.RiskVal', false);
        component.set('v.PriceVal', true);
    },
    toastEvent: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})
