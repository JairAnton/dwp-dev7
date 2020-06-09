import LightningDatatable from 'lightning/datatable';
import lookupLayout from './bE_CustomDataTypeLookup_Lwc.html';
import urlLayout from './bE_CustomDataTypeUrl_Lwc.html';
import buttonLayout from './bE_CustomDataTypeButton_Lwc.html';
export default class bE_CustomDataTable_Lwc extends LightningDatatable {
    static customTypes = {
        customlookup: {
            template: lookupLayout,
            standardCellLayout: true,
            typeAttributes: ['label', 'fieldName', 'objectApiName', 'rowData'],
        },
        customurl: {
            template: urlLayout,
            standardCellLayout: true,
            typeAttributes: ['label', 'fieldName', "rowData"]
        },
        custombutton: {
            template: buttonLayout,
            standardCellLayout: true,
            typeAttributes: ['label', 'fieldName',"iconName","variant","iconPosition","modalName", "rowData"]
        },
        //more custom types here
    };
}