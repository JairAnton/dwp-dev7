import { LightningElement, api } from 'lwc';
export default class BE_CustomDataTypeCurrency_Lwc extends LightningElement {
    @api value;
    @api currencyCode;
    @api displayAs;
    @api maxFractionDigits;
}
