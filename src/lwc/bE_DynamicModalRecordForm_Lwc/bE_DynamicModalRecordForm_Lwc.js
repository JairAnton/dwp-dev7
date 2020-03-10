import { LightningElement, api} from 'lwc';
import getInfo from "@salesforce/apex/BE_DynamicModalRecordForm_ctr.getInfo";
import getHeader from "@salesforce/apex/BE_DynamicModalRecordForm_ctr.getHeader";
import deletesobject from "@salesforce/apex/BE_DynamicModalRecordForm_ctr.deletesobject";
import templateInit from './bE_DynamicModalRecordForm_Lwc.html';
import templateForm from './bE_DynamicRecordFormDisabled_Lwc.html';
import templateDelete from './bE_DeleteRecord_Lwc.html';
import templateMobile from './bE_DynamicRecordFormDisabledMobile_Lwc.html';
import msgError from '@salesforce/label/c.Dwp_msgGenericError'
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';

export default class BE_DynamicModalRecordForm_Lwc extends NavigationMixin(LightningElement) {
    label = {msgError};
    enabledTempInit = templateInit;
    //Config
    @api isMobile = false;
    @api checkMobile = false;
    @api idRecord;
    @api metaDataConfig;
    @api header;
    //Markup
    @api structure = [];
    //@api records;
    @api recordsInPage;
    @api spinner;
    @api loadDetails;
    @api noRecordsFound;
    //variables
    @api selectedRecord;
    @api indexStructure = 0;
    @api totalPages = 0;

    connectedCallback() {
        this.isMobile = (FORM_FACTOR === 'Small' || FORM_FACTOR === 'Medium') ? true : false;
        if(this.isMobile && !this.checkMobile) {
            this.handleMobileCmp();
        } else {
            this.getHeaderModal();
        }
    }

    getHeaderModal() {
        this.spinner = false;
        getHeader({config : this.metaDataConfig})
        .then((response) => {
            if(response.isSuccess) {
                this.header = response.header;
                let template = (this.checkMobile) ? "templateMobile" : "templateForm";
                this.switchTemplate(template);
                this.getConfig();
            } else {
                console.log(result.message);
                this.showToast('Error', response.message, 'Error');
                this.handleCloseModal();
            }
        })
        .catch((error) => {
            console.log(error);
            this.showToast('Error', msgError, 'Error');
            this.handleCloseModal();
        });
    }

    render() {
        return this.enabledTempInit;
    }

    switchTemplate(template) {
        let temp;
        switch(template) {
            case "templateForm":
                temp = templateForm;
                break;
            case "templateDelete":
                temp = templateDelete;
                break;
            case "templateMobile":
                temp = templateMobile;
                break;
            default:
                temp = templateInit;
        }
        this.enabledTempInit = temp;
    }

    getConfig() {
        getInfo({recordId: this.idRecord, config: this.metaDataConfig})
        .then((result)=> {
            if (result.isSuccess) {
                if(result.data.length === 0 || result.data === undefined) {
                    this.noRecordsFound = true;
                    this.loadDetails = false;
                    this.spinner = true;
                } else {
                    this.noRecordsFound = false;
                    let resultado = {'result': JSON.parse(JSON.stringify(result.result)), 'data': JSON.parse(JSON.stringify(result.data))};
                    if(this.checkMobile) {
                        this.structureForMobile(resultado);
                    } else {
                        this.convertStructure(resultado);
                    }
                }
            } else {
                console.log(result.message);
                this.showToast('Error', result.message, 'Error');
                this.handleCloseModal();
            }
        })
        .catch((error) => {
            console.log(error);
            this.showToast('Error', msgError, 'Error');
            this.handleCloseModal();
        })
    }

    structureForMobile(resultado) {
        let str = [];
        for(let i = 0; i < resultado.result.length; i++) {
            let rows = [];
            for(let j = 0; j < resultado.result[i].length; j++) {
                for(let k = 0; k < resultado.result[i][j].fields.length; k++) {
                    let field = this.getFieldsStructure(resultado, i, j, k);
                    field.fieldWidth = 12;
                    field.order = 1;
                    let row = {fields : [field], order : k, uniqueId : 'Row_'+i+'_'+k};
                    rows.push(row);
                }
            }
            resultado.result[i] = rows;
            str.push({'Id' : 'record_'+i, 'record':resultado.result[i]});
        }
        this.convertionConfigs(str);
    }

    convertStructure(resultado) {
        let str = [];
        for(let i = 0; i < resultado.result.length; i++) {
            for(let j = 0; j < resultado.result[i].length; j++) {
                for(let k = 0; k < resultado.result[i][j].fields.length; k++) {
                    resultado.result[i][j].fields[k] = this.getFieldsStructure(resultado, i, j, k);
                }
            }
            str.push({'Id' : 'record_'+i, 'record':resultado.result[i]});
        }
        this.convertionConfigs(str);
    }

    convertionConfigs(str) {
        this.structure = [];
        this.recordsInPage = str;
        this.totalPages = 0;
        this.createpages(str);
        this.loadDetails = true;
        this.spinner = true;
    }

    getFieldsStructure (resultado, i, j, k) {
        for(let d = 0; d < resultado.data.length; d++) {
            let fieldName = resultado.result[i][j].fields[k].fieldName;
            if(resultado.result[i][j].fields[k].dataType === 'reference' && resultado.result[i][j].fields[k].value === resultado.data[d][fieldName]) {
                if(fieldName.endsWith('Id')) {
                    resultado.result[i][j].fields[k].value = resultado.data[d][fieldName.slice(0, -2)].Name;
                } else if(fieldName.endsWith('__c')){
                    resultado.result[i][j].fields[k].value = resultado.data[d][fieldName.slice(0, -1)+'r'].Name;
                }
            }
        }
        return resultado.result[i][j].fields[k];
    }

    createpages(str) {
        let arrayRecords = [];
        if((this.header.Records_per_page__c !== null || this.header.Records_per_page__c !== undefined) &&
            str.length > this.header.Records_per_page__c) {
            for(let i=0; i < str.length; i++) {
                arrayRecords.push(str[i]);
                if(arrayRecords.length === this.header.Records_per_page__c || str.length === (i+1)) {
                    this.structure.push(arrayRecords);
                    this.totalPages += 1;
                    arrayRecords = [];
                }
            }
            this.recordsInPage = this.structure[this.indexStructure];
            let buttonL = this.template.querySelector(`[data-id="left"]`);
            let buttonR = this.template.querySelector(`[data-id="right"]`);
            buttonL.disabled = this.indexStructure === 0 ? true : false;
            buttonR.disabled = (this.indexStructure + 1) === this.totalPages ? true : false;
            buttonL.classList.remove('arrowsButton');
            buttonR.classList.remove('arrowsButton');
        }
    }

    redirect(event) {
        let direction = event.target.value;
        let buttonL = this.template.querySelector(`[data-id="left"]`);
        let buttonR = this.template.querySelector(`[data-id="right"]`);
        if(direction === 'left' && this.indexStructure > 0) {
            this.indexStructure -= 1;
            this.recordsInPage = this.structure[this.indexStructure];
            buttonL.disabled = this.indexStructure === 0 ? true : false;
            buttonR.disabled = false;
        } else if(direction === 'right' && this.indexStructure < this.totalPages) {
            this.indexStructure += 1;
            this.recordsInPage = this.structure[this.indexStructure];
            buttonR.disabled = (this.indexStructure + 1) === this.totalPages ? true : false;
            buttonL.disabled = false;
        }
    }

    get editMode() {
        return this.header.view_mode__c === '02' ? true : false;
    }

    get deleteMode() {
        return this.header.delete_mode__c;
    }

    get mode() {
        return this.deleteMode || this.editMode;
    }

    get pagination() {
        return this.totalPages === 0 ? false : true;
    }

    get pagina() {
        return this.indexStructure + 1;
    }

    recordToDelete(event) {
        this.selectedRecord = event.target.value;
        this.switchTemplate("templateDelete");
    }

    deleteRecord() {
        this.spinner = false;
        this.loadDetails = false;
        this.noRecordsFound = false;
        deletesobject({ recordId: this.selectedRecord, config : this.metaDataConfig})
        .then((response) => {
            if(response.isSuccess) {
                this.showToast('Success', 'Se ha eliminado el registro exitosamente.', 'Success');
                this.indexStructure = 0;
                this.getHeaderModal();
            } else {
                this.spinner = true;
                this.loadDetails = true;
                this.showToast('Error', response.message, 'Error');
            }
        })
        .catch((error) => {
            this.spinner = true;
            this.loadDetails = true;
            console.log(error);
            this.showToast('Error', msgError, 'Error');
        });
    }

    handleMobileCmp() {
        let sObject = {
            idRecord: this.idRecord,
            metaData: this.metaDataConfig,
            checkMobile: true
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__BE_DynamicModalRecordFormMobile_Cmp',
            },
            state:{
                c__sObject: sObject
            }
        });
    }
    handleCloseModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    showToast(title, message, type) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant : type
        });
        this.dispatchEvent(event);
    }
}