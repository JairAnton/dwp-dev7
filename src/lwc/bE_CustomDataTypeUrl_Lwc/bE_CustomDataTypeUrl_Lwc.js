import { LightningElement, api } from 'lwc';
export default class BE_CustomDataTypeUrl_Lwc extends LightningElement {
    @api label;
    @api fieldName;
    @api rowData;
    urlValue;
    urlLabel;
    connectedCallback() {
        this.urlValue = window.location.origin + '/' + this.rowData[this.fieldName];
        this.urlLabel = this.rowData[this.label];
    }
}