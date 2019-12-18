({
    PipelineOpp : function(component,event,helper) {
        var StageName01 = [];
        var StageName02 = [];
        var StageName03 = [];
        var StageName04 = [];
        var StageName05 = [];
        var Labels = [];
        var PipelineOpp = component.find("PipelineOpp").getElement();
        var ctx = PipelineOpp.getContext("2d");
        var Account = component.get("v.recordId");
        var Camping = false;
        var action = component.get("c.getOppAbierInfo");
        action.setParams({
            "accId" : Account,
            "camping" : Camping
        });
        action.setCallback(this, function(result) {
            var estado = result.getState();
            if (estado === "SUCCESS") {
                var datas = JSON.parse(result.getReturnValue());
                StageName01 =  datas[0].stage01;
                StageName02 =  datas[0].stage02;
                StageName03 =  datas[0].stage03;
                StageName04 =  datas[0].stage04;
                StageName05 =  datas[0].stage05;
                Labels =  datas[0].labels;
                graficaPipelineOpp(StageName01,StageName02,StageName03,StageName04,StageName05,Labels);
            }
        });
        $A.enqueueAction(action);
        var numberWithCommas = function(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        };
        function graficaPipelineOpp(StageName01,StageName02,StageName03,StageName04,StageName05,Labels) {
            var dates = Labels;
            window.resultadosChart = new Chart(ctx,{
                type: 'bar',
                data: {
                    labels: dates,
                    datasets: [
                        {
                            label: 'Acciones Comerciales',
                            data: StageName01,
                            backgroundColor: ['#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481'],
                            hoverBackgroundColor: "#004481",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'Pendiente de iniciar',
                            data: StageName02,
                            backgroundColor: ['#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF'],
                            hoverBackgroundColor: "#01A1DF",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'En gestión',
                            data: StageName03,
                            backgroundColor: ['#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9'],
                            hoverBackgroundColor: "#75DFD9",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'En sanción',
                            data: StageName04,
                            backgroundColor: ['#06A69E','#06A69E', '#06A69E','#06A69E',
                                              '#06A69E','#06A69E', '#06A69E','#06A69E',
                                              '#06A69E','#06A69E', '#06A69E','#06A69E'],
                            hoverBackgroundColor: "#06A69E",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'En formalización',
                            data: StageName05,
                            backgroundColor: ['#E2CE7E','#E2CE7E','#E2CE7E','#E2CE7E',
                                              '#E2CE7E','#E2CE7E','#E2CE7E','#E2CE7E',
                                              '#E2CE7E','#E2CE7E','#E2CE7E','#E2CE7E'],
                            hoverBackgroundColor: "#E2CE7E",
                            hoverBorderWidth: 0
                        },
                    ]
                        },
                        options: {
                        responsive: true,
                         maintainAspectRatio: false,
                        animation: {
                        duration: 10,
                        },
                        tooltips: {
                        mode: 'label',
                        callbacks: {
                        label: function(tooltipItem, data){
							return data.datasets[tooltipItem.datasetIndex].label + ": " + numberWithCommas(tooltipItem.yLabel);
                            }
            }
                                               },
                                               scales:{
											   xAxes:[{
												   stacked:true,
                                               gridLines:{display: false},
                                               }],
                                               yAxes:[{
												stacked:true,
                                                ticks:{
                                               beginAtZero:true,
                                                callback: function(value, index, values){
                return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
            }
			},
			}],
},
 legend: {display: true,position:'bottom',labels: {
 boxWidth: 30,
            }}
 },
 plugins: [{
 beforeInit: function (chart) {
    chart.data.labels.forEach(function (value, index, array) {
        var a = [];
        a.push(value.slice(0, 5));
        var i = 1;
        while(value.length > (i * 5)){
            a.push(value.slice(i * 5, (i + 1) * 5));
            i++;
        }
        array[index] = a;
    })
}
}]
});
}
},
    PipelineOppCamp  : function(component,event,helper) {
        var StageName01 = [];
        var StageName02 = [];
        var StageName03 = [];
        var StageName04 = [];
        var StageName05 = [];
        var Labels = [];
        var PipelineOppCamp = component.find("PipelineOppCamp").getElement();
        var ctx = PipelineOppCamp.getContext("2d");
        var Account = component.get("v.recordId");
        var Camping = true;
        var action = component.get("c.getOppAbierInfo");
        action.setParams({
            "accId" : Account,
            "camping" : Camping
        });
        action.setCallback(this, function(result) {
            var estado = result.getState();
            if (estado === "SUCCESS") {
                var datas = JSON.parse(result.getReturnValue());
                StageName01 =  datas[0].stage01;
                StageName02 =  datas[0].stage02;
                StageName03 =  datas[0].stage03;
                StageName04 =  datas[0].stage04;
                StageName05 =  datas[0].stage05;
                Labels =  datas[0].labels;
                graficaPipelineOpp(StageName01,StageName02,StageName03,StageName04,StageName05,Labels);
            }
        });
        $A.enqueueAction(action);
        var numberWithCommas = function(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        };
        function graficaPipelineOpp(StageName01,StageName02,StageName03,StageName04,StageName05,Labels) {
            var dates = Labels;
            window.resultadosChart = new Chart(ctx,{
                type: 'bar',
                data: {
                    labels: dates,
                    datasets: [
                        {
                            label: 'Acciones Comerciales',
                            data: StageName01,
                            backgroundColor: ['#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481'],
                            hoverBackgroundColor: "#004481",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'Pendiente de iniciar',
                            data: StageName02,
                            backgroundColor: ['#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF',
                                              '#01A1DF','#01A1DF'],
                            hoverBackgroundColor: "#01A1DF",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'En gestión',
                            data: StageName03,
                            backgroundColor: ['#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9',
                                              '#75DFD9','#75DFD9'],
                            hoverBackgroundColor: "#75DFD9",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'En sanción',
                            data: StageName04,
                            backgroundColor: ['#06A69E','#06A69E', '#06A69E','#06A69E',
                                              '#06A69E','#06A69E', '#06A69E','#06A69E',
                                              '#06A69E','#06A69E', '#06A69E','#06A69E'],
                            hoverBackgroundColor: "#06A69E",
                            hoverBorderWidth: 0
                        },
                        {
                            label: 'En formalización',
                            data: StageName05,
                            backgroundColor: ['#E2CE7E','#E2CE7E','#E2CE7E','#E2CE7E',
                                              '#E2CE7E','#E2CE7E','#E2CE7E','#E2CE7E',
                                              '#E2CE7E','#E2CE7E','#E2CE7E','#E2CE7E'],
                            hoverBackgroundColor: "#E2CE7E",
                            hoverBorderWidth: 0
                        },
                    ]
                        },
                        options: {
                        responsive: true,
                         maintainAspectRatio: false,
                        animation: {
                        duration: 10,
                        },
                        tooltips: {
                        mode: 'label',
                        callbacks: {
                        label: function(tooltipItem, data){
							return data.datasets[tooltipItem.datasetIndex].label + ": " + numberWithCommas(tooltipItem.yLabel);
                            }
            }
                                               },
                                               scales:{
											   xAxes:[{
												   stacked:true,
												   gridLines: { display: false },
												   }],
                                               yAxes:[{ 
                                               stacked: true,
                                               ticks:{
												   beginAtZero:true,
												   callback: function(value, index, values){
													   return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");},
   },
   }],
   },
   legend: {display: true,position:'bottom',labels: {
 boxWidth: 30,
            }}
 },
 plugins: [{
 beforeInit: function (chart) {
    chart.data.labels.forEach(function (value, index, array) {
        var a = [];
        a.push(value.slice(0, 5));
        var i = 1;
        while(value.length > (i * 5)){
            a.push(value.slice(i * 5, (i + 1) * 5));
            i++;
        }
        array[index] = a;
    })
}
}]
});
}
},
     HitOpp : function(component,event,helper) {
        var Opplist = [];
        var Labels = [];
        var hits = [];
        var HitsOpp = component.find("HitsOpp").getElement();
        var ctx = HitsOpp.getContext("2d");
        var Account = component.get("v.recordId");
        var Camping = false;
        var action = component.get("c.getOppInfoHits");
        action.setParams({
            "accId" : Account,
            "camping" : Camping
        });
        action.setCallback(this, function(result) {
            var estado = result.getState();
            if (estado === "SUCCESS") {
                var datas = JSON.parse(result.getReturnValue());
                Opplist =  datas[0].opps;
                hits =  datas[0].hits;
                Labels =  datas[0].labels;
                graficaHits(hits,Opplist,Labels);
            }
        });
        $A.enqueueAction(action);
        function graficaHits(hits,opplist,Labels) {
            var dates = Labels;
            window.resultadosChart = new Chart(ctx,{
                type: 'bar',
                data: {
                    labels: dates,
                    datasets: [
                        {
                            label: 'Hit/Miss (Efectividad)',
                            yAxisID: 'hits',
                            data: hits,
                            type: 'line',
                            borderColor: '#01A1DF',
                    borderWidth: 0,
                    fill: false,
                    backgroundColor: ['#01A1DF'],
                    pointBorderColor: '#01A1DF',
                    pointRadius: 3,
                    pointBackgroundColor: '#01A1DF',
                    pointHoverRadius: 3,
                        },
                        {
                            label: 'Oportunidades',
                            yAxisID: 'opp',
                            data: Opplist,
                            type: 'bar',
                            backgroundColor: ['#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481'],
                            borderWidth: 0
                        },
                                             ]
                        },
                        options: {
                        responsive: true,
                         maintainAspectRatio: false,
                                                 scales: {
            yAxes: [
                {
                    id: "opp",
                    ticks: {
                        beginAtZero: true,
                    },
                    scaleLabel: {
                        display: true,
                      }
                },
                {
                    id: "hits",
                    position: 'right',
                    ticks: {
                        min: 0,
                    max: 100,
                        beginAtZero: true,
                        callback: function(value) {
                    return value + "%"
                    }
                    },
                    scaleLabel: {
                        display: true,
                      }
                },
            ]
        },
 legend: {display: true,position:'bottom',labels: {
 boxWidth: 30,
            }}
 },
});
}
},
     HitOppCamp : function(component,event,helper) {
        var Opplist = [];
        var Labels = [];
        var hits = [];
        var HitsOppCamp = component.find("HitsOppCamp").getElement();
        var ctx = HitsOppCamp.getContext("2d");
        var Account = component.get("v.recordId");
        var Camping = true;
        var action = component.get("c.getOppInfoHits");
        action.setParams({
            "accId" : Account,
            "camping" : Camping
        });
        action.setCallback(this, function(result) {
            var estado = result.getState();
            if (estado === "SUCCESS") {
                var datas = JSON.parse(result.getReturnValue());
                Opplist =  datas[0].opps;
                hits =  datas[0].hits;
                Labels =  datas[0].labels;
                graficahitCamp(hits,Opplist,Labels);
            }
        });
        $A.enqueueAction(action);
        function graficahitCamp(hits,opplist,Labels) {
            var dates = Labels;
              window.resultadosChart = new Chart(ctx,{
                type: 'bar',
                data: {
                    labels: dates,
                    datasets: [
                        {
                            label: 'Hit/Miss (Efectividad)',
                            yAxisID: 'hits',
                            data: hits,
                            type: 'line',
                            borderColor: '#01A1DF',
                    borderWidth: 0,
                    fill: false,
                    backgroundColor: ['#01A1DF'],
                    pointBorderColor: '#01A1DF',
                    pointRadius: 3,
                    pointBackgroundColor: '#01A1DF',
                    pointHoverRadius: 3,
                        },
                        {
                            label: 'Oportunidades',
                            yAxisID: 'opp',
                            data: Opplist,
                            type: 'bar',
                            backgroundColor: ['#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481',
                                              '#004481','#004481'],
                            borderWidth: 0
                        },
                                             ]
                        },
                        options: {
                        responsive: true,
                         maintainAspectRatio: false,
                                                 scales: {
            yAxes: [
                {
                    id: "opp",
                    ticks: {
                        beginAtZero: true,
                    },
                    scaleLabel: {
                        display: true,
                      }
                },
                {
                    id: "hits",
                    position: 'right',
                    ticks: {
                        min: 0,
                    max: 100,
                        beginAtZero: true,
                        callback: function(value) {
                    return value + "%"
                    }
                    },
                    scaleLabel: {
                        display: true,
                      }
                },
            ]
        },
 legend: {display: true,position:'bottom',labels: {
 boxWidth: 30,
            }}
 },
});
}
},
})
