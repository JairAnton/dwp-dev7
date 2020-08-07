({
    closeMe: function (component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        $A.get('e.force:refreshView').fire();
        cancelEvent.fire();
    },
    getInfo: function (cmp, evt) {
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.getInfo");
        action.setParams({
            "recordId": inputObject.recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var ret;
            var oli = '';
            if (state === "SUCCESS") {
                ret = response.getReturnValue();
                var teamin = ret.minimtea;
                var teasug = ret.sugtea;
                var rorc = ret.rorc;
                var raroec = ret.raroec;
                var spr = ret.spread;
                var generr = ret.genericError;
                var concattea = teasug + ',' + teamin + ',' + rorc + ',' + raroec + ',' + spr;
                oli = ret.oli;
                if (generr != undefined) {
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst', generr);
                    cmp.set('v.hasHeader', false);
                } else {
                    cmp.set('v.hasHeader', true);
                    cmp.set('v.isError', false);
                    cmp.set('v.teaquote', concattea);
                }
            }
            cmp.set('v.recordOli', oli);
            cmp.set('v.isLoad', true);
        });
        $A.enqueueAction(action);
    }
})