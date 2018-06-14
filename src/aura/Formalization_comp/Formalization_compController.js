({
	init: function(component, event, helper) {
		component.set("v.lblComments", $A.get("$Label.c.Comments"));	
	    helper.bringData(component, event, helper); 
    },
	close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
	formalize : function(component, event, helper) {
		component.set('v.Action',event.getSource().get("v.name"));
		component.find("btnContinue").set("v.disabled", false);
	},
	continue : function(component, event, helper) {
		helper.Actions(component, event, helper);
	},
    RecibeParametros : function (cmp,event,helper){
        var parametrohijo0= event.getParam("FileName");
     	cmp.set("v.FileName",parametrohijo0);            
    },    

})