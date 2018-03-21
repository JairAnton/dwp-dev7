({
	init : function(component,event){
		component.set("v.bGrafica",true);
		var hoy = new Date();
		var anios =[];
     	
     	for(i=2017;i<=hoy.getFullYear(); i++)
     		anios[i-2017]=i;
		
		component.set("v.rows",anios);
	},
	filtroGrafica : function(component,event,helper){
		component.set("v.sFiltro",component.find('selFiltro').get('v.value'));
		component.set("v.sFiltroRango",component.find('selFiltroRango').get('v.value'));
        component.set("v.bGrafica",false);
        component.set("v.bGrafica",true);
    }
})