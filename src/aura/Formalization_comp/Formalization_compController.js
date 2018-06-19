({
	init: function(component, event, helper) {
		component.set("v.lblComments", $A.get("$Label.c.Comments"));	
	    helper.bringData(component, event, helper); 
    },
	close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
	formalize : function(component, event, helper) {
		var cmpTarget1 = component.find('btnApprove');
		var cmpTarget3 = component.find('tApprove');
		var cmpTarget5 = component.find('iApprove');
		$A.util.removeClass(cmpTarget1, 'clickedButton');	
		$A.util.removeClass(cmpTarget3, 'tclickedButton');			
		cmpTarget5.set("v.variant","normal");		
        $A.util.addClass(event.getSource(), 'clickedButton');        		
		if(event.getSource().get("v.name")=='btnApprove')
		{
			cmpTarget5.set("v.variant","inverse");	
			$A.util.addClass(cmpTarget3, 'tclickedButton');
		}
		
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