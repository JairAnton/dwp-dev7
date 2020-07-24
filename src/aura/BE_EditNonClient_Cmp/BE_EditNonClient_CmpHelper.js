({
    getInfo: function (cmp, evt, helper) {
        var nameMetadata = cmp.get('v.nameMetadata');
        var action = cmp.get("c.getFields");
        action.setParams({
            "nameMetadata": nameMetadata
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var locale = $A.get("$Locale.langLocale");
                cmp.set('v.title', JSON.parse(ret.title)[locale]);
                this.getNonClient(cmp, evt, ret.sObjectFields.fields);
            } else {
                cmp.set("v.loaded", true);
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    getNonClient: function (cmp, evt, fields) {
        var action = cmp.get("c.getNonClient");
        var recordId = cmp.get("v.recordId");
        var currentFields = [];
        for (const iterator of fields) {
            currentFields.push(iterator.fieldName);
        }
        action.setParams({
            "accId": recordId,
            "sObjFields": currentFields
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var targetObject = {
                    sObjectType: 'Account',
                    fields: []
                };
                for (const iterator of fields) {
                    let targetField = iterator;
                    Object.defineProperty(targetField, 'value', {
                        enumerable: false,
                        configurable: false,
                        writable: false,
                        value: res[iterator.fieldName]
                    });
                    targetObject.fields.push(targetField);
                }
                cmp.set("v.sObjData", targetObject);
            } else {
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
            cmp.set("v.loaded", true);
        });
        $A.enqueueAction(action);
    },
    updateNonClients: function (cmp, evt, sObjectUpdate) {
        cmp.set("v.loaded", false);
        var action = cmp.get("c.updateNonClient");
        action.setParams({
            "sObjs": sObjectUpdate
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
                } else {
                    this.showToast('Error', res.message, 'error');
                }
            } else {
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
            cmp.set("v.loaded", true);
        });
        $A.enqueueAction(action);
    },
    closeModal: function (cmp, evt) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire();
    },
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
