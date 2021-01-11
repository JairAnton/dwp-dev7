({
    getSettings: function (cmp, evt, helper) {
        var nameMetadata = cmp.get('v.nameMetadata');
        var action = cmp.get("c.getSettings");
        action.setParams({
            "nameMetadata": nameMetadata
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var locale = $A.get("$Locale.langLocale");
                cmp.set('v.title', JSON.parse(ret.title)[locale]);
                cmp.set("v.settings",ret);
                this.getsObjectFields(cmp,evt,ret.sObjectType,ret.sObjectFields.fields);
            } else {
                cmp.set("v.loaded", true);
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    getsObjectFields: function (cmp, evt, sObjectType,fields) {
        var action = cmp.get("c.getsObjFields");
        var recordId = cmp.get("v.recordId");
        var currentFields = [];
        for (const iterator of fields) {
            currentFields.push(iterator.fieldName);
        }
        action.setParams({
            "accId": recordId,
            "sObjFields": currentFields,
            "sObjectType": sObjectType
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var targetObject = {
                    sObjectType: sObjectType,
                    fields: []
                };
                for (const iterator of fields) {
                    let targetField = iterator;
                    Object.defineProperty(targetField, 'value', {
                        enumerable: false,
                        configurable: false,
                        writable: false,
                        value: res[iterator.fieldName] ? res[iterator.fieldName] : iterator.value
                    });
                    targetObject.fields.push(targetField);
                }
                cmp.set("v.sObjData", targetObject);
                console.log("sObjData");
                console.log(targetObject);
            } else {
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
            cmp.set("v.loaded", true);
        });
        $A.enqueueAction(action);
    },
    callApexMethod: function (cmp, evt, sObjectUpdate,actionApex) {
        cmp.set("v.loaded", false);
        var action = actionApex;
        action.setParams({
            "sObj": sObjectUpdate,
            "className": cmp.get("v.settings").className
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res.isSuccess) {
                    this.showToast('Success', res.message, 'success');
                    this.closeModal(cmp, evt, res.data.Id);
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
    closeModal: function (cmp, evt, recordId) {
        if(cmp.get("v.isNotQuickAction")) {
            if(recordId === null) {
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": cmp.get('v.sObjData').sObjectType
                });
                homeEvent.fire();
            } else {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": recordId,
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
        }
        else {
            $A.get("e.force:closeQuickAction").fire();
        	$A.get('e.force:refreshView').fire();
        }
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
