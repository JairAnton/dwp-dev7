({
	close : function(cmp, evt, helper) {
		helper.closeMe(cmp, evt, helper);
   },
   doTypeMode : function(cmp, evt, helper){
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