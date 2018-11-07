({
	doInit : function(component, event, helper) {
		helper.onInit(component);
	},
    doInitRefreshView : function(component, event, helper) {
        if(window.location.href.includes(component.get('v.recordId'))){
            component.set('v.isLoad', false);
            helper.onInit(component);
        }
    },
    handleSaveEvent : function(component, event, helper) {
        if(window.location.href.includes(component.get('v.recordId'))){
            helper.onInit2(component);
        }
        var appEvent = $A.get("e.dwp_dbpn:RefreshDynamicButtonCollection_evt"); 
        appEvent.setParams({ "contextId" : component.get('v.recordId'), "buttonsCollectionsIdsList": "OppDynamicButtonCollection" });
        appEvent.fire();
    }
})