import { LightningElement, wire, api, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getId from '@salesforce/apex/BE_TableHome_Ctr.getId';
import getData from '@salesforce/apex/BE_TableHome_Ctr.getData';
import { NavigationMixin } from 'lightning/navigation';
import LANG from '@salesforce/i18n/lang';

export default class bE_TableHome_Lwc extends NavigationMixin(LightningElement) {
    lang = LANG;
    @api devReport; /** Report id */
    @api numRows; /** Num rows */
    @api title; /** Title of section */
    @api footer; /** footer of section */
    @track lastRun; /** last run */
    @track customTitle;
    @track customFooter;
    idReport;
    @wire(getId,{
        "reportDev": "$devReport",
    })
    wiredResult({ error, data }) {
        if (data && data!==null && data!=='undefined' && data.length > 0) {
            this.idReport = data;
        } else if (error) {
            this.idReport = '';
        }
    }

    @wire(getData,{
        "reportId": "$idReport",
        "limitRows": "$numRows"
    }) rows;
    keyBlock = 'keyBlock';
    connectedCallback(){
        this.customTitle = this.isNotEmpty(this.title) ? JSON.parse((this.title))[this.lang] : '';
        this.customFooter = this.isNotEmpty(this.footer) ? JSON.parse((this.footer))[this.lang] : '';
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true };
        var d = new Date();
        this.lastRun = d.toLocaleString(this.lang, options);
    }
    handleClick(e){
        var options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', hour12: true };
        var d = new Date();
        this.lastRun = d.toLocaleString(this.lang, options);
        refreshApex(this.rows);
    }
    navigateToReport(){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.idReport,
                objectApiName: 'Report',
                actionName: 'view'
            }
        });
    }
    /**VALIDATE NULL, EMPTY AND BLANK*/
    isNotEmpty(obj){
        const notEmpty = (obj === null || obj === undefined || obj === "") ? false : true;
        return notEmpty;
    }
}