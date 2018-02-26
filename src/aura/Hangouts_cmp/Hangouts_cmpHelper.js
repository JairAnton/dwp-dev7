({
	hangoutsId: function(cmp, evt, helper){
    var action = cmp.get("c.getHangoutId");  
    action.setCallback(this, function(response){
        var state = response.getState();
        if (state === "SUCCESS") {
        	var result = response.getReturnValue();

            cmp.set("v.HangoutId", result.HangoutId);
            this.clickAction(cmp, evt, helper);
         }
      });
       $A.enqueueAction(action);
     },
    
    clickAction : function(cmp, evt, helper){
	    var urlEvent = $A.get("e.force:navigateToURL");
	    var hngId = cmp.get("v.HangoutId");
	    urlEvent.setParams({
	      "url": "https://plus.google.com/hangouts/_/bbva.com/"+hngId+"?authuser=0",
	      "target":"_blank"
	    });
	    urlEvent.fire();
	}
})