({
	doInitRefreshView : function(component, event, helper) {
        if(window.location.href.includes(component.get('v.recordId'))){
			component.set('v.isLoad', false);
            //component.set('v.isLoad', true);
            showRefreshView(component,event);
        }
    },
    showRefreshView : function(component,event){
        component.set('v.isLoad', true);
    }
 })