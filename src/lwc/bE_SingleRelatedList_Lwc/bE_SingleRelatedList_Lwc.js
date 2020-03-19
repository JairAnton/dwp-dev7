import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDynamicResponse from "@salesforce/apex/BE_SingleRelatedList_Ctr.getDynamicResponse";
import getConfigMetaData from "@salesforce/apex/BE_SingleRelatedList_Ctr.getConfigMeta";
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from "@salesforce/apex";
import LANG from '@salesforce/i18n/lang';
import btnDelete from '@salesforce/label/c.BE_SingleRelatedList_BtnDelete';
import btnView from '@salesforce/label/c.BE_SingleRelatedList_BtnView';
import btnNew from '@salesforce/label/c.BE_SingleRelatedList_BtnNew';
import viewAlll from '@salesforce/label/c.BE_SingleRelatedList_ViewAll';
import errorMsg from '@salesforce/label/c.Dwp_msgGenericError';
export default class SingleRelatedList extends NavigationMixin(LightningElement) {
    lang = LANG;
    // EXPOSE LABEL TO USE IN TEMPLATE
    label = {
        viewAlll,
        errorMsg,
        btnView,
        btnNew,
        btnDelete
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
    @track isObjRelFields = false;
    @track isBtnFields = false;
    @api isMobile;
    /** DATATABLE ATRIBUTTES */
    @track columns; /** Colums of datatable */
    sObjectData; /** Data of datatable */
    @track customHeadActions;
    @track rowActions;
    @track customRowActions;
    /** MOBILE ATRIBUTES */
    @track columnsMobile; /** List of fields ApiName*/
    @track error;

    /** BUTTONS */
    @track BtnConfig = {
        values: [],
        map: null
    }
    @track sObject;

    /**  CUSTOM MODAL ATTRIBUTES */
    @track modalRecord = {
        show: false, /** Show modal */
        recordId: '', /** recordId of Modal */
        metadataName: '' /** Dev Name of Medadata */
    }

    /** STANDARD MODAL */
    @track modalStandard = {
        show: false, /** Show modal */
        recordId: '', /** recordId of Modal */
        sobjectType: '',
        fields: '',
        mode: ''
    };
    /** METADATA SETTINGS*/
    @track configMeta;
    wiredsObjectList;
    sfdcBaseURL;
    relListTypeMode;
    connectedCallback() {
        this.isMobile = (FORM_FACTOR === 'Small' || FORM_FACTOR === 'Medium') ? true : false;
        this.sfdcBaseURL = window.location.origin;
        this.switchTemplateMode();
        this.customTitle = this.isNotEmpty(this.title) ? JSON.parse((this.title))[this.lang] : '';
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
                this.BtnConfig.map = this.isNotEmpty(data[0].BtnConfig__c) ? JSON.parse(data[0].BtnConfig__c) : [];
                this.BtnConfig.values = this.setHeadActions();
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
        const configCols = this.getGridColSetttings(fieldsApiName, fieldsLabel);
        this.rowActions = this.setRowActions();
        let columns = [];
        for (const indicator in configCols.fieldsApiName) {
            if ({}.hasOwnProperty.call(configCols.fieldsApiName, indicator)) {
                let targetColumn = {
                };
                /** COLUMNS URL AND RELATIONSHIPS */
                if (configCols.relObjKeys.includes(configCols.fieldsApiName[indicator])) {
                    targetColumn = this.makeUrlRelationshipColumns(configCols, indicator);
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
                        label: configCols.fieldsLabel[indicator],
                        fieldName: configCols.fieldsApiName[indicator],
                        type: sObjFieldsMap[configCols.fieldsApiName[indicator]]
                    };
                }
                columns.push(this.asigntypeAttributes(targetColumn));
            }
        }
        /** SET ROW ACTIONS */
        if (this.rowActions.length > 0) {
            columns.push({
                type: 'action',
                typeAttributes: { rowActions: this.rowActions },
            });
        }
        return columns;
    }
    /** ASSING INITIAL COLUMN VARIABLE */
    getGridColSetttings(fieldsApiName, fieldsLabel) {
        const targetRelObj = (this.isObjRelFields) ? JSON.parse(this.configMeta[0].FieldsUrlRelationship__c) : [];
        const targetRelObjKeys = (this.isObjRelFields) ? Object.keys(targetRelObj) : [];
        const targetObjBtn = (this.isBtnFields) ? JSON.parse(this.configMeta[0].FieldsButtons__c.trim()) : [];
        const targetObjBtnName = (this.isBtnFields) ? Object.keys(targetObjBtn) : [];
        let settingsColumn = {
            fieldsApiName: fieldsApiName.split(","),
            fieldsLabel: fieldsLabel.split(","),
            relObj: targetRelObj,
            relObjKeys: targetRelObjKeys,
            objBtn: targetObjBtn,
            objBtnName: targetObjBtnName
        }
        return settingsColumn;
    }
    /*BUILD URL AND RELATIONSHIP COLUM*/
    makeUrlRelationshipColumns(configCols, indicator) {
        let targetColumn = {};
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
        this.modalStandard.sobjectType = modalSet.sObjectApiName;
        this.modalStandard.mode = modalSet.mode;
        this.modalStandard.fields = modalSet.fields;
        this.modalStandard.className = modalSet.className;
    }
    handleCloseStanModal(event) {
        this.modalStandard.show = false;
        if(event.detail===true){
            this.sObjectData=[];
            this.callListData();
        }
    }
    /** ROW ACTIONS */
    handleRowActionWeb(event) {
        const row = event.detail.row;
        if (this.isNotEmpty(this.configMeta[0].ModalName__c)) {
            this.handleModal(event.detail.row.Id, true);
        } else {
            this.handleRowAction(row.Id, event.detail.action.name);
        }
    }
    handleRowActionMobile(event) {
        const row = event.detail;
        if (this.isNotEmpty(this.configMeta[0].ModalName__c)) {
            this.handleModal(row.recordId, true);
        } else {
            this.handleRowAction(row.recordId, row.mode);
        }
    }
    handleRowAction(recordId, mode) {
        const customRow = this.customRowActions[mode];
        const modalSet = {
            recordId: recordId,
            mode: mode,
            fields: '',
            className: '',
            sObjectApiName: this.configMeta[0].sObjectApiName__c,
        };
        if (this.isNotEmpty(customRow)) {
            modalSet.title = customRow.title;
            modalSet.fields = (this.isNotEmpty(customRow.fields)) ? customRow.fields : null;
            modalSet.className = customRow.className;
        }
        this.handleOpenStanModal(modalSet);
    }
    /** HEAD ACTIONS */
    handleHeadAction(event) {
        const btnVal = event.target.value;
        const modalSet = {
            recordId: '',
            title: this.BtnConfig.map[btnVal].title[this.lang],
            mode: this.BtnConfig.map[btnVal].mode,
            fields: null,
            sObjectApiName: this.BtnConfig.map[btnVal].sObjectApiName,
            className: this.BtnConfig.map[btnVal].className
        }
        if (this.BtnConfig.map[btnVal].mode === 'insert') {
            let insertFields = new Map;
            for (const field of this.BtnConfig.map[btnVal].fields) {
                insertFields.set(field.fieldName, field);
            }
            insertFields.get(this.BtnConfig.map[btnVal].defaultValue).value = this.recordId;
            modalSet.fields = Array.from(insertFields.values());
        } else {
            modalSet.fields = this.BtnConfig.map[btnVal].fields.split(',');
        }
        this.handleOpenStanModal(modalSet);
    }
    /** CUSTOM MODAL RECORD */
    handleModal(cId, showCmp) {
        this.modalRecord.recordId = cId;
        this.modalRecord.show = showCmp;
        this.modalRecord.metadataName = this.configMeta[0].ModalName__r.DeveloperName;
    }
    handleCloseModal(event) {
        this.modalRecord.show = false;
        refreshApex(this.wiredsObjectList);
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

    setRowActions() {
        let actions = new Map();
        let currentCustomRow = {};
        this.customRowActions = this.isNotEmpty(this.configMeta[0].RowActions__c) ? JSON.parse(this.configMeta[0].RowActions__c) : [];
        if (this.configMeta[0].RowActionView__c) {
            actions.set(1, { label: this.btnView, name: 'view' });
        }
        if (this.configMeta[0].RowActionDelete__c) {
            actions.set(2, { label: this.btnDelete, name: 'delete' });
        }
        for (const key in this.customRowActions) {
            if (this.customRowActions.hasOwnProperty(key)) {
                currentCustomRow = this.customRowActions[key];
                currentCustomRow.label = this.customRowActions[key].label[this.lang];
                currentCustomRow.title = this.customRowActions[key].title[this.lang];
                actions.set(key, currentCustomRow);
            }
        }
        return Array.from(actions.values());
    }
    setHeadActions() {
        let actions = [];
        let currentCustomRow = {};
        for (const headAction of Object.values(this.BtnConfig.map)) {
            currentCustomRow = headAction;
            currentCustomRow.label = headAction.label[this.lang];
            actions.push(currentCustomRow);
        }
        return actions;
    }

}
