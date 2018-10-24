({
    init : function(component, event, helper) {
        component.set('v.showSpinner',false);
        helper.ConsultaProducto_helper(component, event);
        component.set('v.isLoad', false);
        component.set('v.ProductIS', 'true');
        component.set('v.coint1', 'PEN');
        component.find("BtnTotal").set("v.variant", "brand");
        component.set("v.bGrafica",true);
    },
    BtnChangTotal: function(component, event, helper){
        var Type='TOTAL';
        component.set('v.profiType', Type);
        helper.BtnNeutral(component, event, helper);
        component.find("BtnTotal").set("v.variant", "brand");
        component.set('v.coint1', 'PEN');
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",false);
        component.set("v.bGrafica",true);
    },
    BtnChangPEN: function(component, event, helper){
        var Type='MN';
        component.set('v.profiType', Type);
        helper.BtnNeutral(component, event, helper);
        component.find("BtnPEN").set("v.variant", "brand");
        component.set('v.coint1', 'PEN');
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",false);
        component.set("v.bGrafica",true);
    },
    BtnChangUSD: function(component, event, helper){
        var Type='ME';
        component.set('v.profiType', Type);
        helper.BtnNeutral(component, event, helper);
        component.find("BtnUSD").set("v.variant", "brand");
        component.set('v.coint1', 'USD');
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",false);
        component.set("v.bGrafica",true);
    },
    chgProduct: function(component, event, helper){
        component.set("v.ProductIS", event.getParam("value"));
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",false);
        component.set("v.bGrafica",true);
    },
    doInitRefreshView : function(component, event, helper) {
        component.set('v.isLoad', false);
        if(window.location.href.includes(component.get('v.recordId'))){
            component.set('v.isLoad', true);
        }
    }
})