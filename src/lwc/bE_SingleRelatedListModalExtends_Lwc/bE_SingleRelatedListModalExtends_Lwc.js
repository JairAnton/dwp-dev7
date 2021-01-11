import { LightningElement, track, api,wire } from 'lwc';
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
import fields from "@salesforce/apex/BE_SchemaUtils_Cls.getSObjectFieldsByList";

export default class BE_SingleRelatedListModalExtends_Lwc extends LightningElement {
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
    @api recordTypeId;
    @api sObjFields;
    @api className;
    @api modeAction;
    @api redirect = false;
    @track mode;
    @track error;
    @track loaded = false;
    @track record;
    fields;
    connectedCallback() {
        this.switchMode(this.modeAction);
        this.loaded = true;
    }
    /** GET METADATA SETTTINGS */
    @wire(fields, {
        "sObjName": '$sobjectType',
        "fields": '$sObjFields'
    }) wiredFields({ error, data }) {
        if (data) {
            this.fields = data;
            this.error = undefined;
            this.record = { "sobjectType": this.sobjectType };
            for (const field of this.fields) {
                Object.defineProperty(this.record, field.fieldName, {
                    value: field.fieldValue,
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
            }
            if(this.recordTypeId !== undefined && this.recordTypeId!=='') {
                Object.defineProperty(this.record, 'RecordTypeId', {
                    value: this.recordTypeId,
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
            }
            if(this.recordId !== undefined && this.recordId!=='') {
                Object.defineProperty(this.record, 'Id', {
                    value: this.recordId,
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
            }
        } else if (error) {
            this.error = error;
            this.fields = undefined;
            console.log('############## ERROR');
            console.log(this.error);
        }
    }
    
    handleChangeField(event) {
        this.record[event.target.name] = event.target.value;
    }

    handleChangeCustomField(event) {
        this.record[event.detail.target] = event.detail.value;
    }
    
    handleCloseModal(refresh, isDML) {
        let evt = new CustomEvent('closemodalweb',
            { detail: {
                refresh: refresh,
                isDML: isDML
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
                        this.showToastEvent("Success", result.message, "success");
                        if (this.redirect) {
                            this.navigateToRecordViewPage(result.data[0].Id);
                        } else {
                            this.handleCloseModal(true, true);
                        }
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
        for (const field of this.fields) {
            if(field.hasOwnProperty('isRequired')) {
                if(field.isRequired && !this.isNotEmpty(this.record[field.fieldName])) {
                    this.showToastEvent('Error', this.label.requiredFieldsMsg, 'error');
                    isError = true;
                    this.loaded = true;
                    this.toggleSpinner();
                    break;
                }
            }
        }
        if (isError === false) {
            targetObjLst.push(this.record);
            this.handleCreateRecords(targetObjLst);
        }
    }

    handleUpdateBtn() {
        this.loaded = false;
        this.toggleSpinner();
        let targetObjLst = [];
        let isError = false;
        for (const field of this.fields) {
            if(field.hasOwnProperty('isRequired')) {
                if(field.isRequired && !this.isNotEmpty(this.record[field.fieldName])) {
                    this.showToastEvent('Error', this.label.requiredFieldsMsg, 'error');
                    isError = true;
                    this.loaded = true;
                    this.toggleSpinner();
                    break;
                }
            }
        }
        if (isError === false) {
            targetObjLst.push(this.record);
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
