import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDynamicResponse from "@salesforce/apex/BE_SingleRelatedList_Ctr.getDynamicResponse";
import getConfigMetaData from "@salesforce/apex/BE_SingleRelatedList_Ctr.getConfigMeta";
import updateRecords from "@salesforce/apex/BE_SingleRelatedList_Ctr.updateRecords";
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from "@salesforce/apex";
import LANG from '@salesforce/i18n/lang';
import viewAlll from '@salesforce/label/c.BE_SingleRelatedList_ViewAll';
import errorMsg from '@salesforce/label/c.Dwp_msgGenericError';
import { isNotEmpty, transformColumns, transformHeadActions, transformData, getSettingsObj } from './bE_SingleRelatedListHelper_Lwc.js';
export default class SingleRelatedList extends NavigationMixin(LightningElement) {
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
        show: false, /** Show modal */
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
    connectedCallback() {
        this.isMobile = (FORM_FACTOR === 'Small' || FORM_FACTOR === 'Medium') ? true : false;
        this.sfdcBaseURL = window.location.origin;
        this.switchTemplateMode();
        this.customTitle = isNotEmpty(this.title) ? JSON.parse((this.title))[this.lang] : '';
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
            //try {
                this.configMeta = data;
                console.log('this.columns');
                console.log(data[0].Columns__c);
                this.sObject = getSettingsObj(data[0], this.viewAlll);
                this.columns = transformColumns(data[0].Columns__c, this.lang);
                this.headActions = transformHeadActions(data[0].HeadActions__c, this.recordId, this.lang);
                this.callListData();
            /*} catch (ex) {
                this.showToastEvent("Error", ex.message, "Error");
            }*/
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
                        this.error = data.message;
                        this.showToastEvent("Error", this.error, "Error");
                    }
                } else if (error) {
                    this.error = error;
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
        this.modalStandard.show = true;
        this.modalStandard.title = modalSet.title;
        this.modalStandard.recordId = modalSet.recordId;
        this.modalStandard.sobjectType = modalSet.objectApiName;
        this.modalStandard.mode = modalSet.mode;
        this.modalStandard.fields = modalSet.fields;
        this.modalStandard.className = modalSet.className;
        this.modalStandard.redirect = modalSet.redirect;
    }
    handleCloseStanModal(event) {
        this.modalStandard.show = false;
        if (event.detail.refresh === true) {
            this.sObjectData = [];
            this.callListData();
        }
        //if LWC is inside Aura and dml action is execute in modal
        if(this.sObject.settings['refreshView'] && event.detail.isDML === true) {
            this.refreshOnAura();
        }
    }
    /** ROW ACTIONS */
    handleRowActionWeb(event) {
        event.stopPropagation();
        const modalSet = {
            recordId: event.detail.row.Id,
            mode: event.detail.action.name,
            fields: event.detail.action.fields,
            className: event.detail.action.className,
            objectApiName: event.detail.action.objectApiName,
            title: event.detail.action.title[this.lang],
        };
        this.handleOpenStanModal(modalSet);
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
        const modalSet = {
            recordId: '',
            mode: event.target.value.name,
            fields: event.target.value.fields,
            className: event.target.value.className,
            objectApiName: event.target.value.objectApiName,
            title: event.target.value.title[this.lang],
            redirect: event.target.value.redirect
        };
        this.handleOpenStanModal(modalSet);
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
        const refreshView = new CustomEvent('refreshCmp', {
            detail: { "refresh" : true }
        });
        this.dispatchEvent(refreshView);
    }

}