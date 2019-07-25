({
    close : function(component, event, helper) {
        helper.closeMe(component, event, helper);
    },
    doContinue: function(cmp, evt, helper) {
        var proposedEmpty = cmp.get("v.proposedEmpty");
        if(proposedEmpty){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Necesitas proponer una TEA y actualizar su spread para continuar",
                "type" : "error"
            });
            toastEvent.fire();
            helper.activeButton(cmp, evt, helper);
        }else{
            helper.continue(cmp, evt, helper);
        }
    },
    doInit: function(cmp, evt, helper) {
        helper.getInfo(cmp, evt, helper);
    },
    saveResponse: function(cmp, evt, helper) {
        var web = cmp.get("v.showWebForm");
        if(!web){
            helper.doNextComponent(cmp, evt, helper);
        }else{
            var btnCalculate = cmp.get("v.btnCalculate");
            if(btnCalculate){
                cmp.set('v.hasHeader',false);
                cmp.set('v.isLoad',false);
                helper.getInfo(cmp, evt, helper);
            }else{
                helper.doNextComponent(cmp, evt, helper);
            }
            cmp.set("v.btnCalculate",false);
        }
        
    },
    updateSpread : function(cmp, evt, helper){
        cmp.set("v.btnCalculate",true);
        helper.continue(cmp, evt, helper);
    },
    
    closeAlert : function(cmp, evt, helper){
        var alerta = document.getElementById("idAlert");
        alerta.classList.add("slds-hide");
    }
})