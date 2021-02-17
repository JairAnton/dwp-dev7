import { LightningElement, api } from 'lwc';
import getQuotes from '@salesforce/apex/BE_HistoricalQuotes_Ctr.getQuotes';

export default class BE_HistoricalQuotes_Lwc extends LightningElement {
    @api recordId;
    @api config;
    columns;
    pagedData;
    currentPage = 1;
    maxPages = 1;
    disabledPreviousButton = false;
    disabledNextButton = false;
    loading = false;
    msgerror = '';

    firstCall() {
        this.currentPage = 1;
        this.gotoPage(this.currentPage);
    }

    handleButtonNext() {
        this.currentPage++;
        this.gotoPage(this.currentPage);
    }

    handleButtonPrevious() {
        this.currentPage--;
        this.gotoPage(this.currentPage);
    }

    async gotoPage(pageNumber) {
        this.disabledPreviousButton = false;
        this.disabledNextButton = false;

        if( pageNumber > this.maxPages || pageNumber < 0 ) {
            this.loading = false;
            return;
        } else {
            this.loading = true;
            await getQuotes( {"accId": this.recordId, "config": this.config} )
            .then(result => {
                if(this.columns===null || this.columns===undefined) {
                    this.columns = result.columns;
                }
                this.pagedData = result.rows;
                this.maxPages = result.totalPages;
                if(this.maxPages === this.currentPage) {
                    this.disabledNextButton = true;
                }
                if(this.currentPage === 1) {
                    this.disabledPreviousButton = true;
                }
                this.loading = false;
            }).catch(error=>{
                this.msgerror = error;
            });
        }
    }
}
