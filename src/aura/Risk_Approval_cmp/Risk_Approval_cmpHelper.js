({
    onInit: function (component) {
        var opportunityId = component.get("v.inputAttributes").recordId;
        var actionOpp = component.get("c.getOpportunity");
        actionOpp.setParams({
            oppId: opportunityId
        });
        actionOpp.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.oppRecord', result);
                this.setVisibilityButtons(component, result.Risk_modality_type__c);

                component.find('input_modal').set('v.value', result.Risk_modality_type__c);
                if (result.Risk_modality_type__c === $A.get("$Label.c.OppModalityRA")) {
                    component.find('input_modal').set('v.readonly', true);
                    component.find('nameOutput').set('v.value', $A.get("$Label.c.lblOpportunitySioCodeIs") + ' ' + result.sio_code__c)
                }
            }
        });
        $A.enqueueAction(actionOpp);
    },
    changeModalityValue: function (component) {
        var fieldValue = component.find('input_modal').get('v.value');
        this.setVisibilityButtons(component, fieldValue);
    },
    updateOpportunityInsideLine: function (component) {
        var opportunity = component.get("v.oppRecord");
        var action = component.get("c.sendApproval");
        action.setParams({
            opp: opportunity
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if (result === 'OK') {
                    this.toastEvent('Success!', $A.get("$Label.c.Toast_opp_saved_ok"), 'success');
                    var outputVar = opportunity.Id;
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.toastEvent('Error!', 'Error: ' + result, 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getAudits: function (component) {
        var opportunity = component.get("v.oppRecord");
        var textToSearch = component.get("v.searchText");
        var action = component.get("c.getSIOCodesToSelect");
        action.setParams({
            searchText: textToSearch,
            opp: opportunity
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.SIOCodes', result);
                if (result === null || result === undefined) {
                    $A.util.removeClass(component.find("messageOutput"), "slds-hide");
                }
            }
        });
        $A.enqueueAction(action);
    },
    setVisibilityButtons: function (component, modality) {
        if (modality === $A.get("$Label.c.OppModalityDL")) {
            component.set("v.showSendApproveBtn", true);
            component.set("v.isOpenModel", false);
        } else {
            component.set("v.showSendApproveBtn", false);
        }
        (modality === $A.get("$Label.c.OppModalityRA")) ? component.set("v.showSIOSearch", true) : component.set("v.showSIOSearch", false);
    },
    toastEvent: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    saveRequireAutho: function (component) {
        var action = component.get("c.saveSIO");
        action.setParams({
            oppRecord: component.get("v.oppRecord"),
            auditSio: component.get("v.selectedRow")
        });
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                if (result === 'OK') {
                    this.toastEvent('Success!', $A.get("$Label.c.Toast_opp_saved_ok"), 'success');
                    var outputVar = component.get("v.oppRecord").Id;
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.toastEvent('Error!', result, 'error');
                }
            }
        });
        $A.enqueueAction(action);
    }
})
