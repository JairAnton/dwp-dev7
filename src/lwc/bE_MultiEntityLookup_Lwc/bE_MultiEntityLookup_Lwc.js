import { LightningElement, api, track } from 'lwc';

export default class BE_MultiEntityLookup_Lwc extends LightningElement {
    _defaultEntityConfig = {};

    @track selectedEntity;
    @track entityOptions;
    @track entityConfig;

    @api readOnly = false;
    @api multiEntity = false;
    @api recordId;
    @api entities;
    @api labelName;
    @api fieldName;
    @api searchPlaceholder = '';
    @api isRequired = false;
    @api isDisabled = false;
    @api objectName;

    get showCombobox() {
        return this.multiEntity && !this.recordId;
    }

    connectedCallback() {
        let options = [];
        if(this.objectName !== null && this.objectName !== undefined) {
            this.selectedEntity = this.objectName;
        } else {
            this.selectedEntity = this.entities[0].objName;
        }
        this._defaultEntityConfig.searchEntities = this.entities;
        this.entityConfig = this._defaultEntityConfig;
        this.entities.forEach(entity => {
            options.push({ label: entity.label, value: entity.objName, iconName: entity.iconName });
            if(this.selectedEntity === entity.objName) {
                this.entityConfig.objName = entity.objName;
                this.entityConfig.iconName = entity.iconName;
                this.entityConfig.label = entity.label;
                this.entityConfig.displayFields = entity.displayFields;
                this.entityConfig.displayFormat = entity.displayFormat;
                this.entityConfig.pluralLabel = entity.pluralLabel;
            }
        });
        this.entityOptions = options;
    }

    selectEntity() {
        let selected = this.entities.filter(
            (entity) => entity.objName === this.selectedEntity
        );

        this.entityConfig = selected[0];
    }

    handleEntityChange(event) {
        this.selectedEntity = event.detail.value;
        this.selectEntity();
    }

    handleChange(event) {
        this.recordId = event.detail.recordId;
        this.selectedEntity = event.detail.selectedEntity;
        const valueSelectedEvent = new CustomEvent('lookupselected', { detail: { value: this.recordId, target: this.fieldName } });
        this.dispatchEvent(valueSelectedEvent);
        this.selectEntity();
    }
}
