({
	doInit : function(cmp, event, helper){
        helper.getTableData(cmp);
        cmp.set('v.columns', [
            {label: 'NOMBRE DE LA VISITA', fieldName: 'Id', type: 'url', typeAttributes: {label: {fieldName: 'Name'}} },
            {label: 'FECHA DE INICIO',fieldName: 'dwp_kitv__visit_start_date__c',type: 'date', sortable:true,
             typeAttributes:{year:'numeric',day:'2-digit',month:'2-digit',hour:'2-digit',minute:'2-digit',hour12:'false'}},
            {label: 'CREADO POR', fieldName: 'OwnerId', type: 'url', typeAttributes: {label:{fieldName: 'OwnerName'}}}
        ]);
	},
     viewall : function(cmp, event, helper) {
        let title = cmp.get("v.title");
        let type;
        let filter = '';
         if(title.indexOf("Pasadas")){
            type = "VisitLast";
            filter = cmp.get("v.filters");
         }else{type = "VisitNext";}
        let evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:BE_ViewAllOpps_Cmp",
            componentAttributes: {
                Id : cmp.get("v.recordId"),
                TypeLists : type,
                filtersLastVisit : filter
            }
        });
        evt.fire();
    },
})
