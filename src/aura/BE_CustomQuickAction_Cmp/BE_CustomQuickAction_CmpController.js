({
    doInit: function (cmp, evt, helper) {
        helper.getSettings(cmp, evt, helper);
    },
    handleSubmitCustom: function (cmp, evt, helper) {
        evt.preventDefault();
        var fields = evt.getParam('fields');
        var initialsObject = { "sobjectType": cmp.get('v.sObjectType')};
        switch (cmp.get("v.settings").modeAction) {
            case 'view':
                helper.callApexMethod(cmp, evt, JSON.stringify(initialsObject),cmp.get("c.readRecord"))
                break;
            case 'create': 
                var sObjectCreate = Object.assign(initialsObject, fields);
                helper.callApexMethod(cmp, evt, sObjectCreate,cmp.get("c.createRecord"));
                break;
            case 'update':
                initialsObject.Id = cmp.get('v.recordId');
                var sObjectUpdate = Object.assign(initialsObject, fields);
                helper.callApexMethod(cmp, evt, JSON.stringify(sObjectUpdate),cmp.get("c.updateRecord"));
                break;
            case 'delete':
                initialsObject.Id = cmp.get('v.recordId');
                helper.callApexMethod(cmp, evt, JSON.stringify(initialsObject),cmp.get("c.deleteRecord"));
                break;
        }
    },
    closeModal: function (cmp, evt, helper) {
        helper.closeModal(cmp, evt, null);
    }
})