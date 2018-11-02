({
    close : function(component, event, helper) {
        helper.closeMe(component, event, helper);
    },
    doReasign : function(component, event, helper) {
        helper.doResetError(component);
        helper.reasign(component, event, helper);
    },    
    doIni : function(component, event, helper) {
        helper.doResetError(component);
        helper.ini(component, event, helper);
    },
    onfocus : function(component,event,helper){
        helper.doResetError(component);
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = (component.find("searchRes").length === undefined?component.find("searchRes"):component.find("searchRes")[0]);
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        helper.doResetError(component);
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selection 
    clear :function(component,event,helper){        
        helper.doClear(component, event);
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        helper.doResetError(component);
        // get the selected User record from the COMPONETN event 	 
        var selectedUserGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedUserGetFromEvent); 
        
        var forclose = (component.find("lookup-pill").length === undefined ? component.find("lookup-pill") : component.find("lookup-pill")[0]);
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = (component.find("searchRes").length === undefined ? component.find("searchRes") : component.find("searchRes")[0]);
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = (component.find("lookupField").length === undefined ? component.find("lookupField") : component.find("lookupField")[0]);
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
        
        var lookUpicon = (component.find("lookupIcon").length === undefined ? component.find("lookupIcon") : component.find("lookupIcon")[0]);
        $A.util.addClass(lookUpicon, 'slds-hide');
        $A.util.removeClass(lookUpicon, 'slds-show');        
    },
})