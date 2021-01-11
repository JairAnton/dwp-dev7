import { LightningElement, track, wire, api } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { loadScript } from 'lightning/platformResourceLoader';
import chart from '@salesforce/resourceUrl/ChartjsAP';
import getAvgMthBal from '@salesforce/apex/BE_AccountIncomeGraphic_Ctr.getAvgMthBal';
import findReport from '@salesforce/apex/BE_AccountIncomeGraphic_Ctr.findReport';
import labelViewReport from '@salesforce/label/c.BE_ViewReport';
import labelAvgMthBal from '@salesforce/label/c.BE_AvgMonthlyBalance';
import LANG from '@salesforce/i18n/lang';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class bE_AccountIncomeGraphic_Lwc extends NavigationMixin(LightningElement) {
    lang = LANG;
    @api recordId;
    @track error;
    @track cssDisplay = 'slds-visible';
    @track lastRun; /** last run */
    label = {labelViewReport, labelAvgMthBal};
    chart;
    chartjsInitialized = false;
    labelData = [];
    wiredReportId;
    wiredData;
    mapData;
    maxValue = 100;
    maxMonth = 0;
    @wire(findReport, { developerName: 'BE_Average_monthly_balance_Tmi' })
    wiredReport({ error, data }) {
        if (data) {
            this.wiredReportId = data[0].Id;
        } else if (error) {
            this.wiredReportId = '';
        }
    }
    @wire(getAvgMthBal, { recordId: '$recordId' })
    wiredResult(value) {
        if(value) {
            this.wiredData = value;
            const { data, error } = value;
            if (data) {
                this.createMap(data);
            } else if(error) {
                this.cssDisplay = "slds-hidden";
                this.error = 'No hay data disponible';
            }
        }  else if(error) {
            this.cssDisplay = "slds-hidden";
            this.error = 'No hay data disponible';
        } else {
            this.cssDisplay = "slds-hidden";
        }
    }
    createMap(data) {
        this.mapData = data;
        this.labelData = Object.keys(this.mapData);
        var notEmpty = false;
        for(var i in this.mapData) {
            for(var j in this.mapData[i]) {
                notEmpty = true;
                this.maxMonth = j;
                if(this.maxValue < this.mapData[i][j]) {
                    this.maxValue = this.mapData[i][j];
                }
            }
        }
        if(notEmpty){
            this.buildChart();
        } else {
            this.cssDisplay = "slds-hidden";
            this.error = 'No hay data disponible';
        }
    }
    buildChart() {
        var MONTHS = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Aug', 'Set', 'Oct', 'Nov', 'Dic'];
        var startMonth = 0;
        var endMonth = 12;
        var stepvalue = 10;
        if(FORM_FACTOR === 'Small') {
            stepvalue = 20;
            endMonth = this.maxMonth;
            if(endMonth-6>=0) {
                startMonth = endMonth-6;
            }
        }
        MONTHS = MONTHS.slice(startMonth, endMonth);
        var config = {
            type: 'line',
            data: {
                labels: MONTHS,
                datasets: [{
                    label: this.labelData[0],
                    backgroundColor: '#D8BE75',
                    borderColor: '#D8BE75',
                    fill: false,
                    data: Object.values(this.mapData[this.labelData[0]]).slice(startMonth, endMonth),
                }, {
                    label: this.labelData[1],
                    backgroundColor: '#C49735',
                    borderColor: '#C49735',
                    fill: false,
                    data: Object.values(this.mapData[this.labelData[1]]).slice(startMonth, endMonth),
                }, {
                    label: this.labelData[2],
                    backgroundColor: '#449EDD',
                    borderColor: '#449EDD',
                    fill: false,
                    data: Object.values(this.mapData[this.labelData[2]]).slice(startMonth, endMonth),
                }, {
                    label: this.labelData[3],
                    backgroundColor: '#004481',
                    borderColor: '#004481',
                    fill: false,
                    data: Object.values(this.mapData[this.labelData[3]]).slice(startMonth, endMonth),
                }]
            },
            options: {
                responsive: true,
                title: {
                    display: false,
                    text: this.label.labelAvgMthBal
                },
                tooltips: {
                    mode: 'index',
                    intersect: false,
                    callbacks: {
                        label: function(tooltipItem, data) {
                            var label = data.datasets[tooltipItem.datasetIndex].label || '';
                            if (label) {
                                label += ': ';
                            }
                            label += (new Intl.NumberFormat('en-US', {style: 'decimal',})).format(tooltipItem.yLabel);
                            return label;
                        }
                    }
                },
                hover: {
                    mode: 'nearest',
                    intersect: true
                },
                scales: {
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: false,
                            labelString: 'Month'
                        }
                    }],
                    yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: false,
                            labelString: 'Value'
                        },
                        ticks: {
                            min: 0,
                            max: Math.ceil(this.maxValue/100)*100,
                            stepSize: Math.ceil(this.maxValue/100)*stepvalue,
                            callback: function(value) {
                                return (new Intl.NumberFormat('en-US', {
                                    style: 'decimal',
                                })).format(value);
                            }
                        }
                    }]
                },
                legend: {
                    position: 'bottom',
                    onClick: function(e, legendItem) {
                        var index = legendItem.datasetIndex;
                        let myChart = this.chart;
                        var meta = myChart.getDatasetMeta(index);
                        meta.hidden = meta.hidden === null ? !myChart.data.datasets[index].hidden : null;
                        var maxValueAux = 100;
                        const datasets = myChart.data.datasets;
                        let iterator, ilen;
                        for (iterator = 0, ilen = datasets.length; iterator < ilen; iterator++) {
                            if(myChart.isDatasetVisible(iterator)) {
                                maxValueAux = Math.max(maxValueAux, Math.max(...datasets[iterator].data));
                            }
                        }
                        myChart.options.scales.yAxes[0].ticks.max = Math.ceil(maxValueAux/100)*100;
                        myChart.options.scales.yAxes[0].ticks.stepSize = Math.ceil(maxValueAux/100)*stepvalue;
                        myChart.update();
                    }
                }
            }
        };
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
        loadScript(this, chart + '/chartjs/Chart.js')
            .then(() => {
                const canvas = document.createElement('canvas');
                var divNode = this.template.querySelector('div.chart');
                divNode.innerHTML = '';
                divNode.appendChild(canvas);
                const ctx = canvas.getContext('2d');
                this.chart = new window.Chart(ctx, config);
                this.error = '';
            })
            .catch(error => {
                this.error = error;
            });
        this.cssDisplay = "slds-hidden";
    }
    connectedCallback(){
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true };
        var d = new Date();
        this.lastRun = d.toLocaleString(this.lang, options);
    }
    handleClick(e) {
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true };
        var d = new Date();
        this.lastRun = d.toLocaleString(this.lang, options);
        this.cssDisplay = "slds-visible";
        refreshApex(this.wiredData);
        this.chartjsInitialized = false;
        this.chart.update();
        this.cssDisplay = "slds-hidden";
    }
    navigateToReport(){
        const filterValues = JSON.stringify([{
            column: 'ACCOUNT_ID',
            value: this.recordId,
            operator: 'equals',
            isContextFilter: true
        }]);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.wiredReportId,
                objectApiName: 'Report',
                actionName: 'view'
            },
            state:{
                reportFilters: filterValues
            }
        });
    }
}
