({
	doBack : function(cmp, evt, helper) {
		helper.doBack(cmp, evt, helper);
	},
	doInit : function(cmp, evt, helper) {
		helper.getInfo(cmp, evt, helper);
	},
	onChangeProduct : function(cmp, evt, helper) {
		helper.changeProduct(cmp, evt, helper);
	},
	onChangeDivisa : function(cmp, evt, helper) {
		helper.changeDivisa(cmp, evt, helper);
	},
	doSave : function(cmp, evt, helper) {
		helper.saveCommitment(cmp, evt, helper);
	},
})