import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCommissions from '@salesforce/apex/BE_ProdCommissionSection_Ctr.getCommissions';
import calculateRate from '@salesforce/apex/BE_ProdCommissionSection_Ctr.calculateRate';
import saveCommissions from '@salesforce/apex/BE_ProdCommissionSection_Ctr.saveCommissions';
import { getRecord } from "lightning/uiRecordApi";
import OPP_ID_FIELD from '@salesforce/schema/OpportunityLineItem.Opportunity.StageName';
import STAGE_FIELD from '@salesforce/schema/OpportunityLineItem.Opportunity.StageName';
import STATUS_FIELD from '@salesforce/schema/OpportunityLineItem.Opportunity.opportunity_status_type__c';

const OPP_LINE_FIELDS = [OPP_ID_FIELD, STAGE_FIELD, STATUS_FIELD];

export default class BE_ProdCommissionSection_Lwc extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api isEditable = false;
    @api requestNegotiables = false;
    @api showCalculateButton = false;
    @api
    updateCommissions() {
        console.log('HI FROM COMMISSION!');
        this.saveCommission();
    }
    /*@api */ isPriceAuthorized = false;
    isEditableFees = false;
    @track commisions;
    questions = [];
    commissionsAnswered = [];
    loaded = false;
    error = '';
    activeSections = [];

    @track status;
    @track editRateRequest = true;
    @track editRateAuthorized = true;
    @track isRateRequestedEditable;
    @track isRateAuthorizedEditable;
    showRateRequested;
    showRateAuthorized;
    commisionHasBeenModified = true;
    showNoCommissionMessage = true;

    commissionIconsClass = (!this.requestNegotiables ? 'slds-m-left_x-small' : 'slds-col slds-size_1-of-2');

    @wire(getRecord, { recordId: '$recordId', fields: OPP_LINE_FIELDS })
    wiredopportunity(value) {
        const rateReqEdArr = ['12', '02', '18', '14', '15', '16', '17', '24', '13', '03'];
        const showRateReqArr = ['03', '02', '12', '18', '14', '15', '16', '17', '24', '13', '09', '12', '11', '08', '10'];
        if (value.data) {
            this.status = value.data.fields.Opportunity.value.fields.opportunity_status_type__c.value;
            this.isRateRequestedEditable = this.isEditable && this.editRateRequest && rateReqEdArr.includes(this.status);
            this.showRateRequested = showRateReqArr.includes(this.status);
            this.isRateAuthorizedEditable = this.isEditable && this.editRateAuthorized && (this.status === '09');
            this.showRateAuthorized = this.status === '09' || this.status === '11' || this.status === '08' || this.status === '10';
            console.log('read stage status', this.status);
            this.showNoCommissionMessage = this.isEditable && (this.status !== '09');
        } else if (value.error) {
            console.log("ERROR: ", value.error)
        }
    }

    connectedCallback() {
        getCommissions({ recordId: this.recordId, negotiables: this.requestNegotiables })
            .then(result => {
                console.log('RESULTADOS DE GET COMMISSIONS', result);
                console.log('ID', this.recordId);

                this.commisions = this.parseInitialData(result);
                if (!this.isEditable) {
                    this.activeSections = result.map((c) => c.Id);
                }

                this.error = null;
                this.loaded = true;
            })
            .catch(error => {
                console.log('ERROR', error);
                this.error = error;
                this.commisions = null;
                this.loaded = true;
            });

        this.isEditableFees = this.isEditable || (this.status === '09');
    }

    /*-----------------------------------------------*/
    /*                                               */
    /*                   UI Actions                  */
    /*                                               */
    /*-----------------------------------------------*/

    /**Updates only Questions */
    changeQuestion(event) {
        let commissionIndex = this.commisions.findIndex((cobj => cobj.Id === event.target.dataset.cid));
        let currentCommission = this.commisions[commissionIndex];
        let questionIndex = currentCommission.Commission_Questions__r.findIndex((i => i.Id === event.target.dataset.qid));
        let currentQuestion = currentCommission.Commission_Questions__r[questionIndex];

        let value;
        if (!event.currentTarget.checked) {
            value = event.currentTarget.checked;
        } else {
            value = event.currentTarget.value;
        }
        currentQuestion.Answer__c = value;
        currentCommission.isModified = true;
        this.commisionHasBeenModified = false;
        this.showNhideQuestions(currentQuestion, currentCommission.Commission_Questions__r, value);
    }

    /* Updates only Rates */
    changeRate(event) {
        let value = event.currentTarget.value;
        let commissionIndex = this.commisions.findIndex((cobj => cobj.Id === event.target.dataset.cid));
        let currentCommission = this.commisions[commissionIndex];
        currentCommission.isModified = true;
        this.commisionHasBeenModified = false;

        if (event.target.dataset.rate === 'REQUESTED') {
            currentCommission.Requested_Rate_Value__c = value;
        }
        if (event.target.dataset.rate === 'AUTHORIZED') {
            currentCommission.Authorized_Rate_Value__c = value;
        }
    }

    /*-----------------------------------------------*/
    /*                                               */
    /*                  Apex Callback                */
    /*                                               */
    /*-----------------------------------------------*/

    /**
     * Callback to Save & Calculate Commissions
     */
    saveCommission() {
        this.loaded = false;
        let commissionRequestBody = this.commisions.map((m) => {
            let { Commission_Questions__r, isModified, ...additional } = m;
            return { Commission_Questions__r: this.rewriteSubquery(Commission_Questions__r), ...additional };
        });

        let commissionCalculatePromise = this.commisions.filter(f => f.isModified).map((m) => {
            return calculateRate({ commissionId: m.Id, status: this.status });
        });

        console.log('saving...', { recordId: this.recordId });
        saveCommissions({ rawCommission: JSON.stringify({ rawCommission: commissionRequestBody }), recordId: this.recordId })
            .then(() => {
                try {
                    console.log('calculating...', commissionCalculatePromise);

                    Promise.allSettled(commissionCalculatePromise)
                        .then(result => {
                            console.log('result:...', result);

                            let rejectedIndex = result.findIndex(i => i.status === 'rejected');//status: "rejected" // status: "fulfilled"
                            if (rejectedIndex > 0) {
                                const evt = new ShowToastEvent({
                                    title: 'Error',
                                    message: 'Vuelva a intentarlo en unos momentos.',
                                    variant: 'error',
                                    mode: 'dismissable'
                                });
                                this.dispatchEvent(evt);
                            } else {
                                const evt = new ShowToastEvent({
                                    title: 'Calculo de Comisiones',
                                    message: 'Operación realizada con exito.',
                                    variant: 'success',
                                    mode: 'dismissable'
                                });
                                this.dispatchEvent(evt);
                            }
                            this.connectedCallback();
                            /** Emit calculate is done! */
                            this.emitCalculate();
                            this.error = null;
                            this.loaded = true;
                            this.showNoCommissionMessage = false;
                            this.commisionHasBeenModified = true;

                        });
                } catch (err) {
                    console.log('ERROR 1', err);
                    this.error = err;
                    this.loaded = true;
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Vuelva a intentarlo en unos momentos.',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                }

            })
            .catch(error => {
                console.log('ERROR 2', error);
                this.error = error;
                this.loaded = true;
            });

    }

    /*-----------------------------------------------*/
    /*                                               */
    /*              Dispatch Actions                 */
    /*                                               */
    /*-----------------------------------------------*/

    /** emit event when calculate had been hit */
    emitCalculate() {
        const calculateRateEvent = new CustomEvent('cmsEvent');
        this.dispatchEvent(calculateRateEvent);
    }

    /*-----------------------------------------------*/
    /*                                               */
    /*             Utilities Functions               */
    /*                                               */
    /*-----------------------------------------------*/
    addRecordToList(sourceArray, newValue) {
        let index = sourceArray.findIndex((i) => i.Id === newValue.Id);
        if (index >= 0) {
            sourceArray[index] = { ...newValue };
        } else {
            sourceArray.push(newValue);
        }
    }

    showNhideQuestions(parentQuestion, questions, value) {
        if (parentQuestion.isParent__c) {
            let childIndex = questions.findIndex((q => q.Parent_Question__c === parentQuestion.Id));
            if (childIndex >= 0) {
                questions[childIndex].isParent__c = true;
                if ((value ? 'SI' : 'NO') === questions[childIndex].Input_Value__c.toUpperCase()) {
                    questions[childIndex].isParent__c = true;
                    this.showNhideQuestions(questions[childIndex], questions);
                } else {
                    questions[childIndex].isParent__c = false;
                    this.showNhideQuestions(questions[childIndex], questions);
                }
            }
        }
    }

    rewriteSubquery(array) {
        if (array && !array.records) {
            let tempArray = array;
            array = {
                totalSize: tempArray.length,
                done: true,
                records: tempArray
            }
        }
        return array;
    }

    parseInitialData(commissions) {
        return commissions.map((c) => {
            let { Commission_Questions__r, ...cData } = c;
            let questions = [];
            if (Commission_Questions__r) {
                questions = Commission_Questions__r.map((q) => {
                    let { Answer__c, ...qData } = q;
                    let answer = true;
                    if (Answer__c === 'false') {
                        answer = false;
                    }
                    return { Answer__c: answer, ...qData };
                });
                return { Commission_Questions__r: questions, ...cData };
            }
            return { ...cData, isModified: false };
        });
    }
}
