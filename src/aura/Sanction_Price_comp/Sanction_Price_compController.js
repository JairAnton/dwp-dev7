({
	init: function(component, event, helper) {
		
	    	helper.bringData(component, event, helper); 
    },
	close : function(component, event, helper) {
		helper.destroyCmp(component, event, helper);
	},

})