({
    doInit: function (component, event, helper) {
        component.set('v.title', $A.get("$Label.c.lblSanctionRisk"));
        helper.onInit(component);
    },
    sendApprove: function (component, event, helper) {
        helper.updateOpportunityInsideLine(component);
    },
    setValueModality: function (component, event, helper) {
        var fieldValue = component.find('input_modal').get('v.value');
        helper.setVisibilityButtons(component, fieldValue);
    },
    openModel: function (component, event, helper) {
        component.set('v.isOpenModel', true);
    },
    searchSioCode: function (component, event, helper) {
        helper.getAudits(component);
    },
    closeModel: function (component, event, helper) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
        cancelEvent.fire();
    },
    selectRow: function (component, event, helper) {
        var selectedCode;
        selectedCode = event.getSource().get("v.value");
        component.set("v.selectedRow", selectedCode);
        component.find("resultSelected").set("v.value", $A.get("$Label.c.lblRiskSioCodeIs") + " " + selectedCode);
    },
    saveModel: function (component, event, helper) {
        helper.saveRequireAutho(component);
    }
})
