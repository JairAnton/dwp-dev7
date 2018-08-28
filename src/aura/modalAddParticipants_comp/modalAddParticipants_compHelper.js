({
	handleShowToast: function(cmp, event, helper) {


            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Error",
                message: cmp.get('v.errMessage'), 
                type: "error" 
            });    
            toastEvent.fire();  
	},
	getListValues : function(component) {
		var optDOI = [			
			{ value: "01", label: "RUC" },
            { value: "02", label: "DNI" },
            { value: "03", label: "CE" }
        ];
        component.set("v.optDOI", optDOI);

        var optParticipation = [
			{ value: "01", label: "Titular" },
            { value: "02", label: "Fiador" }            
        ];
        component.set("v.optParticipation", optParticipation);

        var optMaritalStatus = [
			{ value: "01", label: "Casado" },
            { value: "02", label: "Soltero" },
            { value: "03", label: "Divorciado/Viudo" },
            { value: "04", label: "N/A" }
        ];
        component.set("v.optMaritalStatus", optMaritalStatus);
    	
    },
     saveParticipant: function(component, event, helper) {

    	 	 		var errMsg=false;
	        		event.getSource().set("v.disabled", true);
	        		var IdOpportunity=component.get("v.OpportunityId");	        		
	                var IdProuduct=component.get("v.ProductId");
	                var PParticipantId=component.get("v.PParticipantId");

	                
	                var Name=component.find("txtName").get("v.value");
	                var DOI=component.find("selDOI").get("v.value");
	                var NDOI=component.find("txtNDOI").get("v.value")+"";
	                var Participation=component.find("selParticipation").get("v.value");
	                var Marital_Status=component.find("selMaritalStatus").get("v.value");
	                	                
	                if(DOI=="01")
	                {
	                	if(NDOI.length!=11)
	                	{
	                		errMsg=true;
	                		component.set("v.errMessage","El campo de N° DOI debe contener 11 digitos.");
	                		helper.handleShowToast(component,event,helper);   
	                	}
	                }
	                else if(DOI=="02")
	                {
	                	if(NDOI.length!=8)
	                	{
	                		errMsg=true;
	                		component.set("v.errMessage","El campo de N° DOI debe contener 8 digitos.");
	                		helper.handleShowToast(component,event,helper);   
	                	}
	                }
	                else if(DOI=="03")
	                {
	                	if(NDOI.length!=9)
	                	{
	                		errMsg=true;
	                		component.set("v.errMessage","El campo de N° DOI debe contener 9 digitos.");
	                		helper.handleShowToast(component,event,helper);   
	                	}
	                }

	                if(Name.length<=0 || Name==null)
	                {
	                	errMsg=true;
	                	component.set("v.errMessage","El Nombre es obligatorio.");
	                	helper.handleShowToast(component,event,helper);   
	                }

	                if (NDOI!=parseInt(NDOI) || parseInt(NDOI)<0)
	                {
	                	errMsg=true;
	                	component.set("v.errMessage","El campo de N° DOI debe ser entero y positivo.");
	                	helper.handleShowToast(component,event,helper);   
	                }

	                var inputCmp = component.find("txtNDOI");
			        var value = inputCmp.get("v.value");

			        
			        if (isNaN(value)) {
			            event.getSource().set("v.disabled", false);

			            errMsg=true;
			            component.set("v.errMessage","El valor no es numérico: " + value);
	                	helper.handleShowToast(component,event,helper);   
			            //inputCmp.set("v.errors", [{message:"El valor no es numérico: " + value}]);
			        }
			          
	                
		 			if(!errMsg)
			        {  
		        		var action =  component.get("c.saveParticipantDataByProduct");
		                action.setParams({
		                	"PParticipantId" : PParticipantId,
		                	"IdOpportunity" : IdOpportunity,
		                	"IdProuduct" : IdProuduct,
		                	"Name" : Name,
		                	"DOI" : DOI,
		                	"N_DOI" : NDOI,
		                	"Participation" : Participation,
		                	"Marital_Status" : Marital_Status
		                });
		                action.setCallback(this, function(response) {
		                  
		                    var state = response.getState();
		                    if (state === "SUCCESS") {      
		                      
		                      var EnvioParametros= component.getEvent("PasoParametrosPadre");
	                
				                EnvioParametros.setParams({
				                    "ReloadTable":true
				                });
				                EnvioParametros.fire();

		                       var result = response.getReturnValue();   
		                      
		                      if(String(event.getSource().get("v.value"))=="Save")
		                      		component.set('v.isActive', false);
		                      else
		                      {
	                      			component.set("v.PParticipant", null);
	                      			component.set("v.PParticipantId", null);		                      	
		                      		component.set('v.isActive', false);
		                      		component.set('v.isActive', true);
		                      		component.set('v.title', 'Añadir interviniente');
		                      }

		                       //helper.navigateToRecord(component, event, helper);
		                     }
		                    else if (state === "INCOMPLETE") {
		                    	event.getSource().set("v.disabled", false);
		                       	component.set("v.errMessage","Error al ");
		                        helper.handleShowToast(component,event,helper);   
		                    }
		                    else if (state === "ERROR") {
		                    	
		                    	
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
	        		else
	        			event.getSource().set("v.disabled", false);
	    

    }
})