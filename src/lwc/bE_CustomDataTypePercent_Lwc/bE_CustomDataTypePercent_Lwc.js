import { LightningElement, api } from 'lwc';
export default class BE_CustomDataTypePercent_Lwc extends LightningElement {
    @api value;
    @api maxFractionDigits;
}