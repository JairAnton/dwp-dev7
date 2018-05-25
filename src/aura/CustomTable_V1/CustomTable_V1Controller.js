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
    }
})