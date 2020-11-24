import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class BE_CustomDataTypeButton_Lwc extends NavigationMixin(LightningElement) {
    @api buttonData;
    @track show = false;
    urlValue;
    urlLabel;

    handleCloseModal() {
        this.show = false;
    }

    handleClick() {
        var initialParams = JSON.parse( JSON.stringify( this.buttonData.params ) );
        var params = {};
        for (const att in this.buttonData.params) {
            if (this.buttonData.rowData[this.buttonData.params[att]]) {
                params[att] = this.buttonData.rowData[this.buttonData.params[att]];
            } else {
                params[att] = this.buttonData.params[att];
            }
        }
        console.log('PARAMETROS DOCUMENTO');
        console.log(JSON.stringify(params));
        if(this.buttonData.component === 'filePreview') {
            if(params['fileId'] !== initialParams['fileId']) this.openPreview(params['fileId']);
            console.log(params['fileId']);
        } else {
            const dynamicCMP = new CustomEvent('customtypebutton', {composed: true, bubbles: true, cancelable: true,
                                                detail: { "component": this.buttonData.component, "params": params}
                                            });
            this.dispatchEvent(dynamicCMP);
        }
    }

    clone(obj) {
        var temp = obj.constructor();
        for ( var key in obj ) temp[ key ] = clone( obj[ key ] );
        return temp;
    }

    openPreview(fileId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'filePreview'
            },
            state: {
                selectedRecordId: fileId
            }
        });
    }
}