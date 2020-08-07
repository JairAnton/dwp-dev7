({
    close : function(component, event, helper) {
        helper.closeMe(component, event, helper);
    },
    doContinue: function(cmp, evt, helper) {
        var proposedEmpty = cmp.get("v.proposedEmpty");
        if(proposedEmpty) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Necesitas proponer una TEA y actualizar su spread para continuar",
                "type" : "error"
            });
            toastEvent.fire();
            helper.activeButton(cmp, evt, helper);
        } else {
            helper.continue(cmp, evt, helper);
        }
    },
    doInit: function(cmp, evt, helper) {
        helper.calculateRate(cmp, evt, helper);
    },
    saveResponse: function(cmp, evt, helper) {
        var web = cmp.get("v.showWebForm");
        if(web) {
            var btnCalculate = cmp.get("v.btnCalculate");
            if(btnCalculate) {
                cmp.set('v.hasHeader',false);
                cmp.set('v.isLoad',false);
                helper.getInfo(cmp, evt, helper);
            } else {
                helper.doNextComponent(cmp, evt, helper);
            }
            cmp.set("v.btnCalculate",false);
        } else {
            helper.doNextComponent(cmp, evt, helper);
        }
    },
    doTypeMode : function(cmp, evt, helper) {
        var typeMode = evt.getParam("typeMode");
        switch(typeMode) {
            case 'CLOSE':
                helper.closeMe(cmp, evt, helper);
                break;
            case 'DONEW':
                cmp.set('v.step','2');
                cmp.set('v.modalWidthCustom','37rem');
                break;
            case 'BACK':
                cmp.set('v.step','1');
                cmp.set('v.modalWidthCustom','60rem');
                break;
            case 'DOCONTINUE':
                helper.doContinueNext(cmp, evt, helper);
                break;
            case 'DOERROR':
                cmp.set('v.step','3');
                var errorMessage = evt.getParam("data").errorCode;
                cmp.set('v.errorlst',errorMessage);
                cmp.set('v.hasHeader',false);
                break;
            default:
        }
    }
})