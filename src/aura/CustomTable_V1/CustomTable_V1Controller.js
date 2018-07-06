({
    init : function(cmp, event, helper) {    
        var action = cmp.get("c.getCompromisosSytem");
        action.setParams({
            "Filtro":cmp.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                cmp.set("v.rows", response.getReturnValue());                
            } else if (state === "ERROR") {
                var errors = response.getError();
            }
        }));
        $A.enqueueAction(action);
    },
    cancel : function(cmp, event, helper) {
        cmp.set("v.table" , true);
        cmp.set("v.Controls" , false);
        $A.get('e.force:refreshView').fire();
    },
    nuevo:function(cmp, event, helper) {
        cmp.set("v.Controls" , true);
        cmp.set("v.table" , false);
    },
    closenew:function(cmp, event, helper) {
        var today = new Date();
        today.setHours(0,0,0,0);
        var Fecha =   cmp.find('FechaVencimiento');
        var vFecha =   new Date(Fecha.get('v.value'));
        var Importe =  cmp.find('ImporteDivisa');  
        var vImporte = Importe.get('v.value');
        var error = false;    
        vFecha.setDate(vFecha.getDate()+1);    
        vFecha.setHours(0,0,0,0);    
        if(vFecha < today){
            error =true;
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Validación fecha",
                message: "La fecha no debe ser menor a la fecha actual", 
                type: "warning" 
            });
            toastEvent.fire();               
        }
        if(vImporte<=0){
            error =true;
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Validación en importe",
                message: "El importe debe ser mayor a 0", 
                type: "warning" 
            });    
            toastEvent.fire();  
        }
        
        if(error==false){
            cmp.set("v.table" , true);
            cmp.set("v.Controls" , false);  
            var toastEvent = $A.get("e.force:showToast"); 
            toastEvent.setParams({ 
                title: "Success!",
                message: "Compromiso Creado", 
                type: "success" 
            });
            toastEvent.fire();  
        }
        
        
    }
})