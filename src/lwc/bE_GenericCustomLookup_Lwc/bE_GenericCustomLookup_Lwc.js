import findLookupRecords from '@salesforce/apex/BE_NotUIAPIForm_Ctr.findLookupRecords';
import lookUpById from '@salesforce/apex/BE_NotUIAPIForm_Ctr.lookUpById';
import { api, LightningElement, track, wire } from 'lwc';

export default class BE_GenericCustomLookup_Lwc extends LightningElement {
    @api objName;
    @api iconName;
    @api labelName;
    @api fieldName;
    @api filter = '';
    @api searchPlaceholder = '';
    @api defaultValue;
    @api isRequired = false;
    @api isDisabled = false;
    @api fields;

    @track selectedName;
    @track records;
    @track isValueSelected;
    @track blurTimeout;

    searchTerm;
    //css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';

    @wire(findLookupRecords, {searchTerm : '$searchTerm', myObject : '$objName', filter : '$filter'})
    wiredRecords({ error, data }) {
        if (data) {
            this.error = undefined;
            this.records = data;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }

    connectedCallback() {
        if(this.defaultValue!==null && this.defaultValue!==undefined) {
            lookUpById( {recordId : this.defaultValue, objName : this.objName, fields : this.fields} )
            .then(result => {
                this.isValueSelected = true;
                this.selectedName = result[this.fields];
                if(this.blurTimeout) {
                    clearTimeout(this.blurTimeout);
                }
                this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
            })
            .catch(error => {
                console.log(error);
            });
        }
    }

    handleClick() {
        this.searchTerm = '';
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    onSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        const valueSelectedEvent = new CustomEvent('lookupselected', { detail: { value: selectedId, target: this.fieldName } });
        this.dispatchEvent(valueSelectedEvent);
        this.isValueSelected = true;
        this.selectedName = selectedName;
        if(this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    handleRemovePill() {
        if(!this.isDisabled) {
            this.isValueSelected = false;
            const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  '' });
            this.dispatchEvent(valueSelectedEvent);
        }
    }

    onChange(event) {
        this.searchTerm = event.target.value;
    }
}