({
    doInit: function (cmp, evt, helper) {
        helper.getSettings(cmp, evt, helper);
    },
    handleSubmitCustom: function (cmp, evt, helper) {
        evt.preventDefault();
        var fields = evt.getParam('fields');
        var initialsObject = { "sObjectType": cmp.get('v.sObjectType')};
        var actionApex;
        switch (cmp.get("v.settings").modeAction) {
            case 'view':
                actionApex=cmp.get("c.readRecord");
                break;
            case 'create':
                actionApex=cmp.get("c.createRecord");
                var sObjectCreate = Object.assign(initialsObject, fields);
                break;
            case 'update':
                actionApex=cmp.get("c.updateRecord");
                initialsObject.Id = cmp.get('v.recordId');
                var sObjectUpdate = Object.assign(initialsObject, fields);
                helper.updatesObject(cmp, evt, JSON.stringify(sObjectUpdate),actionApex);
                break;
            case 'delete':
                actionApex=cmp.get("c.deleteRecord");
                initialsObject.Id = cmp.get('v.recordId');
                break;
        }
    },
    closeModal: function (cmp, evt, helper) {
        helper.closeModal(cmp, evt);
    }
})