({
	onInit : function(component) {
        
        
        var editJsonValue = {"style" : "neutral", "unactiveStyle": "hidden", "active": true};
        var newJsonValue = {"style" : "neutral", "unactiveStyle": "hidden", "active": true};
        var deleteJsonValue = {"style" : "neutral", "unactiveStyle": "hidden", "active": true};
		var action = component.get('c.getActions');
        action.setParams({
            recordId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                console.log(result);
                
                editJsonValue["active"] = result.key;
                newJsonValue["active"] = true;
                deleteJsonValue["active"] = result.key3;
                
                component.set('v.editJsonValue', JSON.stringify(editJsonValue));
                component.set('v.newJsonValue', JSON.stringify(newJsonValue));
                component.set('v.deleteJsonValue', JSON.stringify(deleteJsonValue));
                
                component.set('v.isLoad', true);
            }
        });
        $A.enqueueAction(action);
        
        /*
        
		var action = component.get('c.getActions');
        action.setParams({
            recordId : component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                for(var s=0;s<result.size;s++) {
                    if(result[s] === 'editProduct'){
                        editJsonValue["active"] = true;
                    }
                    if(result[s] === 'addProduct'){
                        newJsonValue["active"] = true;
                    }
                    if(result[s] === 'deleteProduct'){
                        deleteJsonValue["active"] = true;
                    }
                }
                
                console.log('editJsonValue ', editJsonValue);
                console.log('deleteJsonValue ', deleteJsonValue);
                console.log('newJsonValue ', newJsonValue);
				
            }
            
        });
        $A.enqueueAction(action);
        */
	}
})