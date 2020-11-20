import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getConfigMetaData from "@salesforce/apex/BE_ButtonsBar_Ctr.getConfigMeta";
import getsObjectId from "@salesforce/apex/BE_ButtonsBar_Ctr.getObjectId";
export default class BE_CustomBarButtons_Lwc extends NavigationMixin(LightningElement) {
    @api buttonsSet;
    @api settings;
    @api recordId;
    @track sObject;
    @wire(getConfigMetaData, {
        "nameMetaData": "$buttonsSet"
    }) wiredMetadaConfig(value) {
        const { data, error } = value;
        if (data) {
            try {
                this.settings = JSON.parse(data[0].Buttons__c);
            } catch (ex) {
                this.showToastEvent("Error", ex.message, "Error");
            }
        } else {
            this.showToastEvent("Error", "Please enter a custom metadata settings", "Error");
        }
    }

    /*GET DATA*/
    callsObject(params) {
        params.attributes.recordId = this.recordId;
        getsObjectId({
            params: params.attributes
        }).then(result => {
            console.log('Result');
            console.log(result);
            if (result.isSuccess) {
                params.attributes.recordId = result.data[0].Id;
                this[NavigationMixin.Navigate](params);
            } else {
                this.showToastEvent("Error", "Error al consultar el registro", "Error");
            }
        })
    }

    navigateToDiffPageTypes(event) {
        // Navigate to the Case object home page.
        for (const btnItem of this.settings.buttons) {
            if (event.target.value == btnItem.name && btnItem.navigate.type == 'standard__recordPage') {
                // this[NavigationMixin.Navigate](btnItem.navigate);
                this.callsObject(btnItem.navigate);
            } else if (event.target.value == btnItem.name) {
                this[NavigationMixin.Navigate](btnItem.navigate);
            }
        }
    }
    showToastEvent = (title, message, variant) => {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
}