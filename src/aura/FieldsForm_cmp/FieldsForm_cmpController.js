({
	saveSuccess : function(cmp, evt, helper) {
		evt.preventDefault();
	},
	ok : function(cmp, evt, helper) {
		var a = cmp.find('form');
		a.submit();
	},
	doInit : function(cmp, evt, helper){
		helper.getInfo(cmp, evt, helper);
	},
	changeValue : function(cmp, evt, helper){
	},
	doValidateSave : function(cmp, evt, helper){
        var inputs = cmp.find('input');
		var isOk = true;
		var lstApiField = [];
		var lstvalueField = []; 
        for(var i in inputs){
            if(inputs[i].find('inputField') !== undefined){
				lstApiField.push(inputs[i].get('v.fieldObject').ApiName);
				lstvalueField.push(inputs[i].get('v.fieldObject').value);
                inputs[i].find('inputField').reportValidity();
                if(!inputs[i].find('inputField').checkValidity()){
                    isOk = false;
                }
            }
        }
		if(isOk){
			helper.doSave(cmp,evt,helper,lstApiField,lstvalueField);
		}
		return isOk;
	}
})
