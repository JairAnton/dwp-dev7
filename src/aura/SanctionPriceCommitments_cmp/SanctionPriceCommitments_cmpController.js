({
    close: function (cmp, evt, helper) {
        helper.closeMe(cmp, evt, helper);
    },
    doTypeMode: function (cmp, evt, helper) {
        var typeMode = evt.getParam("typeMode");
        var rowData = evt.getParam("rowData");
        var device = $A.get("$Browser.formFactor");
        var widthValue = '60rem';
        if (device !== 'DESKTOP') {
            widthValue = '85%';
        } else if (typeMode === 'DONEW') {
            widthValue = '37rem';
        }
        switch (typeMode) {
            case 'CLOSE':
                helper.closeMe(cmp, evt, helper);
                break;
            case 'DONEW':
                cmp.set('v.rowData',rowData);
                cmp.set('v.step', '2');
                cmp.set('v.modalWidthCustom', widthValue);
                break;
            case 'BACK':
                cmp.set('v.step', '1');
                cmp.set('v.modalWidthCustom', widthValue);
                helper.refresh(cmp, evt, helper);
                break;
            case 'DOCONTINUE':
                cmp.set('v.rowData',rowData);
                helper.continue(cmp, evt, helper);
                break;
            case 'DOERROR':
                cmp.set('v.step', '3');
                var errorMessage = evt.getParam("data").errorCode;
                cmp.set('v.errorlst', errorMessage);
                cmp.set('v.hasHeader', false);
                break;
            default:

        }
    },
    onchange: function(cmp, evt, helper) {
        helper.changeSugComm(cmp, evt, helper);
    },
	doContinue : function(cmp, evt, helper) {
		helper.continueSummary(cmp, evt, helper);
	}
})
