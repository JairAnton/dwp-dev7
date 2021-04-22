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
    handleUpdateSummary(evt) {
        let targetObj = {
            "sobjectType": this.sobjectType,
            "Id": this.recordId,
            "portfolio_recovery__c": evt.target.value

        };
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
    handleUpdateSummary1(evt) {
        let targetObj = {
            "sobjectType": this.sobjectType,
            "Id": this.recordId,
            "income_input__c": evt.target.value

        };
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

    handleUpdateSummary2(evt) {
        let targetObj = {
            "sobjectType": this.sobjectType,
            "Id": this.recordId,
            "expense_input__c": evt.target.value

        };
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
    



    /** NET CALCE */
    get conditionDirecto() {
        return this.calce['net_direct_calce__c'] > 0 ? true : false;
    }
    get conditionIndirecto() {
        return this.calce['net_indirect_calce__c'] > 0 ? true : false;
    }
    get conditionResource() {
        return this.calce['net_resource_calce__c'] > 0 ? true : false;
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