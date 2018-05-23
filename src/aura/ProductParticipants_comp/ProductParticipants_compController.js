({
	init: function(component, event, helper) {
	    	helper.bringData(component, event, helper); 
    },
    addRecord: function(component, event, helper) {
            component.set('v.title', 'Agregar interviniente');
    		component.set("v.PParticipant",null);
	    	component.set("v.showModal",true);
    },    
    deleteRow : function(cmp, evt, helper) {
        helper.deleteParticipant(cmp, evt, helper);
    },
    editRow : function(component, evt, helper) {
    	component.set("v.PParticipant",evt.getSource().get("v.value"));
        component.set('v.title', 'Modificar interviniente');
    	//alert(component.get("v.PGuarantee"));
        component.set("v.showModal",true);
    },
    RecibeParametros : function (cmp,event,helper){
        var parametrohijo0= event.getParam("ReloadTable");
        if(parametrohijo0)
        	 helper.bringData(cmp, event, helper);            
    },       
})