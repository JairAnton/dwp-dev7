({
	getData : function(cmp) {
		var action = cmp.get('c.getInfo');
		action.setParams({
            recordId : cmp.get('v.recordId')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                var lstCustom = cmp.get('v.lstDataCustom');
                cmp.set('v.hasRow',JSON.parse(ret.info).concat(lstCustom).length > 0);
				cmp.set('v.mydata', JSON.parse(ret.info).concat(lstCustom));
            }
        }));
        $A.enqueueAction(action);
	}
})