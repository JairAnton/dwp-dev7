({
    init: function (component, event) {
        component.set("v.idAux", "");
        component.set("v.load", false);
        component.set("v.idAux", component.get("v.recordId"));
        component.set("v.load", true);
    },

    refreshOnAura: function (component, event) {
        $A.get('e.force:refreshView').fire();
    }
})