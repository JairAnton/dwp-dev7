import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import deleteMessage from '@salesforce/label/c.BE_SingleRelatedListModal_MsgDelete';
import btnCancel from '@salesforce/label/c.BE_SingleRelatedListModal_BtnCancel';
import btnSave from '@salesforce/label/c.BE_SingleRelatedListModal_BtnSave';
import btnDelete from '@salesforce/label/c.BE_SingleRelatedListModal_BtnDelete';
import requiredFieldsMsg from "@salesforce/label/c.BE_SingleRelatedListModal_MsgRequiredField";
import createRecords from "@salesforce/apex/BE_SingleRelatedListModal_Ctr.createRecords";
import updateRecords from "@salesforce/apex/BE_SingleRelatedListModal_Ctr.updateRecords";
import deleteRecords from "@salesforce/apex/BE_SingleRelatedListModal_Ctr.deleteRecords";

export default class BE_SingleRelatedListModal_Lwc extends NavigationMixin(LightningElement) {
    // EXPOSE LABEL TO USE IN TEMPLATE
    label = {
        deleteMessage,
        btnCancel,
        btnSave,
        btnDelete,
        requiredFieldsMsg
    }
    /** GENERAL ATRIBUTTES */
    @api recordId;
    @api title;
    @api sobjectType;
    @api sObjFields;
    @api className;
    @api modeAction;
    @api isCustom;
    @track mode;
    @track error;
    @track loaded = false;
    @api redirectToRecordPage;
    connectedCallback() {
        this.switchMode(this.modeAction);
        this.loaded = true;
    }
    handleCloseModal(refresh, refreshView) {
        let evt = new CustomEvent('closemodalweb',
            {
                detail: {
                    refresh: refresh,
                    view: refreshView
                }
            });
        this.dispatchEvent(evt);
    }
    /** CALL APEX */
    /**CREATE RECORDS */
    handleCreateRecords(objVal) {
        createRecords({
            sObjs: objVal,
            className: this.className
        })
            .then(result => {
                if (result.isSuccess) {
                    try {
                        this.loaded = true;
                        this.toggleSpinner();
                        if (this.redirectToRecordPage) {
                            this.navigateToRecordViewPage(result.data[0].Id);
                        }
                        this.showToastEvent("Success", result.message, "success");
                        this.handleCloseModal(true, true);
                    } catch (ex) {
                        this.loaded = true;
                        this.toggleSpinner();
                        this.showToastEvent("Error", ex.message, "error");
                    }
                } else {
                    this.loaded = true;
                    this.toggleSpinner();
                    this.error = result.message;
                    this.showToastEvent("Error", this.error, "error");
                }
            })
    }

    /**UPDATE RECORDS */
    handleUpdateRecords(objVal) {
        updateRecords({
            sObjs: objVal,
            className: this.className
        })
            .then(result => {
                if (result.isSuccess) {
                    try {
                        this.loaded = true;
                        this.toggleSpinner();
                        this.showToastEvent("Success", result.message, "success");
                        this.handleCloseModal(true, true);
                    } catch (ex) {
                        this.loaded = true;
                        this.toggleSpinner();
                        this.showToastEvent("Error", ex.message, "error");
                    }
                } else {
                    this.loaded = true;
                    this.toggleSpinner();
                    this.error = result.message;
                    this.showToastEvent("Error", this.error, "error");
                }
            })
    }

    /*DELETE RECORDS*/
    handleDeleteRecords(objVal) {
        deleteRecords({
            sObjs: objVal,
            className: this.className
        })
            .then(result => {
                if (result.isSuccess) {
                    try {
                        this.loaded = true;
                        this.toggleSpinner();
                        this.showToastEvent("Success", result.message, "success");
                        this.handleCloseModal(true, true);
                    } catch (ex) {
                        this.showToastEvent("Error", ex.message, "error");
                        this.loaded = true;
                        this.toggleSpinner();
                    }
                } else {
                    this.error = result.message;
                    this.showToastEvent("Error", this.error, "error");
                    this.loaded = true;
                    this.toggleSpinner();
                }
            })
    }

    /**ACTIONS BUTTONS */
    handleCreateBtn() {
        this.loaded = false;
        this.toggleSpinner();
        let targetObjLst = [];
        let isError = false;
        let targetObj = { "sobjectType": this.sobjectType };
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
            if (field.required && !this.isNotEmpty(field.value)) {
                this.showToastEvent('Error', this.label.requiredFieldsMsg, 'error');
                isError = true;
                this.loaded = true;
                this.toggleSpinner();
                break;
            }
        }
        if (isError === false) {
            targetObjLst.push(targetObj);
            this.handleCreateRecords(targetObjLst);
        }
    }
    handleUpdateBtn() {
        this.loaded = false;
        this.toggleSpinner();
        let targetObjLst = [];
        let isError = false;
        let targetObj = {
            "sobjectType": this.sobjectType,
            'Id': this.recordId
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
            if (field.required && !this.isNotEmpty(field.value)) {
                this.showToastEvent('Error', this.label.requiredFieldsMsg, 'error');
                isError = true;
                this.loaded = true;
                this.toggleSpinner();
                break;
            }
        }
        if (isError === false) {
            targetObjLst.push(targetObj);
            this.handleUpdateRecords(targetObjLst);
        }
    }
    handleDeleteBtn() {
        this.loaded = false;
        this.toggleSpinner();
        let targetObjLst = [];
        let targetObj = {
            "sobjectType": this.sobjectType,
            'Id': this.recordId
        };
        targetObjLst.push(targetObj);
        this.handleDeleteRecords(targetObjLst);
    }
    /** UTILS FUNCTIONS */
    /*SET MODE*/
    switchMode(typeMode) {
        this.mode = {
            isUpsert: false,
            isDelete: false,
            isUpdate: false,
            isInsert: false,
            isView: false
        };
        switch (typeMode) {
            case "insert":
                this.mode.isInsert = true;
                break;
            case "update":
                this.mode.isUpdate = true;
                break;
            case "delete":
                this.mode.isDelete = true;
                break;
            case "view":
                this.mode.isView = true;
                break;
        }
    }
    /** NAVIGATE TO RECORD */
    navigateToRecordViewPage(recordId) {
        // View a custom object record.
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                actionName: 'view'
            }
        });
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
    /**VALIDATE NULL, EMPTY AND BLANK*/
    isNotEmpty(obj) {
        const notEmpty = (obj === null || obj === undefined || obj === "") ? false : true;
        return notEmpty;
    }
    /** TOOGLE  */
    toggleSpinner() {
        this.template.querySelector('.customForm').classList.toggle('slds-transition-hide');
    }
}