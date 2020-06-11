import { LightningElement, api } from 'lwc';
import getFilters from "@salesforce/apex/Be_DynamicTablePresentation_ctr.getFilters";
import getValues from "@salesforce/apex/Be_DynamicTablePresentation_ctr.getValues";
import FORM_FACTOR from '@salesforce/client/formFactor';
import { NavigationMixin } from 'lightning/navigation';

export default class BE_DynamicTablePresentation_Lwc extends NavigationMixin(LightningElement) {
    @api metadataConfig; /** Dev name of metadata*/
    @api titleCard;
    @api title;
    @api iconName;
    @api columns;
    @api values;
    @api loadView;
    @api mode = {isBasic: false, isTitle: false, isTitleMedium: false, isTitleLarge:false};
    @api valuesTitle;
    @api flexipageRegionWidth;
    @api isMobile;
    @api tableModel;
    @api noneData;
    @api handleError;
    @api selectedfilter;
    @api filters = [];
    @api viewAll;
    @api tableModelAll;
    @api recordsToShow;
    @api spinner;

    connectedCallback() {
        this.isMobile = (FORM_FACTOR === 'Small' || FORM_FACTOR === 'Medium') ? true : false;
        this.getActions();
        this.modelMode();
    }

    getData() {
        this.spinner = true;
        getValues({config : this.metadataConfig, mode : this.tableModel, filter: this.selectedfilter})
            .then((response) => {
                if(response.isSuccess) {
                    this.noneData = response.data === null || response.data.length < 1;
                    let totalRecords = this.noneData ? 0 : response.data.length;
                    this.title = this.titleCard + ' ('+totalRecords+')';
                    this.columns = JSON.parse(response.columns);
                    console.log('this.columns => '+JSON.stringify(this.columns));
                    this.columns = this.columns[this.selectedfilter];
                    this.values = response.data;
                    this.recordsToShow = (this.recordsToShow === null || this.recordsToShow === undefined ? 6 : this.recordsToShow);
                    if(!this.viewAll && this.values.length > this.recordsToShow) {
                        let limitRecords = [];
                        for(let i = 0; i < this.recordsToShow; i++) {
                            limitRecords.push(this.values[i]);
                        }
                        this.values = limitRecords;
                    }
                    this.loadView = true;
                } else {
                    console.log(JSON.stringify(response.message));
                    this.handleError = true;
                }
                this.spinner = false;
            })
            .catch((error) => {
                console.log(error);
                this.handleError = true;
                this.spinner = false;
            })
    }

    getActions() {
        getFilters({config : this.metadataConfig})
            .then((response) => {
                if(response !== 'empty') {
                    this.filters = JSON.parse(response);
                    if(this.selectedfilter === null || this.selectedfilter === undefined) {
                        this.getSelectedFilter();
                    }
                }
                console.log('this.selectedfilter => '+this.selectedfilter);
                this.getData();
            })
            .catch((error) => {
                console.log(error);
                this.spinner = false;
                this.handleError = true;
            })
    }

    getSelectedFilter() {
        for(let i = 0; i < this.filters.length; i++) {
            if(this.filters[i].default !== undefined && this.filters[i].default !== null) {
                this.selectedfilter = this.filters[i].code;
                break;
            }
        }
    }

    refreshTable() {
        this.getData();
    }

    modelMode() {
        if(this.viewAll && (this.tableModelAll !== null && this.tableModelAll !== undefined)) {
            this.getModel(this.tableModelAll);
        } else {
            this.getModel(this.tableModel);
        }
    }

    getModel(model) {
        switch (model) {
            case 'Basic':  this.mode.isBasic = true;
            break;
            case 'Title':  this.mode.isTitle = true;
            break;
            case 'Title Medium':  this.mode.isTitleMedium = true;
            break;
            case 'Title Large':  this.mode.isTitleLarge = true;
            break;
            default: this.mode.isBasic = true;
            break;
        }
    }

    get hasFilters() {
        return this.filters !== null && this.filters.length > 0;
    }

    onRowAction(event) {
        this.selectedfilter = event.target.value;
        this.getData();
    }

    redirectViewAll() {
        let sObjectType, idLV;
        for(let i = 0; i < this.filters.length; i++) {
            if(this.filters[i].code === this.selectedfilter) {
                idLV = this.filters[i].id;
                sObjectType = this.filters[i].sobjectType;
                break;
            }
        }
        if(sObjectType !== null && sObjectType !== undefined && idLV !== null && idLV !== undefined) {
            this.standardListView(sObjectType, idLV);
        } else {
            this.customListView();
        }
    }

    customListView() {
        var sObject = {
            metadataConfig: this.metadataConfig,
            tableModel: this.tableModel,
            selectedfilter: this.selectedfilter,
            viewAll: true,
            tableModelAll: this.tableModelAll,
            titleCard: this.titleCard,
            iconName: this.iconName
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__BE_DynamicTablePresentation_cmp'
            },
            state: {
                c__sObject: sObject
            }
        });
    }

    standardListView(sObjectType, idLV) {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: sObjectType,
                actionName: 'list'
            },
            state: {
                filterName: idLV
            }
        });
    }

}