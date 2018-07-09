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
            { value: "02", label: "No dineraria" }
            
        ];
        component.set("v.optGuaranteeType", optGuaranteeType);
        var optGuarantee = [			
            { value: "04", label: "Accions y bono" },
            { value: "05", label: "Cartas de crédito" },
            { value: "06", label: "Certificados bancarios" },
            { value: "07", label: "Fianza bancaria" },				            
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
    },
    getListValuesDependent : function(component) {
        if(component.get("v.PGuarantee")[0].GuaranteeType__c=="01")
        {
            var optGuarantee = [			
                { value: "01", label: "Cuenta en garantía" },
                { value: "02", label: "Depósito cuenta a plazo" },
                { value: "03", label: "Super depósitos" }
            ];
            component.set("v.optGuarantee", optGuarantee);
        }
        else if(component.get("v.PGuarantee")[0].GuaranteeType__c=="02")
        {
            var optGuarantee = [			
                { value: "04", label: "Accions y bono" },
                { value: "05", label: "Cartas de crédito" },
                { value: "06", label: "Certificados bancarios" },
                { value: "07", label: "Fianza bancaria" },				            
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
    saveGuarantee: function(component, event, helper) {
        var errMsg=false;
        var validated =true;
        var vImporte;
        var vPlazo;
        vImporte=component.find("txtAmount").get("v.value");
        try{
            vPlazo = component.find("txtTerm").get("v.value");
        }catch(exception){
            console.log('Exception: '+exception);   
        }
        if(vImporte<=0){
            validated =false;
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Validación en importe",
                message: "El importe debe ser mayor a 0", 
                type: "warning" 
            });    
            toastEvent.fire();  
        }
        
        var estado = component.find("selStatus").get("v.value");
        if(vPlazo<=0 &&  estado =='02'){
            validated =false;
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Validación en plazo",
                message: "El plazo debe ser mayor a 0", 
                type: "warning" 
            });    
            toastEvent.fire();  
        }
        
        
        if(validated){
            if(!errMsg)
            {   	 
                event.getSource().set("v.disabled", true);	        		
                var IdOpportunity=component.get("v.OpportunityId");	        		
                var IdProuduct=component.get("v.ProductId");
                var PGuaranteeId=component.get("v.PGuaranteeId");
                var GuaranteeType=component.find("selGuaranteeType").get("v.value");
                var Guarantee=component.find("selGuarantee").get("v.value");
                var Modality=component.find("selModality").get("v.value");
                var Amount=component.find("txtAmount").get("v.value")+"";
                var Status=component.find("selStatus").get("v.value");
                var Term=null;
                var Periodicity='';
                
                if(Status=='02')
                {
                    Term=component.find("txtTerm").get("v.value")+"";
                    Periodicity=component.find("selPeriodicity").get("v.value");
                }
                var nGuarantee=null;
                if(Status=='01')
                    nGuarantee=component.find("txtnGuarantee").get("v.value")+"";
                
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
                            component.set("v.PGuarantee", null);
                            component.set("v.PGuaranteeId", null);
                            component.set('v.isActive', false);
                            component.set('v.isActive', true);
                            component.set('v.title', 'Añadir garantía');
                            
                            //component.set('PGuaranteeId',null);
                            
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
    }
    
})
