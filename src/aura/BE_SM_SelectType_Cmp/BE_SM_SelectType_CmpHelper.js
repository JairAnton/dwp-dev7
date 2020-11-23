({
	getTypes : function(cmp, evt) {
        var options = [];
        var action = cmp.get("c.getTypesSM");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var conts = response.getReturnValue();
                for (var key in conts) {
                    options.push({value:key, label:conts[key]});
                }
                cmp.set("v.value",options[0].value);
                cmp.set("v.options",options);
            } else {
                alert('error');
            }
        });
        $A.enqueueAction(action);
	},
    loadForm : function(cmp, event) {
        var metadata = 'BE_SM_NewRecord'+cmp.get('v.value');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BE_NewRecordForm_Cmp",
            componentAttributes: {
                sObjectType : "slmt__Sales_Meeting__c",
                isNotQuickAction : true,
                nameMetadata : metadata
            }
        });
        evt.fire();
	}
})
