import { LightningElement, api, track } from 'lwc';
// Accessibility module
import { baseNavigation } from 'lightning/datatableKeyboardMixins';
import { NavigationMixin } from 'lightning/navigation';
export default class BE_CustomDataTypeLookup_Lwc extends LightningElement {
    @api label;
    @api fieldName;
    @api objectApiName;
    @api rowData;
    @api editable=false;
    urlValue;
    urlLabel;
    @track isEdit = false;
    connectedCallback() {
        this.urlValue = window.location.origin + '/' + this.rowData[this.objectApiName][this.fieldName];
        this.urlLabel = this.rowData[this.objectApiName][this.label];
    }
    /** FUNCTIONS */
    handleEditAction() {
        console.log();
        this.isEdit = true;
    }
    handleSetValue(event) {
        console.log("event Value");
        console.log(event);
        console.log(this.Id);
        let sObj = { Id: this.recordId }
        Object.defineProperty(sObj, this.fieldName, {
            value: event.target.value,
            writable: true,
            enumerable: true,
            configurable: true
        });
        const eventEdit = CustomEvent('customtypelookup', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: sObj,
        });
        this.dispatchEvent(eventEdit);
    }
}