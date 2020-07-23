({
    /** SEARCH CONTACTS */
    handleContacts: function (cmp, evt, hlp,keyValue) {
        if (hlp.isNotEmpty(keyValue)) {
            hlp.getContacts(cmp, evt, hlp,keyValue);
        } else {
            cmp.set("v.selectedRowsCount", 0);
            cmp.set("v.data", []);
            cmp.set("v.isNext", false);
            hlp.showToast('Error', 'Rellenar el campo de busqueda', 'error');
        }
    },
    /** SEARCH CONTACTS APEX */
    getContacts: function (cmp, evt, hlp, keySearch) {
        cmp.set("v.loaded", false);
        cmp.set("v.selectedRowsCount",0);
        var action = cmp.get("c.getContacts");
        action.setParams({
            "searchKey": keySearch
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('res');
                console.log(res);
                cmp.set("v.data", res);
                cmp.set("v.isNext", true);
            } else {
                this.showToast('Error', 'Error al realizar la busqueda', 'error');
            }
            cmp.set("v.loaded", true);
        });
        $A.enqueueAction(action);
    },
    /** CALL SETTINGS*/
    getMetaData: function (cmp, evt, nameMetadata, setValues) {
        var action = cmp.get("c.getMetadata");
        action.setParams({
            "nameMetadata": nameMetadata
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                console.log('Ret');
                console.log(ret);
                var locale = $A.get("$Locale.langLocale");
                cmp.set('v.title', JSON.parse(ret.title)[locale]);
                var fields = (setValues === true) ? this.assignDataValues(cmp, evt, ret.sObjectFields.fields) : ret.sObjectFields.fields;
                var targetObject = {
                    sObjectType: ret.sObjectType,
                    fields: fields
                };
                cmp.set("v.sObjData", targetObject);
                cmp.set("v.issearching", false);
                cmp.set("v.loaded", true);
                console.log("targetObject");
                console.log(targetObject);
            } else {
                cmp.set("v.loaded", true);
                this.showToast('Error', 'Error al obtener datos de configuración', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    /** SET VALUES */
    assignDataValues: function (cmp, evt, fields) {
        var recordId = cmp.get("v.recordId");
        var selectedRow = cmp.get("v.selectedRow");
        var rowFields = Object.keys(selectedRow);
        console.log("fields");
        console.log(fields);
        var targetFields = [];
        for (const iterator of fields) {
            let targetField = iterator;
            if (rowFields.includes(iterator.value)) {
                Object.defineProperty(targetField, 'value', {
                    enumerable: false,
                    configurable: false,
                    writable: false,
                    value: this.isNotEmpty(selectedRow[iterator.value]) ? selectedRow[iterator.value] : ''
                });
            } else if (iterator.value === "recordId") {
                targetField.value = recordId;
            } else {
                targetField.value="";
            }
            targetFields.push(targetField);
        }
        console.log('targetFields');
        console.log(targetFields);
        return targetFields;
    },
    /** INSERT CONTACT OR ACCOUNTCONTACTRELATION */
    insertContacRelation: function (cmp, evt, sObject) {
        cmp.set("v.loaded", false);
        var recordId = cmp.get("v.recordId");
        var action = cmp.get("c.createNonClientContact");
        console.log('sObject');
        console.log(sObject);
        action.setParams({
            "sObjs": JSON.stringify(sObject),
            "recordId": recordId,
            "sObjType": sObject.sobejctType
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                console.log('res');
                console.log(res);
                if (res.isSuccess) {
                    this.showToast('Success', res.message, 'success');
                    this.closeModal(cmp, evt);
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.showToast('Error', res.message, 'error');
                }
            } else {
                this.showToast('Error', 'Error al realizar la operación', 'error');
            }
            cmp.set("v.loaded", true);
        });
        $A.enqueueAction(action);
    },
    /** CLOSE MODAL*/
    closeModal: function (cmp, evt) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
    /** SHOW MESSAGE*/
    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    /**VALIDATE NULL, EMPTY AND BLANK*/
    isNotEmpty: function (obj) {
        const notEmpty = (obj === null || obj === undefined || obj === "") ? false : true;
        return notEmpty;
    }
})