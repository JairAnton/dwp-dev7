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
        this.isHeadAction = (this.columns.lenght > 0) ? true : false;
    }
    /** TRANSFORM AND ASSING DATA */
    assignData() {
        let currentdataLst = [];
        this.columns.forEach(element => {
            const currentObj = {
                label: element.label,
                value: this.sObjData[element.fieldName],
                attributes: {},
                CurrencyIsoCode: 'PEN',
                isDecimal: false,
                isPercent: false,
                isCurrency: false,
                isText: false,
                isUrl: false,
                urlLabel: '',
                isEmail: false,
                isPhoneNumber: false,
                isButton: false,
                isCustomButton: false
            };
            switch (element.type) {
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
                case "customurl":
                    currentObj.urlLabel = this.sObjData[element.typeAttributes.label];
                    currentObj.value = window.location.origin + '/' + this.sObjData[element.typeAttributes.fieldName];
                    currentObj.isUrl = true;
                    break;
                case "customlookup":
                    currentObj.urlLabel = this.sObjData[element.typeAttributes.objectApiName][element.typeAttributes.label];
                    currentObj.value = window.location.origin + '/' + this.sObjData[element.typeAttributes.objectApiName][element.typeAttributes.fieldName];
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
                case "custombutton":
                    currentObj.isCustomButton = true;
                    currentObj.value = {
                        label: this.sObjData[element.typeAttributes.label.fieldName],
                        fieldName: this.sObjData[element.typeAttributes.fieldName.fieldName],
                        iconName: element.typeAttributes.iconName,
                        variant: element.typeAttributes.variant,
                        iconPosition: element.typeAttributes.iconPosition,
                        modalName: element.typeAttributes.modalName
                    }
                    break;
                case "action":
                    this.rowActions = element.typeAttributes.rowActions;
                    break;
                default:
                    currentObj.isText = true;
                    break;
            }
            currentdataLst.push(currentObj);
        });
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
    handleRowAction(event) {
        event.preventDefault();
        console.log('Open Close');
        console.log(event.target.value);
        const objParam = {
            Id: this.sObjData.Id,
            action: event.target.value
        }
        let evt = new CustomEvent('rowaction',
            { detail: objParam });
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