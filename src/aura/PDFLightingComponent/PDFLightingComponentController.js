({
    /*doInit : function(component, event, helper) {
        var action = component.get('c.validateUser');
        action.setParams({'recordId' : component.get('v.inputAttributes.recordId')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var res = response.getReturnValue();
                if(!res.isError) {
                    if(res.property === 'Empty' || res.property === 'Assigned') {
                        component.set("v.title", 'Reasignarse petición');
                        component.set("v.msgProperty", res.msg);
                        component.set("v.dialog", res.dialog);
                        component.set("v.showInterface", true);
                    } else {
                        component.set("v.showInterface", false);
                    }
                    component.set("v.hasHeader", true);
                    component.set("v.validate", true);
                } else {
                    helper.msgAndClose(component, event, helper, res.msgError, '', true);
                }
            } else {
               helper.msgAndClose(component, event, helper, '', '', true);
            }
        });
        $A.enqueueAction(action);
    },
    close : function(component, event, helper) {
	 	helper.closeMe(component, event, helper);
	},*/
    doPDF: function (component, event, helper) {
        helper.PDF(component, event, helper);
        /*if(component.get("v.showInterface")) {
            helper.reasignCase(component, event, helper);
        } else {
            helper.PDF(component, event,helper);
        }*/
    },
    close: function (component, event, helper) {
        helper.closeMe(component, event);
    }
})
