({
	close : function(component, event, helper) {
		helper.closeMe(component, event, helper);
	},
	doInit : function(component, event, helper) {
		helper.getInfo(component, event, helper);
	},
	classChange : function(cmp, evt, helper) {
		var objSetup = cmp.get('v.objSetup');
		objSetup['btnSelectConfig'] = objSetup['getInfoButtons'].lstButtons[parseInt(evt.target.id)];
		cmp.set('v.objSetup',objSetup);
		cmp.set('v.enableContinue',true);
		var fieldsForm = cmp.find('table');
        var lstFields = [];
        var outputs = fieldsForm.find('outputHTML');
        if(outputs.length !== undefined) {
            for(var i in outputs) {
                var inputObject = outputs[i].get('v.fieldObject');
                var today = new Date();
                var originalHtml = inputObject.htmlInput;
                inputObject.htmlInput = '';
                if((inputObject.label==='Last price quote date' || inputObject.label==='Fecha de sanción') && (evt.target.id!==2)) {
                    inputObject.htmlInput = String(today.getDate()).padStart(2, '0') + '/' + String(today.getMonth() + 1).padStart(2, '0') + '/' + today.getFullYear();
                } else if((inputObject.label==='validityDate' || inputObject.label==='Validez TEA') && (evt.target.id===1)) {
                    inputObject.htmlInput = '#validityDate#';
                    if(inputObj.changeDate) {
                        var dt = inputObj.validityDate;
                        inputObject.htmlInput = dt.substring(8, 10) + '/' + dt.substring(5, 7) + '/' + dt.substring(0, 4);
                    }
                } else if((inputObject.label==='Assigned_analyst' || inputObject.label==='Analista asignado') && (evt.target.id!==0)) {
                    if(evt.target.id===1) {
                        inputObject.htmlInput = '#Assigned_analyst#';
                    } else{
                        inputObject.htmlInput = originalHtml;
                    }
                }
            }
        }
        fieldsForm.set('v.fieldObject',lstFields);
        cmp.set('v.refreshComp',true);
	},
	doContinue : function(cmp, evt, helper) {
		helper.doContinue(cmp, evt, helper);
	},
})