({
	startGraph : function(component) {
	 
      var action = component.get("c.getJSON"); 
      var lista =[];   
      var Nor =[];
      var CPP =[];
      var Def =[];
      var Dud =[];
      var Per =[];  
      var meses =[];  
      var bbva = [];    
        action.setCallback(this, function(response) {
         var state = response.getState();
                if (state === "SUCCESS") {  
                component.set("v.JsonReporte", response.getReturnValue());  
                var Informe = component.get("v.JsonReporte");
                   
                    if(Informe != null){                          
                        for(var i=0; i<Informe.length; i++ ){
                                for(var j=0; j<Informe[i].length; j++){
                                    switch (i){    
                            
                                     case 0: 
                                            meses[j] = Informe[i][j]; 
                                            break;
                                     case 1: 
                                            Nor[j] = Informe[i][j]; 
                                            break;
                                     case 2: 
                                            CPP[j] = Informe[i][j]; 
                                            break;
                                     case 3: 
                                            Def[j] = Informe[i][j]; 
                                            break;
                                     case 4: 
                                            Dud[j] = Informe[i][j]; 
                                            break; 
                                     case 5: 
                                            Per[j] = Informe[i][j]; 
                                            break;
                                     case 6: 
                                            bbva[j] = Informe[i][j]; 
                                            break;        
                                    }                                                  
                                }   
                            } 
                      component.set("v.mesesLista", meses);
                      component.set("v.Nor", Nor);
                      component.set("v.CPP", CPP);  
                      component.set("v.Def", Def);
                      component.set("v.Dud", Dud);
                      component.set("v.Per", Per);  
                      component.set("v.valoresBBVA", bbva);
                                  
        var barChartData = {       
        labels:  component.get("v.mesesLista"),
        datasets: [{
        type: 'line',    
        data: component.get("v.valoresBBVA"),
        borderDash: [10, 5],
        label:'BBVA',   
        fill: false,    
        borderColor: 'rgba(255,117,35,1)',
        borderWidth: 5,   
        },
        {
        type: 'bar', 
        data:  component.get("v.Nor"),
        backgroundColor: ['rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)',
                              'rgba(6,23,146,1)'
                             ],            
        borderDash: [5, 5],
        label:'Nor',    
        fill: true,
        stack:'stack 0',    
        borderWidth: 1
        },
        {
        type: 'bar',    
        data:  component.get("v.CPP"),
            backgroundColor: ['rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)',
                              'rgba(255,99,132,1)'
                             ],    
        label:'CPP',    
        fill: true,
        stack:'stack 0',    
        borderWidth: 1
        },{
        type: 'bar',    
        data:   component.get("v.Def", Def)  ,
        backgroundColor: ['rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,114,230,1)',
                          'rgba(96,113,230,1)'],        
        borderDash: [5, 5],
        label:'Def',    
        fill: true,
        stack:'stack 0',    
        borderWidth: 1
        },
       {
        type: 'bar',    
        data: component.get("v.Dud"),
        backgroundColor: ['rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,114,230,1)',
                          'rgba(6,113,230,1)'],        
        borderDash: [5, 5],
        label:'Dud',    
        fill: true,
        stack:'stack 0',    
        borderWidth: 1
        },
        {
        type: 'bar',    
        data: component.get("v.Per"),
        backgroundColor: ['rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)',
                          'rgba(0, 204, 68,1)'],        
        borderDash: [5, 5],
        label:'Per',    
        fill: true,
        stack:'stack 0',    
        borderWidth: 1
        }
        
                                                
                  ]            
     }
       
     var ctx = document.getElementById("DWPChart").getContext('2d');                 
     var myChart = new Chart(ctx, {
         type:'bar',     
         data: barChartData,
         options: {
                 elements: {
                 line: {
                        tension: 0 // disables curves in line graphics
                       }
                 },
               
         scales: {
            yAxes: [{
                display: true,
                position: 'left',
                ticks: {
                    beginAtZero:true,             
                    min: 0,
                    max: 100,
                    callback: function(value) {
                    return value + "%"
                    }      
                },
                stacked:true                 
            }, {
             display: true,
             position: 'right',
             ticks: {
               beginAtZero: true,
               max: 5,
               min: 0,
               stepSize: 1,
               stacked:true 
             }
            }],
            xAxes: [{
                stacked:true 
                 
            }],
            
        },
       legend: {
            display: true,
            labels: {
                },
            position:'right',
           stacked:true
             }
                   ,      
             
    }
});
                 
                      
                      
                  }
                  
                }
        });
         $A.enqueueAction(action);
        lista = component.get("v.mesesLista");
       
   
           
        
	}
})