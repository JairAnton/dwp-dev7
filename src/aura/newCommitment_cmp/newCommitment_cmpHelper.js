({
	getInfo : function(cmp, evt, helper) {
		var approvalMethod = cmp.get('v.approvalMethod');
        var action = cmp.get("c.getInfo");
        action.setParams({
            "quoteType" : approvalMethod
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var ret = response.getReturnValue();
				var lstCommitments = ret.lstCommitments;
				var objSetup = {
								'valPicklistProd':[], 
								'lstPick2':[], 
								'lstValExp':[],
								'mapPosPicklistProd':{},
								'mapPosPicklist2':[{}],
								'mapPoslstValExp':[{}],
								'schemaSetup': ret.schemaSetup
							};
				var posPick = 0;
				var posPick2 = 0;
				//var posValExp = 0;
				for(var i in lstCommitments){
					if(!objSetup['valPicklistProd'].includes(lstCommitments[i].commitment_product_name__c)){
						if(i!=0){
							posPick++;
							posPick2=0;
							//posValExp=0;
							objSetup['mapPosPicklist2'][posPick] = {};
							//objSetup['mapPoslstValExp'][posPick] = {};
						}
						objSetup['mapPosPicklistProd'][lstCommitments[i].commitment_product_name__c] = posPick;
						objSetup['valPicklistProd'].push(lstCommitments[i].commitment_product_name__c);
						objSetup['lstPick2'][posPick] = [lstCommitments[i].CurrencyIsoCode];
						objSetup['lstValExp'][posPick] = [lstCommitments[i].commitment_expiry_days_number__c];
						
						
					}else{
						objSetup['lstPick2'][posPick].push(lstCommitments[i].CurrencyIsoCode);
						objSetup['lstValExp'][posPick].push(lstCommitments[i].commitment_expiry_days_number__c);
					}

					objSetup['mapPosPicklist2'][posPick][lstCommitments[i].CurrencyIsoCode] = posPick2;
					//objSetup['mapPoslstValExp'][posPick][lstCommitments[i].commitment_expiry_days_number__c] = posValExp;
					posPick2++;
					//posValExp++;
					
				}
				objSetup['lstVal1']=objSetup['valPicklistProd'];
				objSetup['lstVal2']=[];
				objSetup['valExp']='';
				objSetup['lstVal1value']='-';
				objSetup['lstVal2value']='-';
				objSetup['valExpvalue']='';
				objSetup['valImport']='';
				objSetup['valPer']='';
				cmp.set('v.objSetup', objSetup);
            }
        }); 
        $A.enqueueAction(action);
	},
	changeProduct : function(cmp, evt, helper) {
		var objSetup = cmp.get('v.objSetup');
		
		objSetup['lstVal2value']='-';
		objSetup['valExpvalue']='';
		objSetup['lstVal2'] = (objSetup.lstPick2[objSetup.mapPosPicklistProd[objSetup.lstVal1value]]==undefined?[]:objSetup.lstPick2[objSetup.mapPosPicklistProd[objSetup.lstVal1value]]);
		cmp.set('v.objSetup', objSetup);
	},
	changeDivisa : function(cmp, evt, helper) {
		var objSetup = cmp.get('v.objSetup');
		
		objSetup['valExpvalue']='';
		objSetup['valExpvalue'] = (objSetup.lstValExp[objSetup.mapPosPicklistProd[objSetup.lstVal1value]][objSetup.mapPosPicklist2[objSetup.mapPosPicklistProd[objSetup.lstVal1value]][objSetup.lstVal2value]]==undefined?'':objSetup.lstValExp[objSetup.mapPosPicklistProd[objSetup.lstVal1value]][objSetup.mapPosPicklist2[objSetup.mapPosPicklistProd[objSetup.lstVal1value]][objSetup.lstVal2value]]);
		cmp.set('v.objSetup', objSetup);
	},
	saveCommitment : function(cmp, evt, helper){
		var isOk = true;
		var fields = cmp.find('field');
		var lstData = [];
		var allValid = cmp.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            for(var i in fields){
				lstData.push(fields[i].get('v.value'));
			}
	
			var action = cmp.get("c.saveCommitment");
			action.setParams({
				"recordId" : cmp.get('v.oppRecordId'),
				"lstData":lstData
			});
			action.setCallback(this, function(response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var ret = response.getReturnValue();
					helper.doBack(cmp, evt, helper);
				}
			}); 
			$A.enqueueAction(action);
        }
	},
	doBack : function(cmp, evt, helper){
		var compEvent = cmp.getEvent("commitmentsEvent");
		compEvent.setParams({	"typeMode" : 'BACK'});
		compEvent.fire();
	}
})