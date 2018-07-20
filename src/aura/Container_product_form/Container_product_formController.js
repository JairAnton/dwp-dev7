({
	doInit : function(component, event, helper) {
		helper.onInit(component)
	},
	doInitRefreshViewEvent : function(component, event, helper) {
        if (window.location.href.includes(cmp.get('v.recordId')) {
            helper.onInit(component);
        }
    }
})