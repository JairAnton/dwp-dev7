({
    init : function(component, event, helper) {
        component.set('v.showSpinner',false);
        helper.ConsultaProducto_helper(component, event);
        component.find("BtnTotal").set("v.variant", "brand");
    },
    BtnChangTotal: function(component, event, helper){
        helper.BtnNeutral(component, event, helper,'TOTAL','BtnTotal','PEN');
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",true);
    },
    BtnChangPEN: function(component, event, helper){
        helper.BtnNeutral(component, event, helper,'MN','BtnPEN','PEN');
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",true);
    },
    BtnChangUSD: function(component, event, helper){
        helper.BtnNeutral(component, event, helper,'ME','BtnUSD','USD');
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",true);
    },
    chgProduct: function(component, event, helper){
        component.set("v.ProductIS", event.getParam("value"));
            helper.toTalClient(component, event, helper);
        if(event.getParam("value")!=='CLIENTE'){
        	helper.BtnNeutral(component, event, helper,'TOTAL','BtnTotal','PEN');
        }
        $A.get('e.force:refreshView').fire();
        component.set("v.bGrafica",true);
    },
    doInitRefreshView : function(component, event, helper) {
        component.set('v.isLoad', false);
        component.set("v.bGrafica",false);
        if(window.location.href.includes(component.get('v.recordId'))){
            component.set('v.isLoad', true);
            component.set("v.bGrafica",true);
        }
    }
    
})