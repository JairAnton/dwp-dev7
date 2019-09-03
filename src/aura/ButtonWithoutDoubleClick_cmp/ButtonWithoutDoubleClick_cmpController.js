({
	handleClick : function(cmp, evt, helper){
		if(cmp.get('v.doubleClick')){
			cmp.set('v.disabled',true);
		}
		var onclick = cmp.getEvent("onclick");
		onclick.fire();
	},
	disabledButton : function(cmp, evt, helper){
		var idOpp = evt.getParam("idOpp");
		var idButton = evt.getParam("idButton");
		if(window.location.href.includes(idOpp) && idButton===cmp.get('v.id')){
			cmp.set('v.disabled',false);
		}
	}
})
