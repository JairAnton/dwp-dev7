({
	init : function(component, event, helper) {
		component.set("v.lblSave", $A.get("$Label.c.Save"));
		component.set("v.lblCancel", $A.get("$Label.c.Cancel"));
		component.set("v.lblAmount", $A.get("$Label.c.Amount"));
		helper.getListValues(component);
		if(component.get("v.PGuarantee")!=null)
		{
			helper.getListValuesDependent(component);
			var action2 = component.get("c.getGuaranteeDataByProductValues");
            action2.setParams({            
                "PGuaranteeId" : component.get("v.PGuarantee")[0].Id              
            });
            action2.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.PGuarantee", response.getReturnValue());
                    component.set("v.PGuaranteeId",component.get("v.PGuarantee")[0].Id);
					component.find("selGuaranteeType").set("v.value",component.get("v.PGuarantee")[0].GuaranteeType__c);								
					component.find("selModality").set("v.value",component.get("v.PGuarantee")[0].Modality__c);
					
					component.find("selStatus").set("v.value",component.get("v.PGuarantee")[0].Status__c);
					if(component.get("v.PGuarantee")[0].Status__c=="02"){
						component.set("v.bStauts",true);
						component.set("v.bStautsF",false);
						component.find("selPeriodicity").set("v.value",component.get("v.PGuarantee")[0].Periodicity__c);
						component.find("txtTerm").set("v.value",component.get("v.PGuarantee")[0].Term__c);
			    	} 
					else if(component.get("v.PGuarantee")[0].Status__c=="01")
					{
						component.set("v.bStauts",false);
						component.set("v.bStautsF",true);
						component.find("txtnGuarantee").set("v.value",component.get("v.PGuarantee")[0].nGuarantee__c);
					}
					else
					{
						component.set("v.bStauts",false);
						component.set("v.bStautsF",false);

					}
					
					component.find("selGuarantee").set("v.value",component.get("v.PGuarantee")[0].Guarantee__c);
					//
					component.find("txtAmount").set("v.value",component.get("v.PGuarantee")[0].Amount__c);
                }
            });        
            $A.enqueueAction(action2);
			

			
			
		}


	},	
    onStatusChanged: function(component, event, helper) {
    	if(String(event.getSource().get("v.value"))=="02")
    	{
			component.set("v.bStauts",true);
			component.set("v.bStautsF",false);
    	} 
		else if(String(event.getSource().get("v.value"))=="01")
		{
			component.set("v.bStauts",false);
			component.set("v.bStautsF",true);
		}
		else
		{
			component.set("v.bStauts",false);
			component.set("v.bStautsF",false);
		}
    },
    onGuaranteeTypeChanged: function(component, event, helper) {
    	if(String(event.getSource().get("v.value"))=="01")
    	{
    		var optGuarantee = [			
				{ value: "01", label: "Cuenta en garantía" },
	            { value: "02", label: "Depósito cuenta a plazo" },
	            { value: "03", label: "Super depósitos" }
	        ];
	        component.set("v.optGuarantee", optGuarantee);
    	}
    	else if(String(event.getSource().get("v.value"))=="02")
    	{
    		var optGuarantee = [			
				{ value: "04", label: "Accions y bono" },
	            { value: "05", label: "Cartas de crédito" },
	            { value: "06", label: "Certificados bancarios" },
	            { value: "07", label: "Fianza bancaria" },
	            { value: "08", label: "Fianza solidaria" },
	            { value: "09", label: "Fondos mutuos" },
	            { value: "10", label: "Hipoteca" },
	            { value: "11", label: "Leasing" },
	            { value: "12", label: "Prenda agrícola" },
	            { value: "13", label: "Prenda industrial" },
	            { value: "14", label: "Prenda minera" },
	            { value: "15", label: "Prenda transporte" },
	            { value: "16", label: "Prenda vehicular" },
	            { value: "17", label: "Warants" }
	        ];
	        component.set("v.optGuarantee", optGuarantee);
    	}
    	else
    		component.set("v.optGuarantee", null);

    },
	handleCancel: function(component) {
        component.set('v.isActive', false);
    },
    saveRecord: function(component, event, helper) {
    	/*if(event.getSource().get("v.value")
    	alert(event.getSource().get("v.value"));*/

    	helper.saveGuarantee(component, event, helper);

    }

})