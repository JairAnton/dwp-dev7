({
    getInfo : function(cmp, evt, helper){
        var action = cmp.get("c.getInfo");
        action.setParams({
            "recordId" : cmp.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state: ', state);
            if (state === "SUCCESS") {
                var ret = response.getReturnValue();
                console.log('ret: ', ret);
                if(ret.hasOLI){
                    var objectInput = {
                        'IdOppLineItem':ret.IdOppLineItem,
                        'approvalMethod':ret.approvalMethod
                    };
                    cmp.set('v.objectInput',objectInput);
                }

                cmp.set('v.isLoad',true);
                cmp.set('v.hasOLI',ret.hasOLI);
            }
        }); 
        $A.enqueueAction(action);
    }
})