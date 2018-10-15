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
	},
	Actions : function(component, event, helper) {
        

      
       
            
            var OpportunityId = component.get("v.recordId");
            var action = component.get("c.setLastFormalization");
            var sanAction = component.get("v.Action");
            var body = component.find("txtComments").get("v.value");
            var ContractNumber = component.find("txtContract").get("v.value");
           

            if((sanAction=='btnApprove' && ContractNumber.length>0 ) || (sanAction=='btnRaise') || (sanAction=='btnBack' && body.length>0))
            {
                action.setParams({
                    "OpportunityId" : OpportunityId,
                    "Action" : sanAction,
                    "Body"  :  body,
                    "ContractNumber" : ContractNumber
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log(response.getReturnValue());                    
                        if(response.getReturnValue().success == true){
                            $A.get('e.force:refreshView').fire();
                            helper.navigateToRecord(component, event, helper);
                        }
                        else if(response.getReturnValue().showErrorMessage){
                            component.set('v.errorlst',response.getReturnValue().errorMessage);
                            component.set('v.optionToDisplay','02');
                            component.set('v.hasHeader',false);
                        }

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
            }
            else
            {
                if(sanAction=='btnApprove')
                {
                  component.set("v.errMessage","El número de contrato es obligatorio.");
                  helper.handleShowToast(component,event,helper);
                }               
                else
                {
                  component.set("v.errMessage","El comentario es obligatorio.");
                  helper.handleShowToast(component,event,helper);
                }
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