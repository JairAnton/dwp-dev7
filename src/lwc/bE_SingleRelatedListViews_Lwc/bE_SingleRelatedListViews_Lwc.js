import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getConfigMetaData from "@salesforce/apex/BE_SRL_Views_Ctr.getConfigMeta";
export default class BE_SingleRelatedListViews_Lwc extends LightningElement {
    /* GENERAL INPUT ATTRIBUTES*/
    @api flexipageRegionWidth;
    @api recordId;
    @api iconName;
    @api relListType;
    @api relListSet; /** Dev name of metadata*/
    @api metaDev;
    viewOptions = [];
    /** CONTROL ATRIBUTES */
    @track customTitle;
    @track hasRendered = false;
    @api isViewAll = false;
    @api isMobile;
    @api views;
    /** GET METADATA SETTTINGS */
    @wire(getConfigMetaData, {
        "nameMetaData": "$relListSet"
    }) wiredMetadaConfig(value) {
        const { data, error } = value;
        if (data) {
            this.viewOptions = data;
            this.metaDev = this.isNotEmpty(this.metaDev) ? this.metaDev :this.viewOptions[0];
        } else {
            this.showToastEvent("Error",error, "Error");
        }
    }
    /** MULTIPLE VIEWS */
    handleChangeView(event) {
        for (const iterator of this.viewOptions) {
            if (event.detail === iterator.value) {
                this.metaDev = iterator;
            }
        }
    }
    /**UTILS FUNCTIONS*/
    /** SHOW TOAST MESSAJE */
    showToastEvent = (title, message, variant) => {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
    /** VALIDATE NOT EMPTY */
    isNotEmpty = (obj) => {
        const notEmpty = (obj === null || obj === undefined || obj === "") ? false : true;
        return notEmpty;
    };
}