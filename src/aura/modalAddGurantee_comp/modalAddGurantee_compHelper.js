({
	handleShowToast: function(cmp, event, helper) {


	    $A.util.removeClass(cmp.find('divToast'), "slds-hide");

	    window.setTimeout(
	      $A.getCallback(function() {
	        if (cmp.isValid()) {
	          $A.util.addClass(cmp.find('divToast'), "slds-is-relative");
	        }
	      }),0
	    );
	},
	getListValues : function(component) {
		var optPeriodicity = [			
			{ value: "01", label: "Días" },
            { value: "02", label: "Meses" }
        ];
        component.set("v.optPeriodicity", optPeriodicity);
    	var optStatus = [			
			{ value: "01", label: "Formalizada" },
            { value: "02", label: "No formalizada" }
        ];
        component.set("v.optStatus", optStatus);
        var optModality = [			
			{ value: "01", label: "Genérica" },
            { value: "02", label: "Específica" }
        ];
        component.set("v.optModality", optModality);
        var optGuaranteeType = [			
			{ value: "01", label: "Dineraria" },
            { value: "02", label: "No dineraria" },
            { value: "03", label: "Sin garantía" }
        ];
        component.set("v.optGuaranteeType", optGuaranteeType);
    },
    saveGuarantee: function(component, event, helper) {

    	var errMsg=false;
 			if(!errMsg)
	        {   	 
	        		event.getSource().set("v.disabled", true);	        		
	        		var IdOpportunity=component.get("v.OpportunityId");	        		
	                var IdProuduct=component.get("v.ProductId");
	                var PGuaranteeId=component.get("v.PGuaranteeId");
	                var GuaranteeType=component.find("selGuaranteeType").get("v.value");
	                var Guarantee=component.find("selGuarantee").get("v.value");
	                var Modality=component.find("selModality").get("v.value");
	                var Amount=component.find("txtAmount").get("v.value");
	                var Status=component.find("selStatus").get("v.value");
	                var Term=null;
	                var Periodicity='';
	                if(Status=='02')
	                {
	                	Term=component.find("txtTerm").get("v.value");
	                	Periodicity=component.find("selPeriodicity").get("v.value");
	                }
	                var nGuarantee=null;
	                if(Status=='01')
	        			nGuarantee=component.find("txtnGuarantee").get("v.value");

	        		var action =  component.get("c.saveGuaranteeDataByProduct");
	                action.setParams({
	                	"PGuaranteeId" : PGuaranteeId,
	                	"IdOpportunity" : IdOpportunity,
	                	"IdProuduct" : IdProuduct,
	                	"GuaranteeType" : GuaranteeType,
	                	"Guarantee" : Guarantee,
	                	"Modality" : Modality,
	                	"Amount" : Amount,
	                	"Status" : Status,
	                	"Term" : Term,
	                	"Periodicity" : Periodicity,
	                	"nGuarantee" : nGuarantee
	                });
	                action.setCallback(this, function(response) {
	                  
	                    var state = response.getState();
	                    if (state === "SUCCESS") {      
	                      //alert('OK');
	                      var EnvioParametros= component.getEvent("PasoParametrosPadre");
                
			                EnvioParametros.setParams({
			                    "ReloadTable":true
			                });
			                EnvioParametros.fire();

	                       var result = response.getReturnValue();   
	                      // component.set("v.recordIdOpp",result);
	                      if(String(event.getSource().get("v.value"))=="Save")
	                      		component.set('v.isActive', false);
	                      else
	                      {
	                      		component.set('v.isActive', false);
	                      		component.set('v.isActive', true);
	                      }

	                       //helper.navigateToRecord(component, event, helper);
	                     }
	                    else if (state === "INCOMPLETE") {
	                    	event.getSource().set("v.disabled", false);
	                       	component.set("v.errMessage","Error al ");
	                        helper.handleShowToast(component,event,helper);   
	                    }
	                    else if (state === "ERROR") {
	                    	
	                    	// var result = response.getReturnValue();
	                    	event.getSource().set("v.disabled", false);  
	                    	var errors = response.getError();
	                        if (errors) {
	                            if (errors[0] && errors[0].message) 
	                            {	                                
	                            	component.set("v.errMessage","Error:"+errors[0].message );
	                            }
	                            else
	                            {
	                             	component.set("v.errMessage","Error:"+errors[0].message );
	                            }
	                        } else {                    
	                           component.set("v.errMessage","Unknown error");
	                        }	                        
	                        helper.handleShowToast(component,event,helper);   
	                    }
	                });        
	                $A.enqueueAction(action);     
	        	}     
	    

    }

})