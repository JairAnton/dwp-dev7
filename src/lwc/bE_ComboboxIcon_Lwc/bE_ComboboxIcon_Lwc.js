import { LightningElement, api } from 'lwc';

export default class BE_ComboboxIcon_Lwc extends LightningElement {
    @api options;
    @api label;
    @api variant;
    @api placeholder;
    @api displayFormat;
    @api value;

    get selectedOption() {
        let selectedOption;
        let selected = this.options.filter(
            (option) => option.value === this.value
        );
        if (selected.length > 0) {
            selectedOption = selected[0];
        } else {
            selectedOption = { label: '', value: '' };
        }
        return selectedOption;
    }

    handleClick(event) {
        this.value = event.currentTarget.dataset.value;
        this.dispatchEvent(new CustomEvent('change', {
            detail: {
                value: event.currentTarget.dataset.value,
            }
        }));
        this.template.querySelector('input').blur();
    }

    renderedCallback() {
        if (this.variant === 'label-hidden') {
            this.template.querySelector('label').classList.add('slds-assistive-text');
        }
        this.resetCSS();
        if (!this.selectedOption.iconName || this.displayFormat === 'text') {
            this.template.querySelector('lightning-icon').classList.add('slds-hide');
            this.template.querySelector('div.slds-input-has-icon').classList.add('slds-input-has-icon_right');
        }
        else if (this.displayFormat === 'icon') {
            this.template.querySelector('input').classList.add('multi-entity_input');
            this.template.querySelector('div.slds-input-has-icon').classList.add('slds-input-has-icon_left-right');
        }
        else {
            this.template.querySelector('div.slds-input-has-icon').classList.add('slds-input-has-icon_left-right');
        }
    }

    resetCSS() {
        this.template.querySelector('input').classList.remove('multi-entity_input');
        this.template.querySelector('div.slds-input-has-icon').classList.remove('slds-input-has-icon_left-right');
        this.template.querySelector('div.slds-input-has-icon').classList.remove('slds-input-has-icon_right');
        this.template.querySelector('lightning-icon').classList.remove('slds-hide');
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
