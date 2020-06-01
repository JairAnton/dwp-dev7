({
    doInitRefreshView: function (component, event, helper) {
        if (window.location.href.includes(component.get('v.recordId'))) {
            component.set('v.isLoad', false);
            helper.showRefreshView(component, event);
        }
    }
})
