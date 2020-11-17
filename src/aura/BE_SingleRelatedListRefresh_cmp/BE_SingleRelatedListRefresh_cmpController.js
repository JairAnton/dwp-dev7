({
    init: function (component, event) {
        component.set("v.idAux", "");
        component.set("v.load", false);
        component.set("v.idAux", component.get("v.recordId"));
        component.set("v.load", true);
    },
    refreshOnAura: function (component, event) {
        $A.get('e.force:refreshView').fire();
    },
    handleCustomAction: function (component, event) {
        $A.createComponent(
            event.getParam('component'), event.getParam('params'),
            function(newCmp, status, errorMessage){
                if(status === 'SUCCESS') {
                    var body = component.get("v.dynamicComponent");
                    body.push(newCmp);
                    component.set("v.dynamicComponent", body);
                } else if(status === 'INCOMPLETE') {
                    console.log("No response from server or client is offline.");
                } else if(status === 'ERROR'){
                    console.log('ERROR '+errorMessage);
                }
            }
        );
    },
    hideDynamicComponent : function(component, message) {
        component.set("v.dynamicComponent", []);
    }
})
