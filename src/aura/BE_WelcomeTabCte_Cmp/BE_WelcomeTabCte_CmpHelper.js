({
	 loadData : function(cmp, event, helper){
        let action = cmp.get("c.getlisAllData");
        action.setParams({
            'nameConfig' : 'Modal_Info_new_tabWL'
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                let ListMdt = response.getReturnValue();
                cmp.set("v.itmsSlider",ListMdt);
            }
        });
        $A.enqueueAction(action);
    },
})
