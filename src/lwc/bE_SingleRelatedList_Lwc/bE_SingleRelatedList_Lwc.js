import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDynamicResponse from "@salesforce/apex/BE_SingleRelatedList_Ctr.getDynamicResponse";
import getConfigMetaData from "@salesforce/apex/BE_SingleRelatedList_Ctr.getConfigMeta";
import updateRecords from "@salesforce/apex/BE_SingleRelatedList_Ctr.updateRecords";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from "@salesforce/apex";
import LANG from '@salesforce/i18n/lang';
import viewAlll from '@salesforce/label/c.BE_SingleRelatedList_ViewAll';
import errorMsg from '@salesforce/label/c.Dwp_msgGenericError';
import { isNotEmpty, transformColumns, transformHeadActions, transformData } from './bE_SingleRelatedListHelper_Lwc.js';
import { getSettingsObj, defaultsValuesForm, obtainFields } from './bE_SingleRelatedListHelper_Lwc.js';
import getRTId from '@salesforce/apex/BE_SM_Utils.getRecordTypeId';
import lookUpById from '@salesforce/apex/BE_NotUIAPIForm_Ctr.lookUpById';
import Id from '@salesforce/user/Id';

export default class SingleRelatedList extends NavigationMixin(LightningElement) {
    userId = Id;
    lang = LANG;
    // EXPOSE LABEL TO USE IN TEMPLATE
    label = {
        viewAlll,
        errorMsg
    };
    /* GENERAL INPUT ATTRIBUTES*/
    @api flexipageRegionWidth;
    @api recordId;
    @api title; /** Title of GRID*/
    @api helpText; /** Help Text */
    @api iconName; /*IconName of table: standard:account */
    @api relListSet; /** Dev name of metadata*/
    @api relListType; /**Type of template: Basic, Title */

    /** CONTROL ATRIBUTES */
    @track customTitle;
    @track hasRendered = false;
    @api isViewAll = false;
    @api isMobile;
    /** DATATABLE ATRIBUTTES */
    @track columns; /** Colums of datatable */
    @track draftValues = [];
    @track sObjectData; /** Data of datatable */
    @track headActions;
    lastSavedData = [];
    /** MOBILE ATRIBUTES */
    @track error;
    /**  CUSTOM MODAL ATTRIBUTES */
    @track modalStandard = {
        showApiModal: false, /** Show api modal */
        showNotApiModal: false, /** Show not api modal */
        recordId: '', /** recordId of Modal */
        sobjectType: '',
        fields: '',
        mode: '',
        redirect: false
    };
    /** METADATA SETTINGS*/
    @track sObject;
    @track configMeta;
    wiredsObjectList;
    sfdcBaseURL;
    relListTypeMode;
    @track showCheckbox = false;
    @track maxRowSelection = -1;
    connectedCallback() {
        this.isMobile = (FORM_FACTOR === 'Small' || FORM_FACTOR === 'Medium') ? true : false;
        this.sfdcBaseURL = window.location.origin;
        this.switchTemplateMode();
        this.customTitle = isNotEmpty(this.title) ? JSON.parse((this.title))[this.lang] : '';
        this.helpText = isNotEmpty(this.helpText) ? JSON.parse(this.helpText)[this.lang] : '';
    }
    renderedCallback() {
        if (this.hasRendered) return;
        this.hasRendered = true;
    }
    /** GET METADATA SETTTINGS */
    @wire(getConfigMetaData, {
        "nameMetaData": "$relListSet"
    }) wiredMetadaConfig(value) {
        const { data, error } = value;
        this.wiredsObjectList = value;
        if (data) {
            try {
                this.configMeta = data;
                this.sObject = getSettingsObj(data[0], this.isViewAll);
                if(this.sObject.settings.hasOwnProperty('showCheckbox')) {
                    this.showCheckbox = this.sObject.settings.showCheckbox;
                }
                if(this.sObject.settings.hasOwnProperty('maxRowSelection')) {
                    this.maxRowSelection = this.sObject.settings.maxRowSelection;
                }
				if(this.sObject.settings.hasOwnProperty('hideViewAll')) {
                    this.isViewAll=this.sObject.settings.hideViewAll;
                }
                this.columns = transformColumns(data[0].Columns__c, this.lang);
                this.headActions = transformHeadActions(data[0].HeadActions__c, this.recordId, this.lang);
                this.callListData();
            } catch (ex) {
                this.showToastEvent("Error", ex.message, "Error");
            }
        } else {
            this.showToastEvent("Error", "Please enter a custom metadata settings", "Error");
        }
    }
    /*GET DATA*/
    callListData() {
        console.log(this.sObject);
        getDynamicResponse({
            recordId: this.recordId,
            param: this.sObject
        })
            .then(result => {
                const { data, error } = result;
                if (data) {
                    if (result.isSuccess) {
                        this.sObjectData = transformData(result.data, this.columns);
                    } else {
                        this.error += data.message;
                        this.showToastEvent("Error", this.error, "Error");
                    }
                } else if (error) {
                    this.error += error;
                    this.showToastEvent("Error", this.error, "Error");
                }
                this.loaded = true;
            })
    }
    /*SET TEMPLATE*/
    switchTemplateMode() {
        this.relListTypeMode = {
            isBasic: false,
            isEnhanced: false,
            isTitle: false,
            isDefault: false
        };
        switch (this.relListType) {
            case "Basic":
                this.relListTypeMode.isBasic = true;
                break;
            case "Enhaced":
                this.relListTypeMode.isEnhanced = true;
                break;
            case "Title":
                this.relListTypeMode.isTitle = true;
                break;
            default:
                this.relListTypeMode.isDefault = true;
                break;
        }
    }
    /** VIEW ALL RECORDS */
    handleViewAll() {
        var sObject = {
            recordId: this.recordId,
            iconName: this.iconName,
            title: this.title,
            relListSet: this.relListSet,
            relListType: 'Basic',
            isMobile: this.isMobile,
            isViewAll: true
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__BE_SingleRelatedListAll_Cmp'
            },
            state: {
                c__sObject: sObject
            }
        });
    }
    /** STANDARD MODAL */
    handleOpenStanModal(modalSet) {
        this.modalStandard.showApiModal = modalSet.showApiModal;
        this.modalStandard.showNotApiModal = modalSet.showNotApiModal;
        this.modalStandard.title = modalSet.title;
        this.modalStandard.recordId = modalSet.recordId;
        this.modalStandard.sobjectType = modalSet.objectApiName;
        this.modalStandard.recordTypeId = modalSet.recordTypeId;
        this.modalStandard.mode = modalSet.mode;
        this.modalStandard.fields = modalSet.fields;
        this.modalStandard.className = modalSet.className;
        this.modalStandard.redirect = modalSet.redirect;
    }
    handleCloseStanModal(event) {
        this.modalStandard.showApiModal = false;
        this.modalStandard.showNotApiModal = false;
        if (event.detail.refresh === true) {
            this.sObjectData = [];
            this.callListData();
        }
        //if LWC is inside Aura and dml action is execute in modal
        if (this.sObject.settings['refreshView'] && event.detail.isDML === true) {
            this.refreshOnAura();
        }
    }
    /** ROW ACTIONS */
    handleRowActionWeb(event) {
        console.log(JSON.stringify(event.detail));
        event.stopPropagation();
        if (event.detail.action.isStandardModal) {
            let defaultVal = null;
            if(event.detail.action.defaultValues !== null && event.detail.action.defaultValues!== undefined) {
                defaultVal = encodeDefaultFieldValues(defaultsValuesForm(event.detail.action.defaultValues, this.recordId, this.userId, event));
            }
            if(event.detail.action.recordTypeDevName !== null && event.detail.action.recordTypeDevName!== undefined) {
                getRTId( {"developerName": event.detail.action.recordTypeDevName} )
                .then(result => {
                    this[NavigationMixin.Navigate]({
                        type: event.detail.action.navigationType,
                        attributes: {
                            recordId: event.detail.row.Id,
                            objectApiName: event.detail.action.objectApiName,
                            actionName: event.detail.action.name
                        },
                        state: {
                            defaultFieldValues: defaultVal,
                            recordTypeId: result,
                            navigationLocation: event.detail.action.navigationLocation
                        }
                    });
                }).catch(error=>{
                    console.log('############## ERROR');
                    console.log(error);
                });
            } else {
                this[NavigationMixin.Navigate]({
                    type: event.detail.action.navigationType,
                    attributes: {
                        recordId: event.detail.row.Id,
                        objectApiName: event.detail.action.objectApiName,
                        actionName: event.detail.action.name
                    },
                    state: {
                        defaultFieldValues: defaultVal,
                        navigationLocation: event.detail.action.navigationLocation
                    }
                });
            }
            this.handleCloseStanModal(event);
        } else if (event.detail.action.isDynamicCmp) {
            let record = event.detail.row;
            let component = event.detail.action.componentName;
            let initParams = event.detail.action.componentParams;
            let params = obtainFields(initParams, record);
            console.log(JSON.stringify(component));
            console.log(JSON.stringify(initParams));
            console.log(JSON.stringify(params));
            const dynamicCMP = new CustomEvent('customtypebutton', {composed: true, bubbles: true, cancelable: true,
                detail: { "component": component, "params": params}
            });
            this.dispatchEvent(dynamicCMP);
        } else {
            let auxShowApiModal = true;
            let auxShowNotApiModal = false;
            if(event.detail.action.isNotUIAPI) {
                auxShowApiModal = false;
                auxShowNotApiModal = true;
            }
            let modalSet = {
                recordId: event.detail.row.Id,
                showApiModal: auxShowApiModal,
                showNotApiModal: auxShowNotApiModal,
                mode: event.detail.action.name,
                fields: event.detail.action.fields,
                className: event.detail.action.className,
                objectApiName: event.detail.action.objectApiName,
                recordTypeId: '',
                title: event.detail.action.title[this.lang],
            };
            
            let fieldsWithVal = [... event.detail.action.fields];
            if(event.detail.action.name === 'insert') {
                let defaultValues = defaultsValuesForm(event.detail.action.fields, this.recordId, this.userId, event);
                fieldsWithVal.forEach(item => {
                    if(defaultValues.hasOwnProperty(item.fieldName)) {
                        item['value'] = defaultValues[item.fieldName];
                    }
                });
                modalSet.fields = fieldsWithVal;

                if (event.detail.action.recordTypeDevName !== null && event.detail.action.recordTypeDevName !== undefined) {
                    getRTId({ "developerName": event.detail.action.recordTypeDevName })
                        .then(result => {
                            modalSet.recordTypeId = result;
                            this.handleOpenStanModal(modalSet);
                        }).catch(error => {
                            console.log('############## ERROR');
                            console.log(error);
                        });
                } else {
                    this.handleOpenStanModal(modalSet);
                }

            } else if(event.detail.action.name === 'update') {
                let fieldQuery = 'Id';
                for (let fieldAux of event.detail.action.fields) {
                    fieldQuery += ','+fieldAux.fieldName;
                }
                lookUpById( {recordId : event.detail.row.Id, objName : event.detail.action.objectApiName, fields : fieldQuery} )
                .then(result => {
                    fieldsWithVal.forEach(item => {
                        if(result.hasOwnProperty(item.fieldName)) {
                            item['value'] = result[item.fieldName];
                        }
                    });
                    modalSet.fields = fieldsWithVal;
                    this.handleOpenStanModal(modalSet);
                })
                .catch(error => {
                    console.log('############## ERROR');
                    console.log(error);
                });
            }
        }
    }
    handleRowActionMobile(event) {
        event.stopPropagation();
        const modalSet = {
            recordId: event.detail.Id,
            mode: event.detail.action.name,
            fields: event.detail.action.fields,
            className: event.detail.action.className,
            objectApiName: event.detail.action.objectApiName,
            title: event.detail.action.title[this.lang]
        };
        this.handleOpenStanModal(modalSet);
    }
    /** HEAD ACTIONS */
    handleHeadAction(event) {
        event.stopPropagation();
        console.log('event.target.isNotUIAPI');
        console.log(event.target.value.isNotUIAPI);
        if (event.target.value.isStandardModal) {
            let recordTypeDevName = event.target.value.recordTypeDevName;
            let navigationType = event.target.value.navigationType;
            let objectApiName = event.target.value.objectApiName;
            let actionName = event.target.value.name;
            let navigationLocation = event.target.value.navigationLocation;
            let defaultVal = null;
            if(event.target.value.fields !== null && event.target.value.fields!== undefined) {
                defaultVal = encodeDefaultFieldValues(defaultsValuesForm(event.target.value.fields, this.recordId, this.userId, null));
            }
            if(recordTypeDevName !== null && recordTypeDevName!== undefined) {
                getRTId( {"developerName": recordTypeDevName} )
                .then(result => {
                    this[NavigationMixin.Navigate]({
                        type: navigationType,
                        attributes: {
                            objectApiName: objectApiName,
                            actionName: actionName
                        },
                        state: {
                            defaultFieldValues: defaultVal,
                            recordTypeId: result,
                            navigationLocation: navigationLocation
                        }
                    });
                }).catch(error=>{
                    console.log('############## ERROR');
                    console.log(error);
                });
            } else {
                this[NavigationMixin.Navigate]({
                    type: navigationType,
                    attributes: {
                        objectApiName: objectApiName,
                        actionName: actionName
                    },
                    state: {
                        defaultFieldValues: defaultVal,
                        navigationLocation: navigationLocation
                    }
                });
            }
            this.handleCloseStanModal(event);
        } else if (event.target.value.isDynamicCmp) {
            let component = event.target.value.componentName;
            let params = event.target.value.componentParams;
            console.log(component);
            console.log(params);
        } else {
            let auxShowApiModal = true;
            let auxShowNotApiModal = false;
            if(event.target.value.isNotUIAPI) {
                auxShowApiModal = false;
                auxShowNotApiModal = true;
            }
            let modalSet = {
                recordId: '',
                showApiModal: auxShowApiModal,
                showNotApiModal: auxShowNotApiModal,
                mode: event.target.value.name,
                fields: event.target.value.fields,
                className: event.target.value.className,
                objectApiName: event.target.value.objectApiName,
                recordTypeId: '',
                title: event.target.value.title[this.lang],
                redirect: event.target.value.redirect
            };
            if (event.target.value.recordTypeDevName !== null && event.target.value.recordTypeDevName !== undefined) {
                getRTId({ "developerName": event.target.value.recordTypeDevName })
                    .then(result => {
                        modalSet.recordTypeId = result;
                        this.handleOpenStanModal(modalSet);
                    }).catch(error => {
                        console.log('############## ERROR');
                        console.log(error);
                    });
            } else {
                this.handleOpenStanModal(modalSet);
            }
        }
    }
    /** HANDLE SAVE*/
    handleInlineSave(event) {
        event.stopPropagation();
        let targetObjLst = [];
        for (const iterator of event.detail.draftValues) {
            targetObjLst.push(Object.assign({ "sobjectType": this.configMeta[0].sObjectApiName__c }, iterator));
        }
        updateRecords({
            recordId: this.recordId,
            sObjs: targetObjLst,
            className: this.sObject.settings['readClassName']
        })
            .then(result => {
                if (result.isSuccess) {
                    try {
                        this.draftValues = [];
                        this.sObjectData = [];
                        this.callListData();
                        this.showToastEvent("Success", result.message, "success");
                    } catch (ex) {
                        this.showToastEvent("Error", ex.message, "error");
                    }
                } else {
                    this.showToastEvent("Error", result.message, "error");
                }
            })
    }
    /**UTILS FUNCTIONS*/
    /** SHOW TOAST MESSAJE */
    showToastEvent = (title, message, variant) => {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
    /** CUSTOM DATATYPES */
    handleCustomTypeLookup(event) {
        event.stopPropagation();
        this.updateDraftValues(event.detail);
        this.updateDataValues(event.detail);
    }
    updateDataValues(updateItem) {
        let copyData = [... this.sObjectData];
        copyData.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
            }
        });
        //write changes back to original data
        this.data = [...copyData];
    }
    updateDraftValues(updateItem) {
        let draftValueChanged = false;
        let copyDraftValues = [...this.draftValues];
        //store changed value to do operations
        //on save. This will enable inline editing &
        //show standard cancel & save button
        copyDraftValues.forEach(item => {
            if (item.Id === updateItem.Id) {
                for (let field in updateItem) {
                    item[field] = updateItem[field];
                }
                draftValueChanged = true;
            }
        });

        if (draftValueChanged) {
            this.draftValues = [...copyDraftValues];
        } else {
            this.draftValues = [...copyDraftValues, updateItem];
        }
    }

    /**Refresh if lwc is involved in aura*/
    refreshOnAura() {
        const refreshView = new CustomEvent('refreshCmp', {detail: { "refresh": true }});
        this.dispatchEvent(refreshView);
    }

    /**Checkbox change event*/
    handleCheckboxChange(event) {
        const selectedRows = event.detail.selectedRows;
        const checkboxChangeEvent = new CustomEvent('checkboxchange', {
            detail: { selectedRows },
        });
        this.dispatchEvent(checkboxChangeEvent);
    }

}
