import { NavigationMixin } from 'lightning/navigation';
/** VALIDATE NOT EMPTY */
const isNotEmpty = (obj) => {
    const notEmpty = (obj === null || obj === undefined || obj === "") ? false : true;
    return notEmpty;
};
/** SET SETTINGS */
const getSettingsObj = (metaData, isViewAll) => {
    const targetFilter = (isViewAll || !isNotEmpty(metaData.NumberRows__c)) ? metaData.Filter__c : metaData.Filter__c + ' LIMIT ' + metaData.NumberRows__c;
    const targetSettings = isNotEmpty(metaData.Settings__c) ? JSON.parse(metaData.Settings__c) : {};
    const sObject = {
        sObjName: metaData.sObjectApiName__c,
        sObjFields: metaData.FieldsQuery__c,
        filterSQOL: targetFilter,
        settings: targetSettings
    };
    return sObject;
}
/** TRANSFORM COLUMS*/
const transformColumns = (columns, lang) => {
    let targetColumns = [];
    if (isNotEmpty(columns)) {
        targetColumns = JSON.parse(columns).values;
        targetColumns.forEach(element => {
            switch (element.type) {
                case "action":
                    element.typeAttributes.rowActions.forEach(element => {
                        element.label = element.label[lang];
                    });
                    break;
                default:
                    break;
            }
        });
    }
    return targetColumns;
}
/** TRANSFORM DATA */
const transformData = (data, columns) => {
    columns.forEach(column => {
        if (column.hasOwnProperty('typeAttributes') && column.typeAttributes.hasOwnProperty('isCustom')) {
            if (column.typeAttributes.isCustom) {
                data.forEach(row => {
                    let rowAux = clone(row);
                    Object.defineProperty(row, "rowData", { value: rowAux, writable: true, enumerable: true, configurable: true });
                });
            }
        }
    });
    return data;
}
/** TRANSFORM HEAD ACTIONS */
const transformHeadActions = (headActions, recordId, lang) => {
    let targetHeadActions;
    if (isNotEmpty(headActions)) {
        targetHeadActions = JSON.parse(headActions).values;
        targetHeadActions.forEach(element => {
            element.label = element.label[lang];
            element.fields.forEach(field => {
                switch (field.value) {
                    case "recordId":
                        field.value = recordId;
                        break;
                    default:
                        break;
                }
            });
        });
    }
    return targetHeadActions;
}
/** SET HEAD ACTIONS */
const setHeadActions = (lang) => {
    let actions = [];
    let currentCustomRow = {};
    for (const headAction of Object.values(this.BtnConfig.map)) {
        currentCustomRow = headAction;
        currentCustomRow.label = headAction.label[lang];
        actions.push(currentCustomRow);
    }
    return actions;
}
/** NOT UI API */
const defaultsValues=(event,recordId)=> {
    const listFields={};
    event.target.value.fields.forEach(fields => {
        if (fields.hasOwnProperty('value')) {
            switch (fields.value) {
                case "recordId":
                    listFields[fields.fieldName] = recordId;
                    break;
                default:
                    listFields[fields.fieldName] = fields.value;
                    break;
            }
        }
    });
    return listFields;
}

const defaultsValuesForm=(defaultValues, recordId, userId, event)=> {
    const listFields={};
    defaultValues.forEach(field => {
        if (field.hasOwnProperty('value')) {
            console.log(field.fieldName);
            if(field.value === 'recordId') {
                listFields[field.fieldName] = recordId;
            } else if(field.value === 'userId') {
                listFields[field.fieldName] = userId;
            } else if(event !== null &&  event.detail.row.hasOwnProperty(field.value)) {
                listFields[field.fieldName] = event.detail.row[field.value];
            } else {
                listFields[field.fieldName] = field.value;
            }
        }
    });
    return listFields;
}

const obtainFields=(params, record)=> {
    var result = {};
    for (const att in params) {
        if(typeof params[att] === 'object' && params[att] !== null) {
            let paramAux = params[att];
            let resultAux = {};
            for(const attAux in paramAux) {
                if (record[paramAux[attAux]]) {
                    resultAux[attAux] = record[paramAux[attAux]];
                } else {
                    resultAux[attAux] = paramAux[attAux];
                }
            }
            result[att] = resultAux;
        } else if (record[params[att]]) {
            result[att] = record[params[att]];
        } else {
            result[att] = params[att];
        }
    }
    return result;
}

function clone ( obj ) {
    if ( obj === null || typeof obj !== 'object' ) return obj;
    var temp = obj.constructor();
    for (var key in obj) temp[key] = clone(obj[key]);
    return temp;
}

export { isNotEmpty, transformColumns, transformHeadActions, transformData, getSettingsObj, defaultsValues, defaultsValuesForm, obtainFields};
