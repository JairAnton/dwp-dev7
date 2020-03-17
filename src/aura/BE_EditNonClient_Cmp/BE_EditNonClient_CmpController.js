({
	doInit: function(cmp, evt, helper) {
        helper.getInfo(cmp, evt, helper);
    },
    handleSubmitCustom: function(cmp, evt, helper) {
        evt.preventDefault();
        var fields = evt.getParam('fields');
        var initialsObject = {"sobejctType":cmp.get('v.sObjectType'),"id":cmp.get('v.recordId')};
        var sObjectUpdate=Object.assign(initialsObject,fields);
        delete sObjectUpdate.BillingAddress;
        helper.updateNonClients(cmp,evt,JSON.stringify(sObjectUpdate));
    },
    closeModal:function (cmp,evt,helper){
     helper.closeModal(cmp,evt);
    }
})
