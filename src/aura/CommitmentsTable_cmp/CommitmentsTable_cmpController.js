({
	close : function(cmp, evt, helper) {
		var compEvent = cmp.getEvent("commitmentsEvent");
		compEvent.setParams({	"typeMode" : 'CLOSE'});
		compEvent.fire();
   	},
   	doNew : function(cmp, evt, helper){
		var compEvent = cmp.getEvent("commitmentsEvent");
		compEvent.setParams({	"typeMode" : 'DONEW'});
		compEvent.fire();
	},
	doInit : function(cmp, evt, helper){
		helper.getInfo(cmp, evt, helper);
	},
	doContinue : function(cmp, evt, helper){
		helper.continue(cmp, evt, helper);
	}
})