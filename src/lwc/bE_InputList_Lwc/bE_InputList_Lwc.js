import { LightningElement, api } from 'lwc';

export default class BE_InputList_Lwc extends LightningElement {
    @api options;
    @api labelName = '';
    @api fieldName = '';
    @api defaultValue = '';
    @api isRequired;
    @api isDisabled;
    @api placeholder = '';
    initialized = false;

    renderedCallback() {
        if (this.initialized) {
            return;
        }
        this.initialized = true;
        let listId = this.template.querySelector('datalist').id;
        this.template.querySelector("input").setAttribute("list", listId);
    }

    handleChange(evt) {
        this.defaultValue = evt.target.value;
        let selectedValue = evt.target.value;
        for (const key in this.options) {
            if(this.options[key].label === evt.target.value) {
                selectedValue = this.options[key].value;
                break;
            }
        }
        this.dispatchEvent(new CustomEvent('change', { bubbles: false, detail: { value: selectedValue, target: this.fieldName } }));
    }
}
