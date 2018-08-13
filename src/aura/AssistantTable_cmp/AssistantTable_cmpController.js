({
	init: function (cmp, event, helper) {
		cmp.set('v.mycolumns', [
			{ label: 'userName', fieldName: 'userId', type: 'url', typeAttributes: {label: { fieldName: 'userName' }}}
		]);
		if(!cmp.get('v.isCustom')){
			helper.getData(cmp);
		}else{
			cmp.set('v.hasRow', cmp.get('v.lstDataCustom').length > 0);
			cmp.set('v.mydata', cmp.get('v.lstDataCustom'));
		}
		
   }
})