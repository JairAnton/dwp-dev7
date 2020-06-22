import { LightningElement, api, track } from 'lwc';
import getSummary from "@salesforce/apex/BE_CalceSummary_Ctr.getSummaryCalce";
import updateSummary from "@salesforce/apex/BE_CalceSummary_Ctr.updateSummaryCalce";
const DELAY = 300;
export default class BE_SummaryCalce_Lwc extends LightningElement {
    @api recordId;
    @track calce = {};
    @track error;
    @track isload = false;
    sobjectType = 'Calce__c';
    /**GET SUMMARY*/
    connectedCallback() {
        this.handleCalceSummary();
    }
    /** CALL APEX */
    handleCalceSummary() {
        this.isload = false;
        getSummary({
            recordId: this.recordId
        })
            .then(result => {
                try {
                    this.calce = result;
                    for (const key in this.calce) {
                        if (Number.isInteger(Math.round(this.calce[key]))) {
                            this.calce[key] = parseFloat(this.calce[key]).toFixed(2);
                        }
                    }
                } catch (ex) {
                    this.showToastEvent("Error", ex.message, "Error");
                }
                this.isload = true;
            })
    }
    handleUpdateSummary() {
        let targetObj = {
            "sobjectType": this.sobjectType,
            'Id': this.recordId,
        };
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        for (const field of inputFields) {
            Object.defineProperty(targetObj, field.fieldName, {
                value: field.value,
                writable: true,
                enumerable: true,
                configurable: true
            });
        }
        updateSummary({
            calce: targetObj,
        })
            .then(result => {
                if (result.isSuccess) {
                    this.calce = result.data;
                } else {
                    this.error = result.message;
                    this.showToastEvent("Error", this.error, "error");
                }
            })
    }
    /** UPDATE CALCE */
    handleSubmit(event) {
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            this.handleUpdateSummary();
        }, DELAY);
    }
    /** NET CALCE */
    get conditionDirecto() {
        return this.calce['net_direct_calce__c'] > 0 ? true : false;
    }
    get conditionIndirecto() {
        return this.calce['net_indirect_calce__c'] > 0 ? true : false;
    }
    get statusCale() {
        return this.calce['status__c'] === 'Compartido' ? true : false;
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
