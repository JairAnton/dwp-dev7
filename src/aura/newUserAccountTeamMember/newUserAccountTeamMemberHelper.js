({
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchUser");
        var lstSearchRec = component.get("c.fetchUser");
        var inputObject = component.get('v.inputAttributes');
		// set param to method 
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'recordId': component.get('v.recordId')
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
			var state = response.getState();
            if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
            }
            
        });
        // enqueue the Action  
        $A.enqueueAction(action);
        
    },  
    toastEvent : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    doSave : function(cmp, evt, helper){
        var objReturn = {'isOk':false};
        if(cmp.get('v.selectedRecord').Id!=undefined){
            cmp.set('v.checkError',false);
            objReturn['row'] = {
                                'recordId':Math.random().toString(),
                                'userId' : '/' + cmp.get('v.selectedRecord').Id,
                                'assistantId' : cmp.get('v.selectedRecord').Id,
                                'type' : 'new',
                                'userName' : cmp.get('v.selectedRecord').Name
                                };
            objReturn['isOk'] = true;
            
        }else{
            cmp.set('v.checkError',true);
            var disabledButton = $A.get("e.c:disabledButton_evt");     
            disabledButton.setParams({ 
                "idOpp" : cmp.get('v.recordId'),
                "idButton" : 'idSave',
            });
            disabledButton.fire();
        }
        return objReturn;
    }
})