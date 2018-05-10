({
 
    getIni :function(component, event, helper) {
      var oppId = component.get('v.recordId');
      var actionOLI = component.get('c.getOppLI');
      var saveSIO = component.get('c.saveSIO');
 
      actionOLI.setParams({
                    "opp":oppId
                });
       actionOLI.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.recordOLI', response.getReturnValue());
            }
        }
        );
         $A.enqueueAction(actionOLI);
    },
 
    setValue : function(component, event, helper) {
    var fieldValue;
    fieldValue= component.find('input_modal').get('v.value');
    component.set("v.Modality", fieldValue);
 
    (fieldValue=='Inside line')?component.set("v.showButton", true):component.set("v.showButton", false);
    (fieldValue=='Requires authorization')?component.set("v.showSIO", true):component.set("v.showSIO", false);
    var a = component.get('c.rerender');
    var action = component.get('c.getTasks');
    var st = component.get('v.searchText');
        action.setParams({
                    "val":st
                });
 
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.mydata', response.getReturnValue());
            }
        }
        );
 
 
    $A.enqueueAction(action);
    $A.enqueueAction(a);
	},
    rerender : function(component,event,helper){
       this.reRender();
    },
    openModel: function(component, event, helper) {
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
         component.set("v.isOpen", false);
   },
   saveModel: function(component, event, helper) {
       var sel;
       sel = component.get("v.selectedRow")
       component.set("v.isOpen", false);
       component.set("v.saveRow",sel);
       var oppId = component.get('v.recordId');
       var saveSIO = component.get('c.saveSIO');
 
      saveSIO.setParams({
                    "opp":oppId,
                     "savedRow":sel
                });
       saveSIO.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               alert("Código SIO actualizado corretamente ");
            }
        }
        );
         $A.enqueueAction(saveSIO);
 
   },
    selectedRow: function(component,event){
     var sel;
     sel = event.getSource().get("v.label");
     component.set("v.selectedRow",sel);
     var a = component.get('c.rerender');
    $A.enqueueAction(a);
   },
    sendApprove:function(component){
     var sendApproval = component.get('c.sendApproval');
     var oppId = component.get('v.recordId');
      sendApproval.setParams({
                    "opp":oppId
                });
      sendApproval.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               alert("Etapa y estado actualizado corretamente ");
            }
        }
        );
         $A.enqueueAction(sendApproval);
 
    }
 
})
