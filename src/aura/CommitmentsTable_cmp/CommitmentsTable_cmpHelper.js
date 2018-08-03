({
	getInfo : function(cmp, evt, helper) {
        var action = cmp.get("c.getInfoTable");
        action.setParams({
            "recordId" : cmp.get('v.oppRecordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				var ret = response.getReturnValue();
				var ordenField = ['opp_solution_comt_product_name__c','CurrencyIsoCode','opp_solution_commitment_amount__c','opp_soln_comt_expiry_days_number__c','opp_soln_comt_stay_days_number__c'];
				var objSetup = {'lstHead':[],
								'lstData':[]};
				for(var i in ordenField){
					objSetup['lstHead'].push(ret.schemaSetup.mapLabel[ordenField[i]]);
				}
				for(var i in ret.lstCommitments){
					var row = {'id':ret.lstCommitments[i]['Id'],
								'lstInfo':[]};
					for(var j in ordenField){
						row['lstInfo'].push(ret.lstCommitments[i][ordenField[j]]);
					}
					objSetup['lstData'].push(row);
					
				}
				cmp.set('v.objSetup',objSetup);
				cmp.set('v.isLoad',true);
				cmp.set('v.hasRecord',(ret.lstCommitments.length==0?false:true));
            }
        }); 
        $A.enqueueAction(action);
	},
	continue : function(cmp, evt, helper){
		var compEvent = cmp.getEvent("commitmentsEvent");
		compEvent.setParams({	"typeMode" : 'DOCONTINUE'});
		compEvent.fire();
    }
})