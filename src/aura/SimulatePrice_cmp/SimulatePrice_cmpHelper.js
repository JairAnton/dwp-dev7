({
    closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    getInfo : function(cmp, evt){
        var inputObject = cmp.get('v.inputAttributes');
        var action = cmp.get("c.getInfo");
        action.setParams({
            "recordId" : inputObject.recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var teamin = ret.minimtea;
                var teasug = ret.sugtea;
                var spr = ret.spread;
                var generr = ret.genericError;
                var concattea = teasug + ','+ teamin + ','+spr;
                if(generr != undefined){
                    cmp.set('v.isError', true);
                    cmp.set('v.errorlst',generr);
                    cmp.set('v.hasHeader',false);
                }else{
                    cmp.set('v.hasHeader',true);
                    cmp.set('v.isError', false);
                    cmp.set('v.teaquote',concattea);
                }
            }
            cmp.set('v.recordOli',ret.oli);
            cmp.set('v.isLoad',true);
        });
        $A.enqueueAction(action);
    }
})