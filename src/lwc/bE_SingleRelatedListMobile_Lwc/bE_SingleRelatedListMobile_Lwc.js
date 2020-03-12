import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class BE_DynamicRelatedItem_Lwc extends NavigationMixin(LightningElement) {
    /** GENERAL ATRIBUTES */
    @api recordId; /** RecordId */
    @api columnsMobile; /** Fields of sObject */
    @api sObjApiName; /** sObject ApiName */
    @api sObjFieldLabels; /** Labels of Fields */
    @api columns; /** columns of data */
    @api rowActions;
    /** DATA ATRIBUTES */
    @api sObjData; /** initial data */
    @track sObjDataLst; /** final data*/
    connectedCallback() {
        this.sObjDataLst = this.assignData();
    }
    /** TRANSFORM AND ASSING DATA */
    assignData() {
        let indx = 0;
        let item;
        let currentdataLst = [];
        let currentLabels = this.sObjFieldLabels.split(",");
        for (item of this.columnsMobile) {
            const currentObj = {
                label: currentLabels[indx],
                value: this.sObjData[item],
                CurrencyIsoCode: 'PEN',
                isDecimal: false,
                isPercent: false,
                isCurrency: false,
                isText: false,
                isUrl: false,
                urlLabel: '',
                isEmail: false,
                isPhoneNumber: false,
                isButton:false
            };
            switch (this.columns[indx].type) {
                case "currency":
                    currentObj.isCurrency = true;
                    currentObj.CurrencyIsoCode = this.sObjData["CurrencyIsoCode"];
                    break;
                case "percent":
                    currentObj.isPercent = true;
                    break;
                case "double":
                    currentObj.isDecimal = true;
                    break;
                case "url":
                    currentObj.urlLabel = this.sObjData[this.columns[indx].typeAttributes.label.fieldName];
                    currentObj.value = this.sObjData[this.columns[indx].fieldName];
                    currentObj.isUrl = true;
                    break;
                case "text":
                case 'picklist':
                    currentObj.isText = true;
                    break;
                case "email":
                    currentObj.isEmail = true;
                    break;
                case "phone":
                    currentObj.isPhoneNumber = true;
                    break;
                case "button":
                    currentObj.isButton = true;
                    break;
                default:
                    currentObj.isText=true;
                    break;
            }
            currentdataLst.push(currentObj);
            indx++;
        }
        return currentdataLst;
    }
    /** NAVIGATE TO RECORD */
    navigateToRecordViewPage() {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view'
            }
        });
    }
    /** OPEN CUSTOM MODAL EVENT */
    handleOpenModalMobile(event){
        event.preventDefault();
        let evt = new CustomEvent('mobilemodal',
        {detail:this.sObjData.Id});
        this.dispatchEvent(evt);
    }
    
    /** OPEN CUSTOM MODAL EVENT */
    handleRowAction(event){
        event.preventDefault();
        console.log('Open Close');
        console.log(event.target.value);
        const objParam={
            recordId:this.sObjData.Id,
            mode:event.target.value
        }
        let evt = new CustomEvent('rowaction',
        {detail:objParam});
        this.dispatchEvent(evt);
    }
    /** SHOW TOAST MESSAJE */
    showToastEvent(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}
