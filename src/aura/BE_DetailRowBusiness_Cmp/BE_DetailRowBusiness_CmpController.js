({
	doInit : function(cmp, event, helper){
		var accountId = cmp.get('v.recordId');
        var dataInfo = cmp.get('c.getDataInfo');
        dataInfo.setParams({
    		'accId' : accountId
    	});
        dataInfo.setCallback(this, function(response) {
    		if(response.getState() === 'SUCCESS'){
                var resultData = response.getReturnValue();
            	cmp.set('v.data', resultData);
            }
        });
        $A.enqueueAction(dataInfo);
	},
})
