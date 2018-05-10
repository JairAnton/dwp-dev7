({
	init : function(component, event, helper) {		
		//Static Labels
		component.set("v.lblTitle", $A.get("$Label.c.New_Opportunity"));
		component.set("v.lblAccountName", $A.get("$Label.c.AccountName"));
		component.set("v.lblOpportunityName", $A.get("$Label.c.OpportunityName"));
		component.set("v.lblPlanningDate", $A.get("$Label.c.PlannigDate"));
		component.set("v.lblCloseDate", $A.get("$Label.c.CloseDate"));
		component.set("v.lblAmount", $A.get("$Label.c.Amount"));
		component.set("v.lblCurrency", $A.get("$Label.c.Currency"));
		component.set("v.lblComments", $A.get("$Label.c.Comments"));	
		component.set("v.lblProbability", $A.get("$Label.c.Probability"));
		component.set("v.lblSave", $A.get("$Label.c.Save"));
		component.set("v.lblCancel", $A.get("$Label.c.Cancel"));
	},
	 toggleDialog : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    cSaveAction: function(component, event, helper) {
	    helper.close(component, event, helper);
	    helper.restSaveRecord(component, event, helper);
    }

	
})