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
                this.getNonClient(cmp, evt, ret.sObjectFields);
            } else {
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    getNonClient: function (cmp, evt, fields) {
        var action = cmp.get("c.getNonClient");
        var recordId = cmp.get("v.recordId");
        action.setParams({
            "accId": recordId,
            "sObjFields": fields
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var object = {
                    sObjectType: 'Account',
                    fields: []
                }
                for (const iterator of fields) {
                    object.fields.push({
                        fieldName: iterator,
                        value: this.isNotEmpty(res[iterator]) ? res[iterator] : ''
                    });
                }
                cmp.set("v.sObjData", object);
            } else {
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    updateNonClients: function (cmp, evt, sObjectUpdate) {
        var action = cmp.get("c.updateNonClient");
        action.setParams({
            "sObjs": sObjectUpdate
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res.isSuccess) {
                    this.closeModal(cmp, evt);
                } else {
                    this.showToast('Error', res.message, 'error');
                }
            } else {
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
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
