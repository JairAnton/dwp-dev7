({
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files")!=null) {
            helper.uploadHelper(component, event);
        } else {
            alert('Por favor seleccionar archivo valido');
        }
    },
 
    handleFilesChange: function(component, event, helper) {
        var fileName = 'Archivo no seleccionado..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    }    
})