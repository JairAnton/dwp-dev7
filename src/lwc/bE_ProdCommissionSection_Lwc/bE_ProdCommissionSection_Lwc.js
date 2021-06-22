import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getCommissions from '@salesforce/apex/BE_ProdCommissionSection_Ctr.getCommissions';
import calculateRate from '@salesforce/apex/BE_ProdCommissionSection_Ctr.calculateRate';
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
    @api requestDataToAso = false;
    @api
    updateCommissions() {
        console.log('HI FROM COMMISSION!');
        this.saveCommission();
    }
    /*@api */ isPriceAuthorized = false;
    isEditableFees = false;
    isEditableQuestionnaire = true;
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
        const rateReqEdArr = ['19', '12', '02', '18', '14', '15', '16', '17', '24', '13', '03'];
        const showRateReqArr = ['03', '02', '19', '12', '18', '14', '15', '16', '17', '24', '13', '09', '12', '11', '08', '10'];
        const showRateAuthorizedArr = ['19', '09', '11', '08', '10'];
        if (value.data) {
            this.status = value.data.fields.Opportunity.value.fields.opportunity_status_type__c.value;
            this.isRateRequestedEditable = this.isEditable && this.editRateRequest && rateReqEdArr.includes(this.status);
            this.showRateRequested = showRateReqArr.includes(this.status);
            this.isRateAuthorizedEditable = this.isEditable && this.editRateAuthorized && (this.status === '09');
            this.showRateAuthorized = showRateAuthorizedArr.includes(this.status);
            this.isEditableQuestionnaire = this.status !== '09' && this.isEditable;

            console.log('read stage status', this.status);
            this.showNoCommissionMessage = this.isEditable && (this.status !== '09');
        } else if (value.error) {
            console.log("ERROR: ", value.error)
        }
    }

    connectedCallback() {
        getCommissions({ recordId: this.recordId, negotiables: this.requestNegotiables, requestDataToAso: this.requestDataToAso })
            .then(result => {
                console.log('RESULTADOS DE GET COMMISSIONS', result);
                console.log('ID', this.recordId);

                this.commisions = this.parseInitialData(result.commissions);
                if (!this.isEditable) {
                    this.activeSections = result.commissions.map((c) => c.Id);
                }

                if (result.error) {
                    let evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Vuelta a intentarlo en unos minutos.',
                        variant: 'error',
                        mode: 'dismissable'
                    });
                    if (result.responseCode === 204) {
                        evt = new ShowToastEvent({
                            title: 'Atención',
                            message: 'No hay comisiones para el presente producto.',
                            variant: 'warning',
                            mode: 'dismissable'
                        });
                    }
                    this.dispatchEvent(evt);
                    this.commisions = null;
                    this.error = result.errorBody;
                    console.log('ERROR', result);
                }
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
        if (event.target.dataset.type === 'boolean') {
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
            let { Commission_Questions__r, isModified, error, showMinimumRateClass, Requested_Rate_Value__c, Authorized_Rate_Value__c, ...additional } = m;
            if (m.Calculation_Type__c.toUpperCase() === 'PERCENTAGE') {
                Requested_Rate_Value__c = Requested_Rate_Value__c * 100;
                Authorized_Rate_Value__c = Authorized_Rate_Value__c * 100;
            }
            return { Commission_Questions__r: this.rewriteSubquery(Commission_Questions__r), Requested_Rate_Value__c, Authorized_Rate_Value__c, ...additional };
        });

        let commissionCalculatePromise = commissionRequestBody.map((cm) => {
            return calculateRate({ rawCommission: JSON.stringify({ rawCommission: cm }), recordId: cm.Id, status: this.status });
        });

        try {
            Promise.allSettled(commissionCalculatePromise)
                .then(result => {
                    console.log('result:...', result);
                    let rejectedData = result.filter(f => f.status === 'rejected' || f.value?.error);
                    if (rejectedData.length > 0) {
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
                        this.error = null;
                        this.emitCalculate();
                    }
                    this.updateCommission(result);
                    this.commisions = this.parseInitialData(this.commisions);
                    console.log('result of commissions', this.commisions);
                    this.loaded = true;
                    this.showNoCommissionMessage = false;
                    this.commisionHasBeenModified = true;
                })
        } catch (error) {
            console.log('ERROR 2', error);
            this.error = error;
            this.loaded = true;
        }

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
    updateCommission(commissions) {
        // eslint-disable-next-line guard-for-in
        for (let cindx in commissions) {
            this.commisions[cindx].error = true;
            if (commissions[cindx].value && !commissions[cindx].value?.error) {
                if (commissions[cindx].value?.commission) {
                    let index = this.commisions.findIndex((i) => i.Id === commissions[cindx].value.commission.Id);
                    if (index > -1) {
                        this.commisions[index].Commission_Calculation_Amount__c = commissions[cindx].value.commission.Commission_Calculation_Amount__c;
                        this.commisions[index].Requested_Rate_Value__c = commissions[cindx].value.commission.Requested_Rate_Value__c;
                        this.commisions[index].Authorized_Rate_Value__c = commissions[cindx].value.commission.Authorized_Rate_Value__c;
                        this.commisions[index].error = false;
                    }
                }
            }
        }
    }
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
            let tempArray = array.map((quest) => {
                if (quest.output_Type__c === 'QUANTITY' && !quest.Answer__c) {
                    quest.Answer__c = 0;
                }
                if (quest.output_Type__c === 'AMOUNT' && !quest.Answer__c) {
                    quest.Answer__c = 0;
                }
                if (quest.output_Type__c === 'YES_OR_NOT' && !quest.Answer__c) {
                    quest.Answer__c = 'NO';
                }
                return quest;
            });
            array = {
                totalSize: tempArray.length,
                done: true,
                records: tempArray
            }
        }
        return array;
    }

    parseInitialData(commissions) {
        return commissions.map((comm) => {
            let { Commission_Questions__r, ...cData } = comm;
            let questions = [];
            let showMinimumRateClass = 'slds-size_2-of-8';
            if (comm.Minimum_Rate__c) {
                showMinimumRateClass = 'slds-size_1-of-8';
            }
            if (cData.Calculation_Type__c.toUpperCase() === 'PERCENTAGE') {
                cData.Requested_Rate_Value__c = comm.Requested_Rate_Value__c / 100;
                cData.Authorized_Rate_Value__c = comm.Authorized_Rate_Value__c / 100;
            }
            if (Commission_Questions__r) {
                questions = Commission_Questions__r.map((quest) => {
                    let { Answer__c, ...qData } = quest;
                    let answer = Answer__c;
                    if (Answer__c === 'true' || Answer__c === 'YES') {
                        answer = true;
                    }
                    if (Answer__c === 'false' || Answer__c === 'NO') {
                        answer = false;
                    }
                    this.showNhideQuestions(quest, comm.Commission_Questions__r, answer);
                    return { Answer__c: answer, ...qData };
                });
                return { Commission_Questions__r: questions, ...cData };
            }
            return { ...cData, isModified: false, error: false, showMinimumRateClass };
        });
    }
}