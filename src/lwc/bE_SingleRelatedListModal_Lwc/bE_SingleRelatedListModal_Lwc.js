import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import deleteMessage from '@salesforce/label/c.BE_SingleRelatedListModal_MsgDelete';
import createRecords from "@salesforce/apex/BE_SingleRelatedListModal_Ctr.createRecords";
import updateRecords from "@salesforce/apex/BE_SingleRelatedListModal_Ctr.updateRecords";
import deleteRecords from "@salesforce/apex/BE_SingleRelatedListModal_Ctr.deleteRecords";
export default class BE_SingleRelatedListModal_Lwc extends NavigationMixin(LightningElement) {
    // EXPOSE LABEL TO USE IN TEMPLATE
    label = {
        deleteMessage
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
    connectedCallback() {
        this.switchMode(this.modeAction);
    }
    handleCloseModal(refresh) {
        let evt = new CustomEvent('closemodalweb',
        {detail:refresh});
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
                        this.navigateToRecordViewPage(result.data[0].Id);
                        this.showToastEvent("Success", result.message, "success");
                    } catch (ex) {
                        this.showToastEvent("Error", ex.message, "error");
                    }
                } else {
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
                        this.showToastEvent("Success", result.message, "success");
                        this.handleCloseModal(true);
                    } catch (ex) {
                        this.showToastEvent("Error", ex.message, "error");
                    }
                } else {
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
                        this.showToastEvent("Success", result.message, "success");
                        this.handleCloseModal(true);
                    } catch (ex) {
                        this.showToastEvent("Error", ex.message, "error");
                    }
                } else {
                    this.error = result.message;
                    this.showToastEvent("Error", this.error, "error");
                }
            })
    }

    /**ACTIONS BUTTONS */
    handleCreateBtn() {
        let targetObjLst = [];
        let targetObj = { "sobjectType": this.sobjectType };
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                Object.defineProperty(targetObj, field.fieldName, {
                    value: field.value,
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
            });
        }
        targetObjLst.push(targetObj);
        this.handleCreateRecords(targetObjLst);
    }

    handleUpdateBtn() {
        let targetObjLst = [];
        let targetObj = {
            "sobjectType": this.sobjectType,
            'Id': this.recordId
        };
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                Object.defineProperty(targetObj, field.fieldName, {
                    value: field.value,
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
            });
        }
        targetObjLst.push(targetObj);
        this.handleUpdateRecords(targetObjLst);
    }

    handleDeleteBtn() {
        let targetObjLst = [];
        let targetObj = {
            "sobjectType": this.sobjectType,
            'Id': this.recordId
        };
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
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

}