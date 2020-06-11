({
    doInit: function (component, event, helper) {
        var action = component.get('c.validateSGof');
        action.setParams({ 'oppId': component.get('v.inputAttributes.recordId') });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (!res.isError) {
                    if (res.property === 'Empty' || res.property === 'Assigned') {
                        component.set("v.msgProperty", res.msg);
                        component.set("v.dialog", res.dialog);
                        component.set("v.hasHeader", true);
                        component.set("v.validate", true);
                    } else {
                        helper.productUnit(component, event, helper);
                    }
                } else {
                    helper.msgAndClose(component, event, helper, res.msgError, '', true);
                }
            } else {
                helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
    },
    asignCase: function (component, event, helper) {
        var action = component.get('c.reasignCaseFromOpp');
        action.setParams({ "oppId": component.get('v.inputAttributes.recordId') });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (!res.isError) {
                    helper.msgAndClose(component, event, helper, res.msgSuccess, 'success', true);
                } else {
                    helper.msgAndClose(component, event, helper, res.msgError, '', true);
                }
            } else {
                helper.msgAndClose(component, event, helper, false, false, true);
            }
        });
        $A.enqueueAction(action);
    },
    close: function (component, event, helper) {
        component.destroy();
    }
})
