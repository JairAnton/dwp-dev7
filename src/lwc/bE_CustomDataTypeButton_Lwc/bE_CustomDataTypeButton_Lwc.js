import { LightningElement, api, track } from 'lwc';
export default class BE_CustomDataTypeButton_Lwc extends LightningElement {
    @api buttonData;
    @track show = false;
    urlValue;
    urlLabel;
    /** SHOW LWC MODAL */
    handleClick() {
        this.show = true;
    }
    /** HIDE LWC MODAL */
    handleCloseModal() {
        this.show = false;
    }
}