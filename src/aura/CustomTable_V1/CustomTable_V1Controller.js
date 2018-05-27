({
    init: function (cmp, event, helper) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, "slds-hide");
        cmp.set('v.mycolumns', [
            {label: 'Producto', fieldName: 'PE_FM_PRODUCT__c', type: 'text'},
            {label: 'Divisa', fieldName: 'CurrencyIsoCode', type: 'text'},
            {label: 'Importe (SM)', fieldName: 'PE_DIVISA_Importe__c', type: 'number'},
            {label: 'Plazo Vcto (días)', fieldName: 'PE_NUM_Plazo_Vcto__c', type: 'number'},
            {label: 'Fecha Vcto', fieldName: 'PE_FOR_Fecha_Vcto__c', type: 'date'},
            {label: 'Permanencia', fieldName: 'PE_NUM_Permanencia__c', type: 'number'}
        ]);
        helper.getData(cmp);
    },
    destroyCmp: function (cmp, event, helper) {
        console.log("funciona");
        cmp.set("v.showModal",false);
    },
    addRecord: function (cmp, event, helper) {
        cmp.set("v.showModal",true);
    },
    handleStatusChange : function(component, event, helper) {
        if(event.getParam("status")==="FINISHED"){ 
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Success!",
                message: "Compromiso Terminada", 
                type: "success" 
            });
            toastEvent.fire(); 
            var outputVar = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": outputVar,
                "slideDevName": "related"
            });
            urlEvent.fire();
        }
        if(event.getParam("status")==="FINISHED_SCREEN"){
            
            var outputVar = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
                "recordId": outputVar,
                "slideDevName": "related"
            });
            urlEvent.fire();
        }
    }
})