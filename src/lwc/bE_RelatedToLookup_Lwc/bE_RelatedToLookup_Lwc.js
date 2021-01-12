import { LightningElement, api, wire, track } from 'lwc';
import lookUpById from '@salesforce/apex/BE_NotUIAPIForm_Ctr.lookUpById';
import findRelatedToLookup from '@salesforce/apex/BE_NotUIAPIForm_Ctr.findRelatedToLookup';

export default class BE_RelatedToLookup_Lwc extends LightningElement {
    searchTerm;
    filters;
    createRecord;

    objName;
    displayFields;
    index;

    @track records;
    @track hasRecord;
    @track record;

    @api isDisabled = false;
    @api recordId;
    @api
    get config() {
        return this._config;
    }
    set config(entity) {
        this._config = entity;
        if (this.recordId) {
            this.objName = entity.objName;
            this.displayFields = entity.displayFields;
        }
        this.filters = this.setObjFilters(entity);
        this.label = entity.label;
        this.createRecord = entity.createRecord;
    }

    get placeholder() {
        return 'Search ...';
    }

    setObjFilters(entity) {
        let filterQuery = entity.objName;
        let endQuery = '';
        if (entity.displayFields) {
            filterQuery += ' (' + entity.displayFields;
            endQuery = ')'
        }
        if (entity.filters) {
            filterQuery += ' WHERE ' + entity.filters;
            endQuery = ')';
        }
        filterQuery += endQuery;
        return filterQuery;
    }

    @wire(findRelatedToLookup, { searchTerm: '$searchTerm', filters: '$filters' })
    searchRecords({ error, data }) {
        this.records = [];
        if (data) {
            for (let i = 0; i < data.length; i++) {
                let records = data[i];
                records.forEach(record => {
                    this.records.push(this.getRecord(record, i));
                });
            }
        } else if (error) {
            this.error = error;
        }
    }

    connectedCallback() {
        if (this.recordId) {
            lookUpById( {recordId : this.recordId, objName : this.objName, fields : this.displayFields} )
            .then(result => {
                this.record = this.getRecord(result, this.index);
                this.hasRecord = true;
            })
            .catch(error => {
                this.error = error;
                console.log(error);
            });
        }
    }

    getRecord(record, i) {
        let option = { ...record };
        let entity = this._config;
        option.display = this.generateLabel(option, entity);
        option.iconName = entity.iconName;
        option.label = entity.label;
        option.objName = entity.objName;
        option.displayFields = entity.displayFields;
        option.index = i;
        return option;
    }

    generateLabel(record, entity) {
        let label = entity.displayFormat;
        let splitFields = entity.displayFields.split(',');
        splitFields.forEach(field => {
            field = field.trim();
            let value;
            //logic to handle relationhships in queries
            if (field.indexOf('.') > -1) {
                let splitRelations = field.split('.');
                splitRelations.forEach(item => {
                    value = (value ? value[item] : record[item]);
                });
            } else {
                value = record[field];
            }
            value = value ? value : '';
            label = label.replace(field, value);
        });
        return label;
    }

    handleClick(event) {
        this.recordId = event.currentTarget.dataset.id;
        this.searchTerm = null;
        let selected = this.records.filter(
            (option) => option.Id === this.recordId
        );
        this.dispatchEvent(new CustomEvent('change', {
            detail: {
                recordId: event.currentTarget.dataset.id,
                selectedEntity: this._config.objName
            }
        }));
        this.record = selected[0];
        this.hasRecord = true;
        this.template.querySelector('input').blur();
    }

    handleRemovePill() {
        if(!this.isDisabled) {
            this.recordId = null;
            this.hasRecord = false;
            this.dispatchEvent(new CustomEvent('change', {
                detail: {
                    recordId: '',
                    selectedEntity: this._config.objName
                }
            }));
        }
    }

    handleChange(event) {
        this.searchTerm = event.target.value;
    }

    handleFocus() {
        this.template.querySelector('div.slds-combobox').classList.add('slds-is-open');
    }

    handleBlur() {
        this.template.querySelector('div.slds-combobox').classList.remove('slds-is-open');
    }

    handleMousedown(event) {
        event.preventDefault();
    }
}
