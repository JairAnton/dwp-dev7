({
	init: function(component, event, helper) {
		component.set("v.lblComments", $A.get("$Label.c.Comments"));	
		
	    helper.bringData(component, event, helper); 
        helper.getContractNumber(component, event, helper);
    },
	close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},
	formalize : function(component, event, helper) {
		var cmpTarget1 = component.find('btnApprove');
		var cmpTarget2 = component.find('btnRaise');
		var cmpTargetbB = component.find('btnBack');

		var cmpTarget3 = component.find('tApprove');
		var cmpTarget4 = component.find('tRaise');
		var cmpTargettB = component.find('tBack');

		var cmpTarget5 = component.find('iApprove');
		var cmpTarget6 = component.find('iRaise');
		var cmpTargetiB = component.find('iBack');

		$A.util.removeClass(cmpTarget1, 'clickedButton');	
		$A.util.removeClass(cmpTarget2, 'clickedButtonBlue');
		$A.util.removeClass(cmpTargetbB, 'clickedButtonOrange');

		$A.util.removeClass(cmpTarget3, 'tclickedButton');	
		$A.util.removeClass(cmpTarget4, 'clickedButtonBlue');
		$A.util.removeClass(cmpTargettB, 'clickedButtonOrange');

		cmpTarget5.set("v.variant","normal");
		cmpTarget6.set("v.variant","normal");
		cmpTargetiB.set("v.variant","normal");

        

		if(event.getSource().get("v.name")=='btnApprove')
		{
            $A.util.addClass(event.getSource(), 'clickedButton');
			cmpTarget5.set("v.variant","inverse");	
			$A.util.addClass(cmpTarget3, 'tclickedButton');

		}
		else if(event.getSource().get("v.name")=='btnRaise')
		{
            $A.util.addClass(event.getSource(), 'clickedButtonBlue');
			cmpTarget6.set("v.variant","inverse");
			$A.util.addClass(cmpTarget4, 'clickedButtonBlue');

		}
		else{
            $A.util.addClass(event.getSource(), 'clickedButtonOrange');
			cmpTargetiB.set("v.variant","inverse");
			$A.util.addClass(cmpTargettB, 'clickedButtonOrange');

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