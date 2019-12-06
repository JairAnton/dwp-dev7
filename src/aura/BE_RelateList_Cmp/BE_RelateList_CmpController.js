({
    doInit : function(cmp, event, helper){
	  helper.getTableData(cmp);
        cmp.set('v.columns', [
            {label: 'NOMBRE', fieldName: 'Id', type: 'url', typeAttributes: { label: { fieldName: 'Name' }} },
            {label: 'ETAPA', fieldName: 'StageName_Formula__c', type: 'String'},
            {label: 'IMPORTE', fieldName: 'Amount', type: 'currency', cellAttributes: { alignment: 'left' }  },
            {label: 'FECHA DE CREACION', fieldName: 'CreatedDate', type: 'date', sortable:true,typeAttributes:{year:'numeric',day:'2-digit',month:'2-digit'}}
        ]);
	},
    viewall : function(cmp, event, helper) {
        let evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BE_ViewAllOpps_Cmp",
            componentAttributes: {
                Id : cmp.get("v.recordId"),
                TypeLists : "Oportunidades"
            }
        });
        evt.fire();
    },
})