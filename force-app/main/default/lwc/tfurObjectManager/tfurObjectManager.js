import { LightningElement, api } from 'lwc';

export default class TfurObjectManager extends LightningElement {
    @api allowMultiselect;
    @api showFieldSelector;
    @api label;
    @api objectValue;
    @api fieldValue;

    handleObjectChange(event) {
        this.objectValue = event.detail.value;
    }

    handleFieldChange(event) {
        this.fieldValue = event.detail.value;
    }

    @api
    validate() {
        let errorMessages = []
        const validateComponents = [this.template.querySelector('c-fsc_object-selector'), this.template.querySelector('c-fsc_field-selector2')];
        validateComponents.forEach(cmp => {
            if (cmp?.validate().errorMessage) {
                errorMessages.push(cmp.validate().errorMessage)
            }
        })
        console.log('in ofsValidate, errorMessages = ' + errorMessages);
        if (errorMessages.length) {
            return {
                isValid: false,
                errorMessage: errorMessages.join(' ')
            };
        } else {
            return { isValid: true };
        }
    }

}