({
    close : function(cmp, evt, helper) {
        helper.closeMe(cmp, evt, helper);
    },
    doInit: function(cmp, evt, helper) {
        var device = $A.get("$Browser.formFactor");
        if(device!=='DESKTOP') {
            cmp.set('v.modalWidthCustom', "85%");
        }
    },
    doTypeMode : function(cmp, evt, helper){
        var typeMode = evt.getParam("typeMode");
        var device = $A.get("$Browser.formFactor");
        var widthValue = '60rem';
        if(device!=='DESKTOP') {
            widthValue = '85%';
        } else if(typeMode==='DONEW') {
            widthValue = '37rem';
        }
        switch(typeMode) {
            case 'CLOSE':
                helper.closeMe(cmp, evt, helper);
                break;
            case 'DONEW':
                cmp.set('v.step','2');
                cmp.set('v.modalWidthCustom',widthValue);
                break;
            case 'BACK':
                cmp.set('v.step','1');
                cmp.set('v.modalWidthCustom',widthValue);
                break;
            case 'DOCONTINUE':
                helper.continue(cmp, evt, helper);
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
