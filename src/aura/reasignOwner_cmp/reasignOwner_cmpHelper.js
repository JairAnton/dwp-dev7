({
    closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    ini : function(component,event) {
        var action = component.get("c.start");
        var inputObject = component.get('v.inputAttributes');
        action.setParams({
            'recordId' : inputObject.recordId
        })
        action.setCallback(this, function(response){
            var storeResponse = response.getReturnValue();
            var selectedUserGetFromEvent = event.getParam("recordByEvent");
            component.set("v.selectedRecord" , storeResponse);
            if(storeResponse!=null){              
                
                var forclose = component.find("lookup-pill");
                $A.util.addClass(forclose, 'slds-show');
                $A.util.removeClass(forclose, 'slds-hide');
                
                var forclose = component.find("searchRes");
                $A.util.addClass(forclose, 'slds-is-close');
                $A.util.removeClass(forclose, 'slds-is-open');
                
                var lookUpTarget = component.find("lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
                
                var lookUpicon = component.find("lookupIcon");
                $A.util.addClass(lookUpicon, 'slds-hide');
                $A.util.removeClass(lookUpicon, 'slds-show');
            }
        });
        component.set('v.isLoad',true);
        $A.enqueueAction(action);
        
    },
    searchHelper : function(component,event,getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchUser");
        var lstSearchRec = component.get("c.fetchUser");
        var inputObject = component.get('v.inputAttributes');
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'recordId': inputObject.recordId
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
    reasign : function(component, event, getInputkeyWord) { 
        var inputObject = component.get('v.inputAttributes');
        var recorduser = component.get("v.selectedRecord");
        var changeowner = component.get('c.reasignown');
        var msgreasign = $A.get("$Label.c.reasignSuccess");
        changeowner.setParams({
            'IdCase': inputObject.recordId,
            'recorduser': recorduser
        });        
        if(recorduser!=undefined){
            component.set('v.checkError',false);
            changeowner.setCallback(this, function(response){
                var state = response.getState();
                var ret = response.getReturnValue();
                var genericError = ret.genericError;
                var upd = ret.Updated;
                console.log('upd',upd);
                if (state === "SUCCESS") {
                    component.set('v.isLoad',true);
                    if(genericError != undefined){
                        component.set('v.isError', true);
                        component.set('v.errorlst',genericError);
                        component.set('v.hasHeader',false);
                    } else if (upd != "Updated"){
                        this.toastEvent('Error!', response.getReturnValue(), 'error');
                        component.set('v.hasHeader',true);
                        component.set('v.isError', false);
                        $A.get('e.force:refreshView').fire();
                    } else if (upd == "Updated"){
                        this.toastEvent('Success!', msgreasign, 'success');
                        component.set('v.hasHeader',true);
                        component.set('v.isError', false);
                        $A.get('e.force:refreshView').fire();
                    }                    
                    
                }
                
            });
            $A.enqueueAction(changeowner);
        }else{
            component.set('v.isLoad',false);
            component.set('v.checkError',true);
            var disabledButton = $A.get("e.c:disabledButton_evt");     
            disabledButton.setParams({ 
                "idOpp" : inputObject.recordId,
                "idButton" : 'idReasignOk',
            });
            disabledButton.fire();
        }
    },    
    toastEvent : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
})