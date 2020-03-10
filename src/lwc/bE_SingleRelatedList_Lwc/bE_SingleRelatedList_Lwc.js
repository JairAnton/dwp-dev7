import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDynamicResponse from "@salesforce/apex/BE_SingleRelatedList_Ctr.getDynamicResponse";
import getConfigMetaData from "@salesforce/apex/BE_SingleRelatedList_Ctr.getConfigMeta";
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from "@salesforce/apex";
import viewAlll from '@salesforce/label/c.BE_SingleRelatedList_ViewAll';
import errorMsg from '@salesforce/label/c.Dwp_msgGenericError';
export default class SingleRelatedList extends NavigationMixin(LightningElement) {
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
    @track hasRendered = false;
    @api isViewAll = false;
    @track isObjRelFields = false;
    @track isBtnFields = false;
    @api isMobile;
    /** DATATABLE ATRIBUTTES */
    @track columns; /** Colums of datatable */
    @track sObjectData; /** Data of datatable */

    /** MOBILE ATRIBUTES */
    @track columnsMobile; /** List of fields ApiName*/
    @track error;

    /** BUTTONS */
    @track BtnConfig;
    @track sObject;

    /**  CUSTOM MODAL ATTRIBUTES */
    @track modalRecord = {
        show: false, /** Show modal */
        recordId: '', /** recordId of Modal */
        metadataName: '' /** Dev Name of Medadata */
    }

    /** METADATA SETTINGS*/
    @track configMeta;
    wiredsObjectList;
    sfdcBaseURL;
    relListTypeMode;
    connectedCallback() {
        this.isMobile = (FORM_FACTOR === 'Small' || FORM_FACTOR === 'Medium') ? true : false;
        this.sfdcBaseURL = window.location.origin;
        this.switchTemplateMode();
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
        if (data) {
            try {
                this.configMeta = data;
                this.BtnConfig = this.isNotEmpty(data[0].BtnConfig__c) ? Object.values(JSON.parse(data[0].BtnConfig__c)) : [];
                const targetFilter = (this.isViewAll) ? data[0].Filter__c : data[0].Filter__c + ' LIMIT ' + data[0].NumberRows__c;
                this.sObject = {
                    sObjName: data[0].sObjectApiName__c,
                    sObjFields: data[0].FieldsQuery__c,
                    filterSQOL: targetFilter
                };
                this.isObjRelFields = this.isNotEmpty(data[0].FieldsUrlRelationship__c);
                this.isBtnFields = this.isNotEmpty(data[0].FieldsButtons__c);
                this.columnsMobile = data[0].Fields__c.split(",");
                this.sObjFieldLabels = data[0].Labels__c;
                this.callListData();
            } catch (ex) {
                this.showToastEvent("Error", ex.message, "Error");
            }
        } else {
            console.log("ERROR");
            console.log(error);
        }
    }
    /*GET DATA*/
    callListData() {
        getDynamicResponse({
            recordId: this.recordId,
            param: this.sObject
        })
            .then(result => {
                const { data, error } = result;
                if (data) {
                    if (result.isSuccess) {
                        try {
                            this.columns = this.getGridColumns(result.sObjFieldsMap, this.configMeta[0].Fields__c, this.configMeta[0].Labels__c);
                            this.sObjectData = (this.isObjRelFields) ? this.assignData(result.data) : result.data;
                        } catch (ex) {
                            this.showToastEvent("Error", ex.message, "Error");
                        }
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
    /**BUILD AND SET COLUMS TO DATATABLE*/
    getGridColumns(sObjFieldsMap, fieldsApiName, fieldsLabel) {
        const configCols=this.getGridColSetttings(fieldsApiName, fieldsLabel);
        let columns = [];
        for (const indicator in configCols.fieldsApiName) {
            if ({}.hasOwnProperty.call(configCols.fieldsApiName, indicator)) {
                let targetColumn = {};
                /** COLUMNS URL AND RELATIONSHIPS */
                if (configCols.relObjKeys.includes(configCols.fieldsApiName[indicator])) {
                    targetColumn=this.makeUrlRelationshipColumns(configCols,indicator);
                /**  COLUMNS BUTTONS */
                } else if (configCols.objBtnName.includes(configCols.fieldsApiName[indicator])) {
                    targetColumn = {
                        label: configCols.fieldsLabel[indicator],
                        fieldName: configCols.fieldsApiName[indicator],
                        type: 'button',
                        typeAttributes: configCols.objBtn.typeAttributes
                    };
                /** COMON COLUMNS */
                } else {
                    targetColumn = {
                        label:configCols.fieldsLabel[indicator],
                        fieldName: configCols.fieldsApiName[indicator],
                        type: sObjFieldsMap[configCols.fieldsApiName[indicator]]
                    };
                }
                columns.push(this.asigntypeAttributes(targetColumn));
            }
        }
        return columns;
    }
    /** ASSING INITIAL COLUMN VARIABLE */
    getGridColSetttings(fieldsApiName, fieldsLabel){
        const targetRelObj = (this.isObjRelFields) ? JSON.parse(this.configMeta[0].FieldsUrlRelationship__c) : [];
        const targetRelObjKeys = (this.isObjRelFields) ? Object.keys(targetRelObj) : [];
        const targetObjBtn = (this.isBtnFields) ? JSON.parse(this.configMeta[0].FieldsButtons__c.trim()) : [];
        const targetObjBtnName = (this.isBtnFields) ? Object.keys(targetObjBtn) : [];
        let settingsColumn={
        fieldsApiName : fieldsApiName.split(","),
        fieldsLabel : fieldsLabel.split(","),
        relObj : targetRelObj,
        relObjKeys:targetRelObjKeys,
        objBtn :targetObjBtn,
        objBtnName :targetObjBtnName
        }
        return settingsColumn;
    }
    /*BUILD URL AND RELATIONSHIP COLUM*/
    makeUrlRelationshipColumns(configCols,indicator){
        let targetColumn={};
        let targetPropCol = {
            fieldName: "",
            label: "",
        };
        if (configCols.relObj[configCols.fieldsApiName[indicator]].isObject) {
            targetPropCol.fieldName = configCols.relObj[configCols.fieldsApiName[indicator]].relApiName + configCols.relObj[configCols.fieldsApiName[indicator]].fieldName;
            switch (configCols.relObj[configCols.fieldsApiName[indicator]].type) {
                case "url":
                    targetPropCol.fieldName = targetPropCol.fieldName + 'Url';
                    targetPropCol.label = configCols.relObj[configCols.fieldsApiName[indicator]].relApiName + configCols.relObj[configCols.fieldsApiName[indicator]].label;
                    targetColumn = {
                        label: configCols.fieldsLabel[indicator],
                        fieldName: targetPropCol.fieldName,
                        type: 'url',
                        typeAttributes: { label: { fieldName: targetPropCol.label }, tooltip: { fieldName: targetPropCol.label }, target: '_self' }
                    };
                    break;
                default:
                    targetColumn = {
                        label: configCols.fieldsLabel[indicator],
                        fieldName: targetPropCol.fieldName,
                        type: configCols.relObj[configCols.fieldsApiName[indicator]].type
                    };
                    break;
            }
        } else {
            targetPropCol.fieldName = configCols.relObj[configCols.fieldsApiName[indicator]].fieldName + "Url";
            targetPropCol.label = configCols.relObj[configCols.fieldsApiName[indicator]].label;
            targetColumn = {
                label: configCols.fieldsLabel[indicator],
                fieldName: targetPropCol.fieldName,
                type: configCols.relObj[configCols.fieldsApiName[indicator]].type,
                typeAttributes: { label: { fieldName: targetPropCol.label }, tooltip: { fieldName: targetPropCol.label }, target: '_self' }
            };
        }
        return targetColumn;
    }
    /*BUILD AND MAKE ATRIBUTES TO OBJECT*/
    asigntypeAttributes(Obj) {
        let targetObj = { cellAttributes: { alignment: "center" } };
        switch (Obj.type) {
            case "currency":
                Object.defineProperty(targetObj, "typeAttributes", {
                    value: {
                        currencyCode: { fieldName: "CurrencyIsoCode" },
                        maximumFractionDigits: this.maximumFractionDigits,
                        minimumFractionDigits: this.minimumFractionDigits,
                        currencyDisplayAs: "code"
                    },
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
                Object.defineProperty(targetObj, "cellAttributes", {
                    value: { alignment: "left" },
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
                break;
            case "number":
                Object.defineProperty(targetObj, "typeAttributes", {
                    value: {
                        maximumFractionDigits: this.maximumFractionDigits,
                        minimumFractionDigits: this.minimumFractionDigits
                    },
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
                Object.defineProperty(targetObj, "cellAttributes", {
                    value: { alignment: "right" },
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
                break;
            case "percent":
                Object.defineProperty(targetObj, "typeAttributes", {
                    value: {
                        maximumFractionDigits: this.maximumFractionDigits,
                        minimumFractionDigits: this.minimumFractionDigits
                    },
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
                break;
            default:
                Object.defineProperty(targetObj, "cellAttributes", {
                    value: { alignment: "left" },
                    writable: true,
                    enumerable: true,
                    configurable: true
                });
                break;
        }
        targetObj = Object.assign(Obj, targetObj);
        return targetObj;
    }

    /** SET DATA  */
    assignData(data) {
        const targetRelObj = (this.isObjRelFields) ? Object.values(JSON.parse(this.configMeta[0].FieldsUrlRelationship__c)) : [];
        let currentData;
        let dataLst = [];
        for (currentData of data) {
            let targetObj = {};
            let indx;
            let targetProp = {
                fieldName: "",
                fieldNameValue: 0,
                label: "",
                labelValue: 0
            };
            for (indx of targetRelObj) {
                if (indx.isObject) {
                    targetProp.fieldName = indx.relApiName + indx.fieldName;
                    targetProp.fieldNameValue = currentData[indx.relApiName][indx.fieldName];
                    switch (indx.type) {
                        case "url":
                            targetProp.fieldName = targetProp.fieldName + 'Url';
                            targetProp.label = indx.relApiName + indx.label;
                            targetProp.labelValue = currentData[indx.relApiName][indx.label];
                            Object.defineProperty(targetObj, targetProp.fieldName, {
                                value: this.sfdcBaseURL + '/' + targetProp.fieldNameValue,
                                writable: true,
                                enumerable: true,
                                configurable: true
                            });
                            Object.defineProperty(targetObj, targetProp.label, {
                                value: targetProp.labelValue,
                                writable: true,
                                enumerable: true,
                                configurable: true
                            });
                            break;
                        default:
                            Object.defineProperty(targetObj, targetProp.fieldName, {
                                value: targetProp.fieldNameValue,
                                writable: true,
                                enumerable: true,
                                configurable: true
                            });
                            break;
                    }
                } else {
                    targetProp.fieldName = indx.fieldName + 'Url';
                    targetProp.fieldNameValue = currentData[indx.fieldName];
                    Object.defineProperty(targetObj, targetProp.fieldName, {
                        value: this.sfdcBaseURL + '/' + targetProp.fieldNameValue,
                        writable: true,
                        enumerable: true,
                        configurable: true
                    });
                }
            }
            targetObj = Object.assign(targetObj, currentData);
            dataLst.push(targetObj);
        }
        return dataLst;
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
            relListType: this.relListType,
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

    /** CUSTOM MODAL RECORD */
    getSelectedName(event) {
        this.handleModal(event.detail.row.Id, true);
    }
    handleModal(cId, showCmp) {
        this.modalRecord.recordId = cId;
        this.modalRecord.show = showCmp;
        this.modalRecord.metadataName = this.configMeta[0].ModalName__r.DeveloperName;
    }
    handleCloseModal(event) {
        this.modalRecord.show = false;
        refreshApex(this.wiredsObjectList);
    }
    handleModalMobile(event) {
        const cId = event.detail;
        this.handleModal(cId, true);
    }

    /**UTILS FUNCTIONS*/
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
}
