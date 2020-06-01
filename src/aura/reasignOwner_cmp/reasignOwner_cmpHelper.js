({
    closeMe: function (component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    ini: function (component, event) {
        component.set('v.checkError', false);
        component.set('v.isError', false);
        var action = component.get("c.start");
        var inputObject = component.get('v.inputAttributes');
        action.setParams({
            'recordId': inputObject.recordId
        })
        action.setCallback(this, function (response) {
            var storeResponse = response.getReturnValue();
            var selectedUserGetFromEvent = event.getParam("recordByEvent");
            component.set("v.selectedRecord", storeResponse);
            if (storeResponse != null) {
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
        component.set('v.isLoad', true);
        $A.enqueueAction(action);
    },
    searchHelper: function (component, event, getInputkeyWord) {
        component.set('v.isError', false);
        // call the apex class method
        var action = component.get("c.fetchUser");
        var lstSearchRec = component.get("c.fetchUser");
        var inputObject = component.get('v.inputAttributes');
        var forOpen = component.find("searchRes");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'recordId': inputObject.recordId
        });
        // set a callBack    
        action.setCallback(this, function (response) {
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
    reasign: function (component, event, helper) {
        var inputObject = component.get('v.inputAttributes');
        var recorduser = component.get("v.selectedRecord");
        var changeowner = component.get('c.reasignown');
        var msgreasign = $A.get("$Label.c.reasignSuccess");
        component.set('v.isLoad', false);
        component.set('v.hasHeader', false);
        changeowner.setParams({
            'IdCase': inputObject.recordId,
            'recorduser': recorduser
        });
        if (recorduser != undefined && recorduser != null) {
            component.set('v.checkError', false);
            changeowner.setCallback(this, function (response) {
                var state = response.getState();
                var ret = response.getReturnValue();
                var genericError = ret.genericError;
                var upd = ret.Updated;
                if (state === "SUCCESS") {
                    if (genericError != undefined) {
                        component.set('v.isLoad', true);
                        component.set('v.isError', true);
                        component.set('v.errorlst', genericError);
                        component.set('v.hasHeader', false);
                    } else if (upd != "Updated") {
                        this.toastEvent('Error!', response.getReturnValue(), 'error');
                        component.set('v.isError', false);
                        $A.get('e.force:refreshView').fire();
                    } else if (upd == "Updated") {
                        this.toastEvent('Success!', msgreasign, 'success');
                        component.set('v.isError', false);
                        $A.get('e.force:refreshView').fire();
                    }
                }
            });
            $A.enqueueAction(changeowner);
        } else {
            component.set('v.isLoad', true);
            component.set('v.checkError', true);
            component.set('v.hasHeader', true);
            var disabledButton = $A.get("e.c:disabledButton_evt");
            disabledButton.setParams({
                "idOpp": inputObject.recordId,
                "idButton": 'idReasignOk',
            });
            disabledButton.fire();
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            component.set('v.isError', false);
            helper.doClear(component, event);
        }
    },
    toastEvent: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    doClear: function (component, event) {
        var pillTarget = (component.find("lookup-pill").length == undefined ? component.find("lookup-pill") : component.find("lookup-pill")[0]);
        var lookUpTarget = (component.find("lookupField").length == undefined ? component.find("lookupField") : component.find("lookupField")[0]);
        var lookUpicon = (component.find("lookupIcon").length == undefined ? component.find("lookupIcon") : component.find("lookupIcon")[0]);

        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');

        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');

        $A.util.addClass(lookUpicon, 'slds-show');
        $A.util.removeClass(lookUpicon, 'slds-hide');

        component.set("v.SearchKeyWord", null);
        component.set("v.listOfSearchRecords", null);
        component.set("v.selectedRecord", null);
    },
    doResetError: function (component) {
        component.set('v.checkError', false);
        component.set('v.isError', false);
    }
})
