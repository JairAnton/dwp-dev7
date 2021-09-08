import { LightningElement, api } from 'lwc';
import ChartJS23 from '@salesforce/resourceUrl/ChartJS23';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class generateBarChart extends LightningElement {
    @api chartConfig;
    isChartJsInitialized;
    renderedCallback() {
        if (this.isChartJsInitialized) {
            return;
        }
        // load chartjs from the static  resource
        Promise.all([loadScript(this, ChartJS23)])
            .then(() => {
                this.isChartJsInitialized = true;
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfig)));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading Chart',
                        message: error.message,
                        variant: 'error',
                    })
                );
            });
    }
}
