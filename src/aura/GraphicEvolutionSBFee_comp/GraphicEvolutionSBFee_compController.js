({
	init : function(component,event){
		component.set("v.bGrafica",true);		
	},
	filtroGrafica : function(component,event,helper){
		component.set("v.sFiltro",component.find('selFiltro').get('v.value'));
		
        component.set("v.bGrafica",false);
		component.set("v.bGrafica",true);
		//showRefreshGrafica(component,event);
    },
    showRefreshGrafica : function(component,event){
        component.set("v.bGrafica",true);
    }
})