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
	   bringData : function(cmp, evt, helper) {        
	   	var inputObject = cmp.get('v.inputAttributes');  
	   	cmp.set('v.recordId',inputObject.recordId);	   	
        var OpportunityId = cmp.get("v.recordId");
        var ProductId;

        var action0 = cmp.get("c.verifyIfHasQuoted");
        
        action0.setParams({
            "IdOpportunity" : OpportunityId           
        });
        action0.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                        
                ////VERIFY IF HAS QUOTE THE OPP
                
                if(response.getReturnValue())
                {

                    var action = cmp.get("c.getIdProductByOpportunity");
                    
                    action.setParams({
                        "IdOpportunity" : OpportunityId           
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {                       
                            
                            ProductId=response.getReturnValue()[0].Product2Id;
                            cmp.set('v.ProductId',ProductId);                

                            var action2 = cmp.get("c.getParticipantDataByProduct");                
                            
                            action2.setParams({            
                                "IdOpportunity" : OpportunityId,
                                "IdProduct" : ProductId
                            });
                            action2.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {                    	
                                    cmp.set("v.rowsP", response.getReturnValue());
                                }
                            });        
                            $A.enqueueAction(action2); 

                            ///COMPROMISOS
                            var action3 = cmp.get("c.getCompromisoDataByProduct");                
                            
                            action3.setParams({            
                                "IdOpportunity" : OpportunityId
                            });
                            action3.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    cmp.set("v.rowsComp", response.getReturnValue());
                                }
                            });        
                            $A.enqueueAction(action3); 

                            ///OPORTUNIDAD Y PRODUCTO
                            var action4 = cmp.get("c.getOpportunityLineItemDataByProduct");                
                            
                            action4.setParams({            
                                "IdOpportunity" : OpportunityId,
                                "IdProduct" : ProductId
                            });
                            action4.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    cmp.set("v.rowsOppLineItem", response.getReturnValue());
                                }
                            });        
                            $A.enqueueAction(action4);

                            // COTIZACIÓN TARIFARIA O COTIZAWEB
                            var action5 = cmp.get("c.getOportunidadSytem");
                            action5.setParams({
                                "Filtro":OpportunityId
                            });
                            action5.setCallback(this, $A.getCallback(function (response) {
                                var state = response.getState();
                                if (state === "SUCCESS") {
                                    if(response.getReturnValue()=="Tarifario"){
                                        cmp.set("v.cotiweb" , false);
                                    }else {
                                        cmp.set("v.cotiweb" , true);
                                    }
                                } else if (state === "ERROR") {
                                    alert('ERROR');
                                    var errors = response.getError();
                                }
                            }));
                            $A.enqueueAction(action5);
                        }
                    });        
                    $A.enqueueAction(action);
                }
                else
                {
                    
                    var inputObject=cmp.get('v.inputAttributes');  
                    var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
                    compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:Componente_CotizaWeb' });
                    compEvent.fire();
                    /*var cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
                    cancelEvent.fire();*/
                }
            }
            else
            {
               
            }
        });        
        $A.enqueueAction(action0);
    
	},
    sanctionActions : function(component, event, helper) {
        var OpportunityId = component.get("v.recordId");        
        var action = component.get("c.setSanctionPrice");        
        var action = component.get("c.setSanctionPrice");
        var sanAction = component.get("v.sanAction");
        var Comments="";
        if(component.find("txtComments")!=null)
            Comments= component.find("txtComments").get("v.value");
        else
            Comments="";

        
       // alert(Comments);
        action.setParams({            
            "OpportunityId" : OpportunityId,
            "sanAction" : sanAction,
            "Comments" : ''+Comments
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                component.set("v.errMessage",response.getReturnValue());
                helper.handleShowToast(component,event,helper);       
                if(response.getReturnValue()=="true")
                    helper.navigateToRecord(component, event, helper);

            }
            else if (state === "INCOMPLETE") {
                component.set("v.errMessage",response.getReturnValue());
                helper.handleShowToast(component,event,helper);        
                             
            }
            else if (state === "ERROR") {
                component.set("v.errMessage",response.getReturnValue());
                helper.handleShowToast(component,event,helper);                    
            }
        });        
        $A.enqueueAction(action);
    },  
    navigateToRecord : function(component, event, helper) {
         var navEvent = $A.get("e.force:navigateToSObject");
         navEvent.setParams({
              recordId: component.get("v.recordId"),
              slideDevName: "detail"
         });
         navEvent.fire(); 
    }

})