({
    selectedOption : function(component, event, helper) {
        //Buttons
        var btnSF = component.find("btnSF");
        var btnRE = component.find("btnRE");
        //Icons
        var iconSF = component.find("iconSF");
        var iconRE = component.find("iconRE");
        //Paragraph
        var pSF = component.find("pSF");
        var pRE = component.find("pRE");
        //Logic
        if(event.getSource().get("v.name")==='btnSF') {
			$A.util.addClass(btnSF, 'clickedButtonGreen');
            $A.util.removeClass(btnRE, 'clickedButtonOrange');
            $A.util.addClass(pSF, 'tclickedButton');
            $A.util.removeClass(pRE, 'tclickedButton');
            iconSF.set("v.variant","inverse");
            iconRE.set("v.variant","warning");
            component.set("v.optionSelected", 'sentToFormalize');
        } else {
            $A.util.addClass(btnRE, 'clickedButtonOrange');
            $A.util.removeClass(btnSF, 'clickedButtonGreen');
            $A.util.addClass(pRE, 'tclickedButton');
            $A.util.removeClass(pSF, 'tclickedButton');
            iconRE.set("v.variant","inverse");
            iconSF.set("v.variant","success");
            component.set("v.optionSelected", 'returnByDocumentation');
        }
		var cmpEvt = component.getEvent("setContinueButton");
        cmpEvt.setParams({"activeContinue" : false});
        cmpEvt.fire();
    },
    getFileName : function (cmp,event,helper) {
        var param= event.getParam("FileName");
     	cmp.set("v.fileName",param);
    },
    closeAlert : function(cmp, evt, helper) {
       	cmp.set("v.showAlert", false);
    }

})