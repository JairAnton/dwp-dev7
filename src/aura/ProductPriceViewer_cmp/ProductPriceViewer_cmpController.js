({
	doInit: function(cmp, evt, helper){
		helper.getInfo(cmp, evt, helper);
	},
	doInitRefreshView: function(cmp, evt, helper){
		console.log('refres');
		if(window.location.href.includes(cmp.get('v.recordId'))){
			helper.getInfo(cmp, evt, helper);
		}
	}
})