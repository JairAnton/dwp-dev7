({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            { label: 'Nombre', fieldName: 'nameUrl', type: 'url', typeAttributes: { label: { fieldName: "name" }, target: '_self' } },
            { label: 'Correo', fieldName: 'email', type: 'Email' },
            { label: 'Teléfono', fieldName: 'phone', type: 'phone' },
            { label: 'Cliente', fieldName: 'accountUrl', type: 'url', typeAttributes: { label: { fieldName: "accountName" }, target: '_self' } }
        ]
        );
        cmp.set("v.loaded", true);
    },
    updateSelectedText: function (cmp, evt) {
        var selectedRows = evt.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
        cmp.set("v.selectedRow", selectedRows[0]);
        console.log('selectedRows');
        console.log(selectedRows[0]);
    },
    handleKeyUp: function (cmp, evt, hlp) {
        var targetKey = cmp.find("enter-search").get("v.value");
        if (hlp.isNotEmpty(targetKey)) {
            cmp.set("v.keyValue", targetKey);
        }
        var keyValue = cmp.get("v.keyValue");
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            hlp.handleContacts(cmp, evt, hlp, keyValue);
        }
    },
    handleContacts: function (cmp, evt, hlp) {
        var keyValue = cmp.find('enter-search').get('v.value');
        hlp.handleContacts(cmp, evt, hlp, keyValue);
    },
    handleSubmitCustom: function (cmp, evt, hlp) {
        evt.preventDefault();
        var sObject = cmp.get("v.sObjData");
        var initialsObject = { "sobejctType": sObject.sObjectType };
        var fields = evt.getParam('fields');
        Object.assign(initialsObject, fields);
        if (sObject.sObjectType === "Contact") {
            delete initialsObject["Name"];
        }
        hlp.insertContacRelation(cmp, evt, initialsObject);
    },
    createContact: function (cmp, evt, hlp) {
        cmp.set("v.loaded", false);
        var rowsCount = cmp.get("v.selectedRowsCount");
        if (rowsCount === 1) {
            hlp.getMetaData(cmp, evt, "BE_CreateAccountContactRelation", true);
        } else {
            hlp.getMetaData(cmp, evt, "BE_CreateNonClientContact", false);
        }
    },
    backButton: function (cmp, evt) {
        cmp.set("v.issearching", true);
        cmp.set("v.isNext", false);
        cmp.set("v.selectedRowsCount", 0);
        cmp.set("v.data", []);
        cmp.set("v.title", "Nuevo Contacto");
        $A.get('e.force:refreshView').fire();
    },
    closeModal: function (cmp, evt, hlp) {
        hlp.closeModal(cmp, evt);
    }
});