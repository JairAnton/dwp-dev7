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
        //var OpportunityId = cmp.get("v.recordId"); // 2018/11/30 -  CORRECCION DEUDA TECNICA (variable no se usa)
	},
	Actions : function(component, event, helper) {
        component.find("btnContinue").set("v.disabled", true);
        var OpportunityId = component.get("v.recordId");
        var body = component.get("v.comments");
        var fileName = component.get("v.FileName");
        if(!component.get("v.isFormalization"))
        {

            var action = component.get("c.setFormalization");
            var sanAction = component.get("v.Action");

            action.setParams({
                "OpportunityId" : OpportunityId,
                "Action" : sanAction,
                "Body"  :  body,
                "AttachedFiles" : fileName
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.errMessage",response.getReturnValue());
                    helper.handleShowToast(component,event,helper);
                    if(response.getReturnValue()=="true"){
                        $A.get('e.force:refreshView').fire();
                        helper.navigateToRecord(component, event, helper);
                    }
                    else
                    {
                        component.set("v.errMessage",response.getReturnValue());
                        helper.handleShowToast(component,event,helper);
                    }

                }
                else if (state === "INCOMPLETE" || state === "ERROR") {
                    component.find("btnContinue").set("v.disabled", false);
                    component.set("v.errMessage",response.getReturnValue());
                    helper.handleShowToast(component,event,helper);
                               
                }/* // 2018/11/30 -  CORRECCION DEUDA TECNICA: cuando state es INCOMPLETE o ERROR hacen la misma funcionalidad            
                else if (state === "ERROR") {
                    component.find("btnContinue").set("v.disabled", false);
                    component.set("v.errMessage",response.getReturnValue());
                    helper.handleShowToast(component,event,helper);
                }*/
                else if (state === "NoComments") {
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    message: "Cotizacion Terminada",
                    type: "success"
                });
            toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        else
        {
            var actionNoFormalization = component.get("c.setLastFormalization");   // 2018/11/30 -  CORRECCION DEUDA TECNICA: Se cambio de nombre a la variable Action para el flujo else
            actionNoFormalization.setParams({ // 2018/11/30 -  CORRECCION DEUDA TECNICA: Se cambio de nombre a la variable Action para el flujo else
                    "OpportunityId" : OpportunityId,
                    "Action" : 'btnApprove',
                    "Body"  :  body,
                    "ContractNumber" : ''
                });
                actionNoFormalization.setCallback(this, function(response) {// 2018/11/30 -  CORRECCION DEUDA TECNICA: Se cambio de nombre a la variable Action para el flujo else
                    var state = response.getState();
                    if (state === "SUCCESS") {
                    
                        if(response.getReturnValue().success==true){
                            $A.get('e.force:refreshView').fire();
                            helper.navigateToRecord(component, event, helper);
                        }
                        else
                        {
                            component.set("v.errMessage",response.getReturnValue().errorMessage);
                            helper.handleShowToast(component,event,helper);
                        }


                    }
                    else if (state === "INCOMPLETE" || state === "ERROR") {
                        component.set("v.errMessage",response.getReturnValue());
                        helper.handleShowToast(component,event,helper);
                                   
                    }/* // 2018/11/30 -  CORRECCION DEUDA TECNICA: cuando state es INCOMPLETE o ERROR hacen la misma funcionalidad            
                    else if (state === "ERROR") {
                        component.set("v.errMessage",response.getReturnValue());
                        helper.handleShowToast(component,event,helper);
                    }*/
                    
                });
                $A.enqueueAction(actionNoFormalization);   // 2018/11/30 -  CORRECCION DEUDA TECNICA: Se cambio de nombre a la variable Action para el flujo else
        }
    },
    navigateToRecord : function(component, event, helper) {
         var navEvent = $A.get("e.force:navigateToSObject");
         navEvent.setParams({
              recordId: component.get("v.recordId"),
              slideDevName: "SEGUIMIENTO"
         });
         navEvent.fire();
    }
 
 
})