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
                    Object.defineProperty(row, "rowData", { value: row, writable: true, enumerable: true, configurable: true });
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
export { isNotEmpty, transformColumns, transformHeadActions, transformData, getSettingsObj };