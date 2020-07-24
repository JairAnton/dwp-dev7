import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import title from '@salesforce/label/c.BE_ImportRecord_Title';
import description from '@salesforce/label/c.BE_ImportRecord_Desc';
import btnLabel from '@salesforce/label/c.BE_ImportRecord_btn_label';

export default class BE_Redirect_ImportWizard_Lwc extends NavigationMixin(LightningElement) {

    label = {
        title,
        description,
        btnLabel
    };

    redirectIDW() {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/settings/personal/DataImporter/home'
            }
        }, true);
    }
}