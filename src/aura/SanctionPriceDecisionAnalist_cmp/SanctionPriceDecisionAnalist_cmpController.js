({
	close : function(component, event, helper) {
		helper.closeMe(component, event, helper);
	},
	doInit : function(component, event, helper) {
		helper.getInfo(component, event, helper);
	},
	classChange : function(cmp, evt, helper) {
		var inputObj = cmp.get('v.inputAttributes');
        var objSetup = cmp.get('v.objSetup');
		objSetup['btnSelectConfig'] = objSetup['getInfoButtons'].lstButtons[parseInt(evt.target.id)];
		cmp.set('v.objSetup',objSetup);
		cmp.set('v.enableContinue',true);
		var fieldsForm = cmp.find('table');
        var lstFields = [];
        var outputs = fieldsForm.find('outputHTML');
        if(outputs.length != undefined){
            for(var i in outputs){
                var inputObject=outputs[i].get('v.fieldObject');
                if(evt.target.id==0){
                    if(inputObject.label=='Last price quote date' || inputObject.label=='Fecha de sanción'){
                        var today = new Date();
                        var dd = String(today.getDate()).padStart(2, '0');
                        var mm = String(today.getMonth() + 1).padStart(2, '0');
                        var yyyy = today.getFullYear();
                        today = dd + '/' + mm + '/' + yyyy;
                        inputObject.htmlInput=today;
                    }
                    else if(inputObject.label=='validityDate' || inputObject.label=='Validez TEA'){
                        inputObject.htmlInput='';
                    }
                    else if(inputObject.label=='Assigned_analyst' || inputObject.label=='Analista asignado'){
                        inputObject.htmlInput='';
                    }
                }
                else if(evt.target.id==1){
                    if(inputObject.label=='Last price quote date' || inputObject.label=='Fecha de sanción'){
                        var today = new Date();
                        var dd = String(today.getDate()).padStart(2, '0');
                        var mm = String(today.getMonth() + 1).padStart(2, '0');
                        var yyyy = today.getFullYear();
                        today = dd + '/' + mm + '/' + yyyy;
                        inputObject.htmlInput=today;
                    }
                    else if(inputObject.label=='validityDate' || inputObject.label=='Validez TEA'){
                        if(!inputObj.changeDate){
                            inputObject.htmlInput='#validityDate#';
                        }
                        else{
                            var dt = inputObj.validityDate;
                            inputObject.htmlInput = dt.substring(8, 10) + '/' + dt.substring(5, 7) + '/' + dt.substring(0, 4);
                        }
                    }
                }
                else if(evt.target.id==2){
                    if(inputObject.label=='Last price quote date' || inputObject.label=='Fecha de sanción'){
                        inputObject.htmlInput='';
                    }
                    else if(inputObject.label=='validityDate' || inputObject.label=='Validez TEA'){
                        inputObject.htmlInput='';
                    }
                    else if(inputObject.label=='Assigned_analyst' || inputObject.label=='Analista asignado'){
                        inputObject.htmlInput='#Assigned_analyst#';
                    }
                }
                lstFields.push(inputObject);
            }
        }
        fieldsForm.set('v.fieldObject',lstFields);
        cmp.set('v.refreshComp',true);
	},
	doContinue : function(cmp, evt, helper) {
		helper.doContinue(cmp, evt, helper);
	}
})