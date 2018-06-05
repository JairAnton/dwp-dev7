({
	init: function(component, event, helper) {
		component.set("v.lblComments", $A.get("$Label.c.Comments"));
		component.set("v.lblCancel", $A.get("$Label.c.Cancel"));
	    helper.bringData(component, event, helper); 
    },
	close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
	sanction : function(component, event, helper) {
		component.set('v.sanAction',event.getSource().get("v.name"));

		var cmpTarget1 = component.find('btnApprove');
		var cmpTarget2 = component.find('btnRaise');
		var cmpTarget3 = component.find('tApprove');
		var cmpTarget4 = component.find('tRaise');
		$A.util.removeClass(cmpTarget1, 'clickedButton');	
		$A.util.removeClass(cmpTarget2, 'clickedButton');
		$A.util.removeClass(cmpTarget3, 'tclickedButton');	
		$A.util.removeClass(cmpTarget4, 'tclickedButton');

        $A.util.addClass(event.getSource(), 'clickedButton');

		component.find("btnContinue").set("v.disabled", false);

		if(event.getSource().get("v.name")=='btnApprove')
			$A.util.addClass(cmpTarget3, 'tclickedButton');
		else
			$A.util.addClass(cmpTarget4, 'tclickedButton');
	},
	continue : function(component, event, helper) {
		helper.sanctionActions(component, event, helper);
	},
	desestimar : function(cmp, event, helper) {	
		var inputObject=cmp.get('v.inputAttributes');  
	    var compEvent = cmp.getEvent('dynamicFlowWizardContinue');
	    compEvent.setParams({'inputAttributes': inputObject, 'nextComponent':'c:Componente_CotizaWeb'});
	    compEvent.fire();
	    
	}

})