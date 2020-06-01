({
    onInit: function (component) {
        var editJsonValue = { "style": "neutral", "unactiveStyle": "hidden", "active": true };
        var newJsonValue = { "style": "neutral", "unactiveStyle": "hidden", "active": true };
        var deleteJsonValue = { "style": "neutral", "unactiveStyle": "hidden", "active": true };
        var action = component.get('c.getActions');
        action.setParams({
            recordId: component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                editJsonValue["active"] = result.key;
                newJsonValue["active"] = result.key2;
                deleteJsonValue["active"] = result.key3;
                component.set('v.isLoad', false);
                component.set('v.editJsonValue', JSON.stringify(editJsonValue));
                component.set('v.newJsonValue', JSON.stringify(newJsonValue));
                component.set('v.deleteJsonValue', JSON.stringify(deleteJsonValue));
                component.set('v.isLoad', true);
                component.set('v.strErrorMessage', result.dataCW.errorMessage);
                component.set('v.showBanner', result.dataCW.showWarning);
            }
        });
        $A.enqueueAction(action);
    },
    onInit2: function (component) {
        var action = component.get('c.getActions');
        action.setParams({
            recordId: component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.strErrorMessage', result.dataCW.errorMessage);
                component.set('v.showBanner', result.dataCW.showWarning);
            }
        });
        $A.enqueueAction(action);
    },
    showComponentView: function (component) {
        component.set('v.isLoad', true);
    }
})
