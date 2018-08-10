({
	doDeleteRecords : function(cmp, evt, helper){
		var tableCustom = (cmp.find('tableCustom')[0]==undefined?cmp.find('tableCustom'):cmp.find('tableCustom')[0]);
		var dataTable = tableCustom.find('dataTable');
		if(dataTable != undefined){
			var lstSelect = dataTable.getSelectedRows();
			if(lstSelect.length>0){
				var lstIds = cmp.get('v.lstDataDelete');
				
				for(var i in lstSelect){
					lstIds.push(lstSelect[i].recordId); 
				}
				var lstDataCustom = cmp.get('v.lstDataCustom');
				var lstDataCustomDelete = [];
				
				for(var i in lstDataCustom){
					if(!lstIds.includes(lstDataCustom[i].recordId)){
						lstDataCustomDelete.push(lstDataCustom[i]);
					}
				}
				cmp.set('v.lstDataDelete',lstIds);
				cmp.set('v.lstDataCustom', lstDataCustomDelete);
				cmp.set('v.step','0');
				cmp.set('v.step','1');
			}
		}
	},
	saveAll : function(cmp, evt, helper){
		var lstNew = [];
		var lstDelete = cmp.get('v.lstDataDelete');
		var lstCustom = cmp.get('v.lstDataCustom');
		for(var i in lstCustom){
			if(lstCustom[i].type!=undefined && lstCustom[i].type=='new'){
				lstNew.push(lstCustom[i].assistantId);
			}
		}
		
		var action = cmp.get("c.saveAll");
		// set param to method 
		action.setParams({
			'recordId': cmp.get('v.inputAttributes.recordId'),
			'lstNewAssistant': lstNew,
			'lstDeleteAssistant' :  lstDelete
		});
		// set a callBack    
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var ret = response.getReturnValue();
				if(ret.isOk){
					$A.get('e.force:refreshView').fire();
					var cancelEvent = cmp.getEvent('dynamicFlowWizardCancel');
    				cancelEvent.fire();
				}
				
			}
			
		});
		// enqueue the Action  
		$A.enqueueAction(action);
	},
	getData : function(cmp) {
		var action = cmp.get('c.getInfo');
		action.setParams({
            recordId : cmp.get('v.inputAttributes.recordId')
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var ret = response.getReturnValue();
				cmp.set('v.lstDataCustom', JSON.parse(ret.info));
			}
			cmp.set('v.isLoad',true);
        }));
        $A.enqueueAction(action);
	},
	closeMe : function(component, event) {
        var cancelEvent = component.getEvent('dynamicFlowWizardCancel');
    	cancelEvent.fire();
    }
})