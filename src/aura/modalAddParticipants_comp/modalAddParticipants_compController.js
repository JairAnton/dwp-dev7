({
	init : function(component, event, helper) {
		component.set("v.lblSave", $A.get("$Label.c.Save"));
		component.set("v.lblCancel", $A.get("$Label.c.Cancel"));
		component.set("v.lblAmount", $A.get("$Label.c.Amount"));
		helper.getListValues(component);

		if(component.get("v.PParticipant")!=null)
		{
			var action2 = component.get("c.getParticipantDataByProductValues");
            action2.setParams({            
                "PParticipantId" : component.get("v.PParticipant")[0].Id              
            });
            action2.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
					component.find("txtNDOI").set("v.value",component.get("v.PParticipant")[0].N_DOI__c);
                	component.set("v.PParticipant", response.getReturnValue());
                    component.set("v.PParticipantId",component.get("v.PParticipant")[0].Id);
					component.find("txtName").set("v.value",component.get("v.PParticipant")[0].Name);
					component.find("selDOI").set("v.value",component.get("v.PParticipant")[0].DOI__c);
					component.find("selParticipation").set("v.value",component.get("v.PParticipant")[0].Participation__c);
					component.find("selMaritalStatus").set("v.value",component.get("v.PParticipant")[0].Marital_Status__c);

                    if(component.get("v.PParticipant")[0].isMaster__c)
                    {
                        component.find("btnSaveNew").set("v.disabled", true);
                        component.find("txtName").set("v.disabled", true);
                        

                    }
                }
            });        
            $A.enqueueAction(action2);
        }
	},
	handleCancel: function(component) {
        component.set('v.isActive', false);
    },
    saveRecord: function(component, event, helper) {

    	helper.saveParticipant(component, event, helper);

    }
})