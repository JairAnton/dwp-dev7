({
	setValue : function(component, event, helper) {
	var fieldValue; 
    fieldValue= component.find('input_modal').get('v.value');
    component.set("v.Modality", fieldValue);
    (fieldValue=='Inside line')?component.set("v.showButton", true):component.set("v.showButton", false);      
    (fieldValue=='Requires authorization')?component.set("v.showSIO", true):component.set("v.showSIO", false);          
    var a = component.get('c.rerender');
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
   }
})