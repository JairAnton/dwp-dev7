({
    getSettings: function (cmp, evt, helper) {
        var nameMetadata = cmp.get('v.nameMetadata');
        var action = cmp.get("c.getSettings");
        var recordId = cmp.get("v.recordId");
        action.setParams({
            "nameMetadata": nameMetadata,
            "recordId": recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var locale = $A.get("$Locale.langLocale");
                cmp.set('v.title', JSON.parse(ret.title)[locale]);
                cmp.set("v.settings", ret);
                console.log("#########Loading",ret.sObjectType);
        		console.log("#########Loading",ret.isExcecutiveUser, ret.sObjectType === 'Opportunity', !(!ret.isExcecutiveUser && ret.sObjectType !== 'Opportunity'));
                this.getsObjectFields(cmp, evt, ret.sObjectType, ret.sObjectFields);
            } else {
                cmp.set("v.loaded", true);
                this.showToast('Error', 'Comuniquese con su administrador', 'error');
            }
          });
        $A.enqueueAction(action);
    },
    getsObjectFields: function (cmp, evt, sObjectType, fields) {
        var action = cmp.get("c.getsObjFields");
        var recordId = cmp.get("v.recordId");
        var currentFields = [];
        var params = { "sObjectType": sObjectType, "Id": recordId, "action": cmp.get("v.settings").modeAction };
        for (const iterator of fields) {
            currentFields.push(iterator.fieldName);
        }
        action.setParams({
            "params": params,
            "sObjFields": currentFields,
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
    callApexMethod: function (cmp, evt, sObjectUpdate, actionApex) {
        cmp.set("v.loaded", false);
        var currentParams = {
            "recordId": cmp.get("v.recordId"),
            "className": cmp.get("v.settings").className
        };
        var action = actionApex;
        console.log(currentParams);
        action.setParams({
            "sObj": sObjectUpdate,
            "params": currentParams
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res.isSuccess) {
                    this.showToast('Success', 'Se actualizó la información del Sponsor Financiero', 'success');
                    this.closeModal(cmp, evt, res.data.Id);
                    console.log('Retorno de apex: '+ JSON.stringify(res));
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
        var redirectsObj = this.isNotEmpty(cmp.get("v.settings").redirect) ? cmp.get("v.settings").redirect : cmp.get('v.sObjData').sObjectType;
        var currentObject = cmp.get("v.settings").sObjectType;
        if (cmp.get("v.isNotQuickAction")) {
            if (recordId === null || recordId === "" || recordId === undefined) {
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                switch (currentObject) {
                  case 'altm__Commercial_Alert__c':
                    homeEvent.setParams({
                    	"scope": currentObject
                	});
                    homeEvent.fire();
                    break;
                  case 'Opportunity':
                    $A.get("e.force:closeQuickAction").fire();
            		$A.get('e.force:refreshView').fire();
                    break;
                  default:
                    homeEvent.setParams({
                    	"scope": redirectsObj
                	});
                    homeEvent.fire();
                    break;
                }                            

            } else {
                var navEvt = $A.get("e.force:navigateToObjectHome");
                navEvt.setParams({
                    "scope": redirectsObj
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
