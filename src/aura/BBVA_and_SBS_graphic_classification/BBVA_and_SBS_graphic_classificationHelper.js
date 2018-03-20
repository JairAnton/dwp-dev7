({
	startGraph : function(componet) {
	
        
      var action = componet.get("c.fecthBBVA_SBS"); 
        
        
        var barChartData = {       
        labels: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio","Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        datasets: [{
        type: 'line',    
        data: [50, 90, 30, 50, 20, 30,10,60,70,40,60,90],
        borderDash: [10, 5],
        label:'BBVA',   
        fill: false,    
        borderColor: 'rgba(255,153,50,1)',
        borderWidth: 5,   
        },
        {
        type: 'bar',    
        data: [50, 90, 30, 50, 20, 30,10,60,70,40,60,90],
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
        label:'Peru',    
        fill: true,
        stack:'stack 0',    
        borderWidth: 1
        },
        {
        type: 'bar',    
        data: [30, 10, 40, 20, 80, 50,60,20,10,20,20,10],
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
        label:'Lima',    
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
})