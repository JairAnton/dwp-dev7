({
  graficaConsulta: function(component, evolucion, parametros){
  var NomInforme = component.get("v.NombreInforme");
  var sFiltro = component.get("v.Filtro");
  var sFiltroRango = component.get("v.FiltroRango");
  var sId = component.get("v.Id");
  var action = component.get("c.getGeneraJSONReporte");
  action.setParams({
                   "sNombreReporte":NomInforme,
                   "sFiltro" : sFiltro,
                   "sFiltroRango" : sFiltroRango,
                   "sId" : sId
                   });
  
  action.setCallback(this, function(response) {
                     var state = response.getState();
                     if (state === "SUCCESS") {
                     
                     component.set("v.JsonConsultas", response.getReturnValue());
                     var reportResultData = component.get("v.JsonConsultas");
                     var concepto = [];
                     var chartData = [];
                     var chartData2 = [];
                     var chartData3 = [];
                     var chartData4 = [];
                     var chartData5 = [];
                     var nombreColumnas = [];
                     var numeroGraficaCentro = parseInt("0");
                     if(reportResultData != null){
                     for(var i=0; i<reportResultData.length; i++ ){
                     if(reportResultData.length>2){
                     for(var j=0; j<reportResultData[i].length; j++){
                     switch (i){
                     case 0:
                     concepto[j] = reportResultData[i][j] ;
                     break;
                     case 1:
                     nombreColumnas[j] = reportResultData[i][j];
                     break;
                     case 2:
                     chartData[j] = reportResultData[i][j];
                     numeroGraficaCentro = numeroGraficaCentro + parseInt(chartData[j]);
                     break;
                     case 3:
                     chartData2[j] = reportResultData[i][j];
                     break;
                     case 4:
                     chartData3[j] = reportResultData[i][j] ;
                     break;
                     case 5:
                     chartData4[j] = reportResultData[i][j];
                     break;
                     case 6:
                     chartData5[j] = reportResultData[i][j];
                     break;
                     }
                     }
                     }
                     component.set("v.conceptoList", concepto);
                     component.set("v.ParametrosDina", chartData);
                     component.set("v.ParametrosDina2", chartData2);
                     component.set("v.ParametrosDina3", chartData3);
                     component.set("v.ParametrosDina4", chartData4);
                     component.set("v.ParametrosDina5", chartData5);
                     component.set("v.labelColumnas", nombreColumnas);
                     component.set("v.numeroCentro", numeroGraficaCentro);
                     }
                     }
                     
                     
                     }
                     component.set("v.BanderaEjecucion", true);
                     });
  $A.enqueueAction(action);
  //}
  },
  dibujaGrafico : function (component, evolucion){
  var concepto = component.get("v.conceptoList");
  var bfill = component.get("v.Fill");
  var bibliotecaColor = component.get("v.Colores");
  var posicion = component.get("v.posicionLeyenda");
  var ParametrosDinamicos=[];
  var InformeName = component.get("v.NombreInforme");   
  var scaleMin = (InformeName=='VINCULACION'?0:0);
  var scaleMax = (InformeName=='VINCULACION'?4:100);
  var scaleStep = (InformeName=='VINCULACION'?1:20);
  
  ParametrosDinamicos[0] = component.get("v.ParametrosDina");
  ParametrosDinamicos[1] = component.get("v.ParametrosDina2");
  ParametrosDinamicos[2] = component.get("v.ParametrosDina3");
  ParametrosDinamicos[3] = component.get("v.ParametrosDina4");
  ParametrosDinamicos[4] = component.get("v.ParametrosDina5");
  var nombreColumnas = component.get("v.labelColumnas");
  var parametros = component.get("v.TipoGrafica");
  var numeroGraficaCentro2 = component.get("v.numeroCentro");
  var tamano = String(component.get("v.tamanoValorCentro")).length;
  var graficas = [];
  var linea100 = [];
  var valortamano;
  
  for(i=0; i < concepto.length; i++)
  {
  var colorBorder=bibliotecaColor[i];
  if (colorBorder =='#ffffff')
  colorBorder='#676767';
  
  graficas[i]={
  label: concepto[i],
  data: ParametrosDinamicos[i],
  backgroundColor: bibliotecaColor[i],
  borderColor: colorBorder,
  borderWidth: 2,
  fill: bfill
  };
  }
  
  var i=0;
  var data = {
  labels: nombreColumnas,
  datasets: graficas,
  fill: bfill
  }
  
  //Draw Graphic
  data;
  window.myDoughnutChart = new Chart(evolucion, {
                                     type: parametros,
                                     data: data,
                                     
                                     options: {
                                     
                                     legend: {
                                     display: true,
                                     position: posicion,
                                     fullWidth:true,
                                     reverse:false,
                                     labels: {
                                     fontColor: '#032363'
                                     },
                                     },
                                     responsive: true,
                                     
                                     tooltips: {
                                     mode: 'index',
                                     intersect: false,
                                     },
                                     hover: {
                                     mode: 'nearest',
                                     intersect: true
                                     },
                                     scales: {
                                     yAxes: [{
                                             display: true,
                                             scaleLabel: {
                                             display: true,
                                             labelString: 'Valor'
                                             }
                                             ,
                                             ticks: {
                                             beginAtZero:true,
                                             min: scaleMin,
                                             max: scaleMax,
                                             stepSize:scaleStep
                                             }
                                             
                                             }],
                                     xAxes: [{
                                             
                                             
                                             scaleLabel: {
                                             
                                             labelString: 'Mes'
                                             }
                                             
                                             }]
                                     }
                                     }
                                     });
  }
  })